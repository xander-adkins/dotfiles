#!/bin/bash

set -e

echo "Stopping the Podman machine..."
podman machine stop

echo "Removing the Podman machine..."
podman machine rm --force

echo "Initializing a new Podman machine..."
podman machine init

echo "Starting the Podman machine..."
podman machine start

echo "Podman machine restarted successfully."
