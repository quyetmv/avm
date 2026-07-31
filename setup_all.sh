#!/bin/bash

# Ensure script fails if any command fails
set -e

# Define the ansible versions we have
versions=("5" "6" "7" "8" "9" "10")

echo "Setting up environments using uv in parallel..."
for v in "${versions[@]}"; do
    if [ -d "ansible-$v" ]; then
        echo "Starting installation for ansible-$v..."
        (
            log_file="../setup_ansible_${v}.log"
            cd "ansible-$v"
            if uv sync > "$log_file" 2>&1; then
                echo "✅ ansible-$v installed successfully."
                rm -f "$log_file"
            else
                echo "❌ Failed to install ansible-$v. Check setup_ansible_${v}.log for details."
            fi
        ) &
    else
        echo "Directory ansible-$v not found. Skipping..."
    fi
done

# Wait for all background processes to finish
wait

echo "----------------------------------------"
echo "All environments setup complete!"

# Create a symlink to /usr/local/bin/avm for easy global access
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
AVM_SCRIPT="$SCRIPT_DIR/avm"

echo "----------------------------------------"
echo "Setting up avm executable in /usr/local/bin..."

if [ -w "/usr/local/bin" ]; then
    ln -sf "$AVM_SCRIPT" /usr/local/bin/avm
    LINK_SUCCESS=$?
else
    echo "This may require your sudo password."
    if command -v sudo >/dev/null 2>&1; then
        sudo ln -sf "$AVM_SCRIPT" /usr/local/bin/avm
        LINK_SUCCESS=$?
    else
        LINK_SUCCESS=1
    fi
fi

if [ $LINK_SUCCESS -eq 0 ]; then
    echo "Successfully linked avm to /usr/local/bin/avm"
    echo "----------------------------------------"
    echo "To use an environment, you can now run:"
    echo "  avm <version>"
else
    echo "Failed to link avm. Please run this command manually:"
    echo "  sudo ln -sf $AVM_SCRIPT /usr/local/bin/avm"
fi
