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

# Set up the shell function for easy access across environments
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
USE_ANSIBLE_SCRIPT="$SCRIPT_DIR/use_ansible.sh"

add_to_rc() {
    local rc_file="$1"
    if [ -f "$rc_file" ]; then
        if ! grep -q "function use_ansible()" "$rc_file"; then
            echo "" >> "$rc_file"
            echo "# Utility to activate Ansible environments (added by ansible-version/setup_all.sh)" >> "$rc_file"
            echo "function use_ansible() {" >> "$rc_file"
            echo "  source \"$USE_ANSIBLE_SCRIPT\" \"\$1\"" >> "$rc_file"
            echo "}" >> "$rc_file"
            echo "Installed use_ansible function to $rc_file"
        else
            # Try to update the path in case the repo was moved or cloned elsewhere
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' "s|source \".*/use_ansible.sh\"|source \"$USE_ANSIBLE_SCRIPT\"|g" "$rc_file"
            else
                sed -i "s|source \".*/use_ansible.sh\"|source \"$USE_ANSIBLE_SCRIPT\"|g" "$rc_file"
            fi
            echo "Updated use_ansible path in $rc_file"
        fi
    fi
}

add_to_rc "$HOME/.bashrc"
add_to_rc "$HOME/.zshrc"

echo "----------------------------------------"
echo "To use an environment, you can now run:"
echo "  use_ansible <version>"
echo "(Note: You may need to run 'source ~/.bashrc' or 'source ~/.zshrc' first if this is a new installation)"
