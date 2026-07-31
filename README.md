# Ansible Multi-Version Management

This repository provides an automated, structured way to manage and switch between multiple versions of Ansible (from version 5 to 10) using `uv` for lightning-fast Python virtual environment management.

## Repository Structure

- `ansible-[5-10]/`: Each folder corresponds to a major Ansible release. It contains a `pyproject.toml` file that specifies the exact versions of `ansible`, `ansible-core`, and other necessary libraries, along with the required Python version constraints.
- `setup_all.sh`: A shell script that automatically iterates through all version directories, runs `uv sync` in parallel to install dependencies in isolated `.venv` environments, and creates a symlink for the `avm` command in `/usr/local/bin`.
- `avm`: A utility script (Ansible Version Manager) used to quickly switch your shell to a specific Ansible version's virtual environment.

## Prerequisites

- [uv](https://github.com/astral-sh/uv) must be installed.
- Python 3.8 to 3.12 (depending on the Ansible versions you plan to use).

## Setup

To install all Ansible environments and configure the `avm` command globally, run:

```bash
./setup_all.sh
```

This script will:
1. Create a `.venv` folder inside each `ansible-*` directory and install the exact pinned versions in parallel.
2. Link the `avm` utility to `/usr/local/bin/avm` (which may prompt for your `sudo` password).

## Usage

You can use the `avm` command from anywhere in your terminal. There are two ways to switch versions:

### 1. Launch a Subshell (Recommended)
This method starts a new interactive shell session with the requested Ansible version activated. It safely isolates the environment and guarantees correct `$PATH` priority.

```bash
# Example: Start a subshell with Ansible 6
avm 6
```
To exit the virtual environment and return to your original shell, simply type `exit`.

### 2. Modify Current Shell
If you prefer to change the current shell's environment directly, you must use `source`:

```bash
# Example: Activate Ansible 10 in the current shell
source avm 10
```
To exit this environment later, run `deactivate`.

### Help
Run `avm -h` or `avm help` to see a quick reference of available commands and versions.

## Updating Dependencies

If someone adds new libraries to a `pyproject.toml` file (and pushes to the repository), you can pull the latest code and synchronize your local virtual environments by re-running the setup script:

```bash
git pull
./setup_all.sh
```

Because the script uses `uv sync` under the hood, it will incredibly quickly detect the changes in `pyproject.toml` and download only the new libraries, keeping your `.venv` perfectly up to date. Alternatively, to sync a single environment:

```bash
cd ansible-5
uv sync
```
