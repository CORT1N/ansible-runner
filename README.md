# ansible-runner
Simple containerized runner based on alpine with pre-installed ansible packet.

## Installation from sources (with aliases)
I recommend this method.
```bash
git clone https://github.com/CORT1N/ansible-runner.git
cd ansible-runner
./setup.sh
```

This installation method will build **ansible-runner:1.0.0** Docker image and add aliases for ansible commands in supported source files.

### Supported source files : *bashrc* and *zshrc*.

## Installation from Docker Hub (without automatic aliases adding)
```bash
docker pull cort1n/ansible-runner:1.0.0
```

## Usage
### With aliases
After installation, you know have access to `ansible`, `ansible-playbook` and `ansible-vault` commands in aliases, which will run a disposable instance of the image built previously, mounted on your working directory.

### Without aliases
```bash
# The container will stay up
docker run -it -v $(pwd):/workspace -w /workspace -v $HOME/.ssh:/root/.ssh ansible-runner:1.0.0
# The container will be destroyed after exiting it
docker run -it --rm -v $(pwd):/workspace -w /workspace -v $HOME/.ssh:/root/.ssh ansible-runner:1.0.0
```