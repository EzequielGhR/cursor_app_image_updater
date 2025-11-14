#!/bin/bash

# This script is supposed to be sourced.
if [ -z "${BASH_SOURCE[0]}" ]; then
	echo "This script is supposed to be sourced so 'update-cursor' is available as a command."
	return 1
fi

PLATFORM="linux-x64"
RELEASE_TRACK="stable"
OLD_APP_IMAGE_PATH="/opt/cursor/cursor*.AppImage"
TEMP_DIR="${HOME}/cursor_temp"
NEW_APP_IMAGE_PATH="${TEMP_DIR}/cursor.AppImage"

function update-cursor() {
	echo "Checking cursor is not running"
	ps -A | grep -q cursor && {
		echo "Cannot update cursor because it is currently running"
		return 1
	}

	response=$(curl "https://cursor.com/api/download?platform=${PLATFORM}&releaseTrack=${RELEASE_TRACK}")
	if [ -z "${response}" ]
		then echo "Invalid response from server"
		return 1
	fi

	download_url=$(echo $response | jq -r '.downloadUrl')
	if [ -z "${download_url}" ]
		then echo "Could not obtain download url"
		return 1
	fi

	echo "Download url found: ${download_url}"
	mkdir -p "${TEMP_DIR}" && curl -o "${TEMP_DIR}/cursor.AppImage" "${download_url}" || {
		echo "Could not download cursor"
		return 1
	}

	if [ ! -f "${TEMP_DIR}/cursor.AppImage" ]
		then echo "Could not find downloaded app image"
		rm -rf "${TEMP_DIR}"
		return 1
	fi

	sudo rm -rf "${OLD_APP_IMAGE_PATH}" && sudo mv "${TEMP_DIR}/cursor.AppImage" "${NEW_APP_IMAGE_PATH}"
	sudo chmod +x "${NEW_APP_IMAGE_PATH}"

	let success=$?
	if [ $success -eq 0 ]
		then echo "Successfully updated cursor."
	else
		echo "Failed to update cursor"
	fi

	sudo rm -rf "${TEMP_DIR}"

	return $success
}
