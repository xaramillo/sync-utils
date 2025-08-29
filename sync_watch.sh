#!/bin/bash

# Configuración
REMOTE_USER="tu_usuario_lenovo"
REMOTE_HOST="ip_de_tu_lenovo"
REMOTE_PATH="/home/$REMOTE_USER/sbx/"
LOCAL_PATH="/ruta/a/tus/repos/en/mac/"
SSH_KEY="/Users/tu_usuario_mac/.ssh/id_rsa"
SYNC_INTERVAL=60  # Segundos entre sincronizaciones

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Iniciando monitoreo continuo...${NC}"
echo -e "${YELLOW}Sincronizando cada $SYNC_INTERVAL segundos${NC}"
echo "Presiona Ctrl+C para detener"

while true; do
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] Verificando cambios...${NC}"
    
    # Sincronizar cambios desde Lenovo a Mac
    rsync -avz --progress -e "ssh -i $SSH_KEY" \
        --exclude='.git/' \
        --exclude='node_modules/' \
        --exclude='.DS_Store' \
        --exclude='*.log' \
        --exclude='.vscode/' \
        --update \
        "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH" "$LOCAL_PATH"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[$(date '+%H:%M:%S')] Sincronización completada${NC}"
    else
        echo -e "${RED}[$(date '+%H:%M:%S')] Error en sincronización${NC}"
    fi
    
    sleep $SYNC_INTERVAL
done
