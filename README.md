# cursor_app_image_updater

This is a simple script to update the cursor app image on Linux x64.

## Configuration
In [updater.sh](./updater.sh) you can configure different variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `PLATFORM` | Platform/architecture for the download | `linux-x64` |
| `RELEASE_TRACK` | Release track (stable, beta, etc.) | `stable` |
| `OLD_APP_IMAGE_PATH` | Path pattern to the existing cursor AppImage | `/opt/cursor/cursor*.AppImage` |
| `TEMP_DIR` | Temporary directory for downloading the new AppImage | `${HOME}/cursor_temp` |
| `NEW_APP_IMAGE_PATH` | Path where the new AppImage will be placed | `${TEMP_DIR}/cursor.AppImage` |

## Usage

Source the script (`. updater.sh`) and then you can use the command `update-cursor`. It will prompt you for `sudo` privileges when it attempts to move the temporary app image to its final location (defaults to `/opt`).