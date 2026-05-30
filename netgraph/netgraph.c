#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <math.h>
#include <string.h>
#include <inttypes.h>

#define HISTORY_SIZE 30

const char *bars[] = {
    "▁",
    "▂",
    "▃",
    "▄",
    "▅",
    "▆",
    "▇",
    "█"
};

int detect_default_interface(char *iface, size_t size)
{
    FILE *fp = fopen("/proc/net/route", "r");

    if (!fp)
        return -1;

    char line[256];

    fgets(line, sizeof(line), fp);

    while (fgets(line, sizeof(line), fp))
    {
        char ifname[64];
        unsigned long destination;

        if (sscanf(line,
                    "%63s %lx",
                    ifname,
                    &destination) == 2)
        {
            if (destination == 0)
            {
                snprintf(
                        iface,
                        size,
                        "%s",
                        ifname);

                fclose(fp);

                return 0;
            }
        }
    }

    fclose(fp);

    return -1;
}

uint64_t read_counter(const char *path)
{
    FILE *fp = fopen(path, "r");

    if (!fp)
        return 0;

    uint64_t value = 0;

    fscanf(fp, "%" SCNu64, &value);

    fclose(fp);

    return value;
}

const char *get_bar(double speed, double max_speed)
{
    int count =
        sizeof(bars) /
        sizeof(bars[0]);

    if (speed < 0.01)
        speed = 0.01;

    double normalized =
        log10(speed + 1.0) /
        log10(max_speed + 1.0);

    int idx =
        (int)(normalized * count);

    if (idx < 0)
        idx = 0;

    if (idx >= count)
        idx = count - 1;

    return bars[idx];
}

const char *get_color(
        double speed,
        double max_speed)
{
    double normalized =
        log10(speed + 1.0) /
        log10(max_speed + 1.0);

    if (normalized < 0.25)
        return "#7aa2f7";

    if (normalized < 0.50)
        return "#9ece6a";

    if (normalized < 0.75)
        return "#e0af68";

    return "#f7768e";
}

char *append_colored_bar(
        char *p,
        size_t remaining,
        double speed,
        double max_speed)
{
    int written =
        snprintf(
                p,
                remaining,
                "%%{F%s}%s%%{F-}",
                get_color(
                    speed,
                    max_speed),
                get_bar(
                    speed,
                    max_speed));

    if (written < 0)
        return p;

    return p + written;
}

void build_history(
        double history[],
        int current_pos,
        char *buffer,
        size_t size,
        double max_speed)
{
    char *p = buffer;

    size_t remaining = size;

    for (int i = 0; i < HISTORY_SIZE; i++)
    {
        int idx =
            (current_pos + i) %
            HISTORY_SIZE;

        char *new_p =
            append_colored_bar(
                    p,
                    remaining,
                    history[idx],
                    max_speed);

        remaining -=
            (size_t)(new_p - p);

        p = new_p;

        if (remaining <= 1)
            break;
    }

    *p = '\0';
}

void parse_args(
        int argc,
        char **argv,
        char *iface,
        size_t iface_size,
        double *max_speed,
        double *interval)
{
    for (int i = 1; i < argc; i++)
    {
        if (!strcmp(argv[i], "-h") ||
                !strcmp(argv[i], "--help"))
        {
            printf(
                    "Usage: netgraph [options]\n"
                    "\n"
                    "Options:\n"
                    "  -i <iface>    Network interface\n"
                    "  -m <mbps>     Max speed (default 100)\n"
                    "  -t <seconds>  Refresh interval (default 0.3)\n"
                    "  -h            Show help\n");

            exit(0);
        }
        if (!strcmp(argv[i], "-i") &&
                i + 1 < argc)
        {
            snprintf(
                    iface,
                    iface_size,
                    "%s",
                    argv[++i]);
        }
        else if (!strcmp(argv[i], "-m") &&
                i + 1 < argc)
        {
            *max_speed =
                atof(argv[++i]);
        }
        else if (!strcmp(argv[i], "-t") &&
                i + 1 < argc)
        {
            *interval =
                atof(argv[++i]);
        }
    }
}

int main(int argc, char **argv)
{
    char iface[64] = "";

    double max_speed = 100.0;
    double interval = 0.3;

    parse_args(
            argc,
            argv,
            iface,
            sizeof(iface),
            &max_speed,
            &interval);

    if (max_speed <= 0)
    {
        fprintf(
                stderr,
                "Invalid max speed\n");

        return 1;
    }

    if (interval <= 0)
    {
        fprintf(
                stderr,
                "Invalid interval\n");

        return 1;
    }

    if (iface[0] == '\0')
    {
        if (detect_default_interface(
                    iface,
                    sizeof(iface)) != 0)
        {
            fprintf(
                    stderr,
                    "Unable to detect interface\n");

            return 1;
        }
    }

    char rx_file[256];
    char tx_file[256];

    snprintf(
            rx_file,
            sizeof(rx_file),
            "/sys/class/net/%s/statistics/rx_bytes",
            iface);

    snprintf(
            tx_file,
            sizeof(tx_file),
            "/sys/class/net/%s/statistics/tx_bytes",
            iface);

    fprintf(stderr,
            "Using interface: %s\n",
            iface);

    double history_down[HISTORY_SIZE] = {0};
    double history_up[HISTORY_SIZE] = {0};

    double smooth_down = 0.0;
    double smooth_up = 0.0;

    int history_pos = 0;

    uint64_t rx_prev =
        read_counter(rx_file);

    uint64_t tx_prev =
        read_counter(tx_file);

    char down_history[2048];
    char up_history[2048];

    while (1)
    {
        usleep((useconds_t)(interval * 1000000));

        uint64_t rx_now =
            read_counter(rx_file);

        uint64_t tx_now =
            read_counter(tx_file);

        double rx_delta =
            (double)(rx_now - rx_prev);

        double tx_delta =
            (double)(tx_now - tx_prev);

        double down_raw =
            rx_delta *
            8.0 /
            interval /
            1000000.0;

        double up_raw =
            tx_delta *
            8.0 /
            interval /
            1000000.0;

        smooth_down =
            smooth_down * 0.35 +
            down_raw * 0.65;

        smooth_up =
            smooth_up * 0.35 +
            up_raw * 0.65;

        double down = smooth_down;
        double up = smooth_up;

        rx_prev = rx_now;
        tx_prev = tx_now;

        history_down[history_pos] =
            down;

        history_up[history_pos] =
            up;

        history_pos =
            (history_pos + 1) %
            HISTORY_SIZE;

        build_history(
                history_down,
                history_pos,
                down_history,
                sizeof(down_history),
                max_speed);

        build_history(
                history_up,
                history_pos,
                up_history,
                sizeof(up_history),
                max_speed);

        printf(
                "%%{F#9ece6a}%5.1f Mb/s %%{F-}%s "
                "%%{F#9ece6a}󰁅%%{F-} "
                "%%{F#9ece6a}%5.1f Mb/s %%{F-}%s "
                "%%{F#9ece6a}󰁝%%{F-}\n",
                down,
                down_history,
                up,
                up_history);

        fflush(stdout);
    }

    return 0;
}
