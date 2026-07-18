# Ansible Multi-Version Management

This repository provides an automated, structured way to manage and switch between multiple versions of Ansible (from version 5 to 10) using `uv` for lightning-fast Python virtual environment management.

## Repository Structure

- `ansible-[5-10]/`: Each folder corresponds to a major Ansible release. It contains a `pyproject.toml` file that specifies the exact versions of `ansible`, `ansible-core`, and `Jinja2`, along with the required Python version constraints.
- `setup_all.sh`: A shell script that automatically iterates through all version directories and runs `uv sync` to install dependencies in isolated `.venv` environments.
- `use_ansible.sh`: A utility script used to quickly switch your current shell to a specific Ansible version's virtual environment.

## Prerequisites

- [uv](https://github.com/astral-sh/uv) must be installed.
- Python 3.8 to 3.12 (depending on the Ansible versions you plan to use).

## Setup

To install all Ansible environments, simply run:

```bash
./setup_all.sh
```

This will create a `.venv` folder inside each `ansible-*` directory and install the exact pinned versions.

## Usage

To switch to a specific version of Ansible, **source** the `use_ansible.sh` script and pass the version number (5, 6, 7, 8, 9, or 10) as the argument:

```bash
# Example: Switch to Ansible 10
source use_ansible.sh 10

# Example: Switch to Ansible 7
source use_ansible.sh 7
```

> **Note:** You must use `source` (hoặc `.`) instead of running it directly as `./use_ansible.sh`. This allows the script to modify the `$PATH` of your current shell.

To exit the virtual environment and return to your system's default environment, run:

```bash
deactivate
```
