#!/bin/bash

# Ensure script fails if any command fails
set -e

# Define the ansible versions we have
versions=("5" "6" "7" "8" "9" "10")

echo "Setting up environments using uv..."
for v in "${versions[@]}"; do
    if [ -d "ansible-$v" ]; then
        echo "----------------------------------------"
        echo "Installing ansible-$v environment..."
        (cd "ansible-$v" && uv sync)
        echo "ansible-$v installed successfully."
    else
        echo "Directory ansible-$v not found. Skipping..."
    fi
done
echo "----------------------------------------"
echo "All environments setup complete!"
echo "To use an environment, run: source use_ansible.sh <version>"
