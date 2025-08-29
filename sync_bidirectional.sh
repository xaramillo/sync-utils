#!/bin/bash

# Configuración (misma que los scripts anteriores)
REMOTE_USER="tu_usuario_lenovo"
REMOTE_HOST="ip_de_tu_lenovo"
REMOTE_PATH="/home/$REMOTE_USER/sbx/"
LOCAL_PATH="/ruta/a/tus/repos/en/mac/"
SSH_KEY="/Users/tu_usuario_mac/.ssh/id_rsa"

echo "Sincronizando desde Mac → Lenovo..."

rsync -avz --progress -e "ssh -i $SSH_KEY" \
    --exclude='.git/' \
    --exclude='node_modules/' \
    --exclude='.DS_Store' \
    --exclude='*.log' \
    --exclude='.vscode/' \
    "$LOCAL_PATH" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"

echo "Sincronización completada"
