/*
 * audiograph
 *
 * 12 bande LEFT + 12 bande RIGHT
 * Output CAVA stereo per Polybar
 */

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_BARS 24
#define MAX_VALUE 31.0

const char *bars[] = {"▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"};

const char *colors[] = {"#565f89", "#6676a8", "#7289c7", "#7aa2f7",
                        "#89b4fa", "#a6c1ff", "#c0caf5", "#dbe3ff"};

int main(void) {
  FILE *fifo = fopen("/tmp/audiograph/cava_fifo", "r");

  if (!fifo) {
    perror("fopen");
    return 1;
  }

  char line[512];

  double smooth[MAX_BARS] = {0};

  while (fgets(line, sizeof(line), fifo)) {

    int idx = 0;

    char *token = strtok(line, ";");

    while (token && idx < MAX_BARS) {

      int value = atoi(token);

      if (value < 0)
        value = 0;

      if (value > (int)MAX_VALUE)
        value = (int)MAX_VALUE;

      smooth[idx] = smooth[idx] * 0.35 + value * 0.65;

      double adjusted = smooth[idx];

      if (idx >= 18)
        adjusted *= 1.20;

      if (adjusted > MAX_VALUE)
        adjusted = MAX_VALUE;

      double normalized = pow(adjusted / MAX_VALUE, 0.90);
      normalized += 0.04;

      int display = (int)(normalized * 7.0 + 0.5);

      if (display < 0)
        display = 0;

      if (display > 7)
        display = 7;

      printf("%%{F%s}%s%%{F-}", colors[display], bars[display]);

      token = strtok(NULL, ";");

      idx++;
    }

    putchar('\n');
    fflush(stdout);
  }

  fclose(fifo);

  return 0;
}
