# Sketchybar Configuration Notes

## Setup
- sketchybar v2.23.0
- Right-side vertical bar integrated with AeroSpace window manager
- font-sketchybar-app-font installed via brew (~/Library/Fonts/sketchybar-app-font.ttf)

## Bar Layout (right-side vertical bar)

### Key parameters
- `position=right` works in v2.23 even though `--query bar` reports `position: top`
- `height=N` controls the **width** of the sidebar on screen (not height)
- `y_offset=N` shifts the bar **down** when positive (use to clear the macOS menu bar)
- `margin=N` controls the gap between the bar and the screen edge

### Item layout on a right-side bar
- Items stack **top to bottom** on screen
- `padding_left` = space **above** the item; `padding_right` = space **below**
- `background.height=N` controls the item's **vertical** extent on screen AND its logical slot size (bounding rect height matches background.height)
- `background.border_color=0x00000000` = transparent border (effectively borderless)
- Items are positioned with bounding_rects at the **top level** of `--query` output, not inside `geometry`

### What does NOT work on right-side bars
- **Brackets** (`--add bracket`) render at origin [-9999, -9999] and are invisible — do not use
- Stacking icon + label vertically within a single item is not cleanly achievable; icon always renders left, label always renders right within an item's horizontal content area
- `width=N` on an item does not reliably control vertical extent (background.height does)

## AeroSpace Integration

### Event wiring
- AeroSpace is configured in `~/.config/aerospace/aerospace.toml` to trigger:
  ```
  exec-on-workspace-change = ['/bin/bash', '-c',
      'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE'
  ]
  ```
- Items subscribe to `aerospace_workspace_change` and receive `FOCUSED_WORKSPACE` env var

### Plugin script pattern
- Always fall back to querying aerospace when `FOCUSED_WORKSPACE` is empty:
  ```bash
  if [ -z "$FOCUSED_WORKSPACE" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
  fi
  ```
- This is needed because `sketchybar --update` fires all scripts without event env vars

### Initial state
- After adding all items in `items/spaces.sh`, run a loop to set initial state:
  ```bash
  FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
  for sid in $(aerospace list-workspaces --all); do
    FOCUSED_WORKSPACE="$FOCUSED" "$PLUGIN" "$sid"
  done
  ```

## Current Design (simple workspace indicator)
- One item per workspace: `space.X`
- Borderless roundrect background for all workspaces
- Focused workspace gets a white border
- Click to switch workspace via `click_script="aerospace workspace $sid"`
- Workspaces 1-9 defined as `persistent-workspaces` in aerospace.toml

## Useful commands
```bash
sketchybar --reload          # reload config
sketchybar --query bar       # inspect bar state
sketchybar --query space.5   # inspect a specific item
aerospace list-workspaces --all
aerospace list-workspaces --focused
aerospace list-windows --workspace 5 --format '%{app-bundle-id}'
```
