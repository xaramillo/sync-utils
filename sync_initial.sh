#!/bin/bash

# Configuración
REMOTE_USER="nombre_de_usuario"
REMOTE_HOST="ip_local"  # Ej: 192.168.1.100
REMOTE_PATH="/home/$REMOTE_USER/sbx/"
MAC_USER="usuario_de_mac"
LOCAL_PATH="/Users/$MAC_USER/Documents/GitHub/"
SSH_KEY="/Users/$MAC_USER/.ssh/id_rsa"  # Ruta a tu clave SSH

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Iniciando sincronización inicial...${NC}"

# Verificar si la ruta local existe
if [ ! -d "$LOCAL_PATH" ]; then
    echo -e "${RED}Error: La ruta local $LOCAL_PATH no existe${NC}"
    exit 1
fi

# Verificar conexión SSH
echo -e "${YELLOW}Verificando conexión con la Lenovo...${NC}"
ssh -i "$SSH_KEY" -q "$REMOTE_USER@$REMOTE_HOST" exit
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: No se puede conectar vía SSH a la Lenovo${NC}"
    echo "Asegúrate de:"
    echo "1. Tener SSH configurado entre las máquinas"
    echo "2. La IP de la Lenovo es correcta"
    echo "3. Las claves SSH están configuradas correctamente"
    exit 1
fi

# Crear directorio remoto si no existe
echo -e "${YELLOW}Creando directorio remoto...${NC}"
ssh -i "$SSH_KEY" "$REMOTE_USER@$REMOTE_HOST" "mkdir -p $REMOTE_PATH"
ssh -i "$SSH_KEY" "$REMOTE_USER@$REMOTE_HOST" "touch $REMOTE_PATH/conn_success"

# Comprobando rsync
/usr/bin/rsync --version

# Sincronizar usando rsync
echo -e "${YELLOW}Sincronizando archivos...${NC}"
/usr/bin/rsync -avz --progress -e "ssh -i $SSH_KEY" --exclude='.git/' --exclude='node_modules/' --exclude='.DS_Store' --exclude='*.log' --exclude='.vscode/' "$LOCAL_PATH" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Sincronización inicial completada con éxito${NC}"
else
    echo -e "${RED}✗ Error durante la sincronización${NC}"
    exit 1
fi
