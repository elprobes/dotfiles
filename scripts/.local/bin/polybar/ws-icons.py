#!/usr/bin/env python3

import i3ipc

# -------------------------------------------------
# ICONS
# -------------------------------------------------

ICONS = {
    "firefox": "",
    "chromium": "",
    "discord": "",
    "spotify": "",
    "steam": "",
    "obsidian": "󰠮",
    "code": "󰨞",
    "kitty": "",
    "foot": "",
    "alacritty": "",
    "thunar": "󰉋",
    "pavucontrol": "󰕾",
    "vlc": "󰕼",
    "mpv": "󰐹",
    "jetbrains-studio": "",
    "xfreerdp": "",
    "telegramdesktop": "",
    "web.whatsapp.com": "",
    "qutebrowser": "",
}

DEFAULT_ICON = "󱂬"

# -------------------------------------------------
# COLORS
# -------------------------------------------------

FOCUSED_FG = "#c0caf5"
FOCUSED_BG = "#2f334d"
FOCUSED_UNDERLINE = "#7aa2f7"

UNFOCUSED_FG = "#565f89"

URGENT_FG = "#111111"
URGENT_BG = "#f7768e"
URGENT_UNDERLINE = "#f7768e"

# -------------------------------------------------
# GET ICON
# -------------------------------------------------

def get_icon(window):

    wm_class = window.window_class or ""
    wm_instance = window.window_instance or ""

    combined = f"{wm_class} {wm_instance}".lower()

    for key, icon in ICONS.items():

        if key.lower() in combined:
            return icon

    return DEFAULT_ICON

# -------------------------------------------------
# FORMAT WORKSPACE
# -------------------------------------------------

def format_workspace(content, focused=False, urgent=False):

    if urgent:

        return (
            f"%{{B{URGENT_BG}}}"
            f"%{{u{URGENT_UNDERLINE}}}"
            f"%{{+u}}"
            f"%{{F{URGENT_FG}}}"
            f" {content} "
            f"%{{F-}}"
            f"%{{-u}}"
            f"%{{B-}}"
        )

    if focused:

        return (
            f"%{{B{FOCUSED_BG}}}"
            f"%{{u{FOCUSED_UNDERLINE}}}"
            f"%{{+u}}"
            f"%{{F{FOCUSED_FG}}}"
            f" {content} "
            f"%{{F-}}"
            f"%{{-u}}"
            f"%{{B-}}"
        )

    return (
        f"%{{F{UNFOCUSED_FG}}}"
        f" {content} "
        f"%{{F-}}"
    )

# -------------------------------------------------
# RENDER
# -------------------------------------------------

def render(i3):

    outputs = []

    # stato reale dei workspace
    workspaces = sorted(
        i3.get_workspaces(),
        key=lambda w: w.num
    )

    tree = i3.get_tree()

    for ws in workspaces:

        icons = []

        for window in tree.leaves():

            workspace = window.workspace()

            if workspace is None:
                continue

            if workspace.name != ws.name:
                continue

            if window.window_class is None:
                continue

            icon = get_icon(window)

            # remove duplicates
            if icon not in icons:
                icons.append(icon)

        if not icons:
            icons.append(DEFAULT_ICON)

        content = (
            "%{T3}"
            + " ".join(icons)
            + "%{T-}"
        )

        # CLICKABLE
        start = (
            f"%{{A1:i3-msg workspace number {ws.num}:}}"
        )

        end = "%{A}"

        # STYLE
        formatted = format_workspace(
            content,
            focused=ws.focused,
            urgent=ws.urgent
        )

        outputs.append(start + formatted + end)

    print("  ".join(outputs), flush=True)

# -------------------------------------------------
# MAIN
# -------------------------------------------------

i3 = i3ipc.Connection()

render(i3)

def on_event(i3, event):
    render(i3)

i3.on("window", on_event)
i3.on("workspace", on_event)

i3.main()
