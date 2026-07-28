#!/bin/bash
# Usage: source use_ansible.sh <version>

# Check if the script is being sourced
(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0
if [ "$SOURCED" -eq 0 ]; then
    echo "Error: This script MUST be sourced to change your current shell's environment."
    echo "Please run it as: source ${0} <version>"
    echo "Do NOT use 'bash ${0} <version>'."
    exit 1
fi

# Define script directory relative to where it was sourced.
# BASH_SOURCE is unset when sourced from zsh, so fall back to zsh's %N.
if [ -n "${BASH_SOURCE:-}" ]; then
    SCRIPT_PATH="${BASH_SOURCE[0]}"
elif [ -n "${ZSH_VERSION:-}" ]; then
    SCRIPT_PATH="${(%):-%N}"
else
    SCRIPT_PATH="$0"
fi
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" &> /dev/null && pwd)"

if [ -z "$1" ]; then
    echo "Error: Please specify an Ansible version: 5, 6, 7, 8, 9, 10"
    echo "Usage: source use_ansible.sh <version>"
    return 1 2>/dev/null || exit 1
fi

VERSION=$1
case "$VERSION" in
    5|6|7|8|9|10) ;;
    *)
        echo "Error: Invalid Ansible version '$VERSION'. Valid versions: 5, 6, 7, 8, 9, 10"
        echo "Usage: source use_ansible.sh <version>"
        return 1 2>/dev/null || exit 1
        ;;
esac

TARGET_DIR="$SCRIPT_DIR/ansible-$VERSION"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory $TARGET_DIR does not exist."
    return 1 2>/dev/null || exit 1
fi

if [ ! -f "$TARGET_DIR/.venv/bin/activate" ]; then
    echo "Error: Virtual environment not found in $TARGET_DIR."
    echo "Please run './setup_all.sh' first or 'uv sync' in that directory."
    return 1 2>/dev/null || exit 1
fi

# Deactivate current venv if one is active
if type deactivate &> /dev/null; then
    deactivate
fi

source "$TARGET_DIR/.venv/bin/activate"
echo "Successfully switched to Ansible $VERSION environment"
ansible --version | head -n 3
