#!/bin/bash

set -e

IMAGE_NAME="ansible-runner"
IMAGE_TAG="1.1.0"

# Building image
echo "Building Docker image..."
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

# Adding aliases
CURRENT_SHELL=$(basename "$SHELL")
ANSIBLE_COMMANDS=("ansible" "ansible-playbook" "ansible-vault")

case $CURRENT_SHELL in
bash)
    SHELL_CONFIG="$HOME/.bashrc"
    ;;
zsh)
    SHELL_CONFIG="$HOME/.zshrc"
    ;;
*)
    echo "Shell $CURRENT_SHELL non pris en charge. Ajoutez manuellement l'alias suivant à votre fichier de configuration du shell :"
    echo "$ALIAS_COMMAND"
    exit 1
    ;;
esac

for command in "${ANSIBLE_COMMANDS[@]}"; do
    ALIAS_COMMAND="alias $command='docker run --rm -it -v \"\$(pwd)\":/workspace -w /workspace -v \$HOME/.ssh:/root/.ssh -e ANSIBLE_USER=\$ANSIBLE_USER ${IMAGE_NAME}:${IMAGE_TAG} $command'"
    # ANSIBLE_USER environment variable is optional, and can be used in some workflows where you play with ansible with multiple users

    if ! grep -Fxq "$ALIAS_COMMAND" "$SHELL_CONFIG"; then
        echo "Adding alias to $SHELL_CONFIG..."
        echo "" >> "$SHELL_CONFIG"
        echo "$ALIAS_COMMAND" >> "$SHELL_CONFIG"
    else
        echo "Alias for $command already exists in $SHELL_CONFIG."
    fi
done

# Reloading shell
echo "Reloading shell configuration..."
source "$SHELL_CONFIG"

echo "Setup complete! You can now use 'ansible', 'ansible-playbook' and 'ansible-vault' as aliases to run your Ansible container."