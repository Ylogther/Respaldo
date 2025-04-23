#!/bin/bash

# Comprobación de dependencias
for dep in wine winetricks firejail inotifywait lsof figlet xdotool xterm zenity; do
    if ! command -v "$dep" &> /dev/null; then
        echo "[!] Dependencia faltante: $dep"
        echo "    Intenta instalarla con: sudo pacman -S $dep"
        exit 1
    fi
done

clear

# Mostrar banner en terminal
figlet -w 120 "YLOGTHER" | sed 's/#/*/g'
echo -e "\n\t\t\t\tAsegura tu Linux"
echo

# Variables para log
DATE="$(date '+%a %b %d %I:%M:%S %p %Z %Y')"
TIMESTAMP="$(date '+%H-%M-%S')"
BASENAME="$(basename "$1")"
LOGFILE="$HOME/wine-logs/analisis_${BASENAME%.*}-$TIMESTAMP.log"

mkdir -p "$HOME/wine-logs"

# Registrar encabezado en el log
{
    echo "============================================================"
    figlet -w 100 "YLOGTHER" | sed 's/#/*/g'
    echo -e "\n\t\t\tAsegura tu Linux"
    echo "============================================================"
    echo -e "\nInicio del análisis: $DATE"
    echo "[*] Observando cambios de archivos y red..."
} >> "$LOGFILE"

EXE_PATH="$(realpath "$1")"
EXE_NAME="$(basename "$1")"
EXE_DIR="$(dirname "$EXE_PATH")"
WINE_GAME_PREFIX="$HOME/wine-juegos"
WINE_SANDBOX_PREFIX="$HOME/wine-sandbox"
LOG_DIR="$HOME/wine-logs"
HASH=$(sha256sum "$EXE_PATH" | cut -d ' ' -f1)
SIZE=$(stat -c%s "$EXE_PATH")
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$LOG_DIR/analisis_$EXE_NAME-$TIMESTAMP.log"
START_TIME=$(date +%s)

if [ -z "$1" ]; then
  echo "Uso: ./smart_launcher.sh archivo.exe"
  exit 1
fi

mkdir -p "$WINE_GAME_PREFIX" "$WINE_SANDBOX_PREFIX" "$LOG_DIR"

# Análisis heurístico mejorado
echo "[*] Analizando el archivo $1..."
EXT=$(echo "$1" | awk -F. '{print tolower($NF)}')
IS_SUSPICIOUS=0

# Verificar extensión sospechosa
if [[ "$EXT" != "exe" && "$EXT" != "msi" ]]; then
    echo "[!] Extensión inusual: .$EXT" | tee -a "$LOGFILE"
    IS_SUSPICIOUS=1
fi

# Buscar strings sospechosas
if strings "$1" | grep -Eiq "powershell|cmd\.exe|curl|wget|Invoke-WebRequest|CreateRemoteThread|VirtualAlloc"; then
    echo "[!] Comportamiento sospechoso detectado en cadenas internas (strings)" | tee -a "$LOGFILE"
    IS_SUSPICIOUS=1
fi

# Revisar si es un archivo PE válido
if ! file "$1" | grep -qi "PE32"; then
    echo "[!] El archivo no parece ser un ejecutable PE válido" | tee -a "$LOGFILE"
    IS_SUSPICIOUS=1
fi

# Heurísticas simples
[[ "$EXE_NAME" =~ (hack|crack|keygen|setup|activator|patch|loader) ]] && IS_SUSPICIOUS=1
[ "$SIZE" -lt 200000 ] && IS_SUSPICIOUS=1

# Mostrar resumen
echo "Archivo: $EXE_NAME"
echo "SHA256 : $HASH"
echo "Tamaño : $((SIZE / 1024)) KB"

if [[ "$IS_SUSPICIOUS" -eq 1 ]]; then
    echo -e "\n[!] Este archivo parece sospechoso. Se recomienda modo análisis."
    recomendacion="1"
else
    echo -e "\n[*] El archivo parece legítimo. Se recomienda modo juego."
    recomendacion="2"
fi

echo ""
echo "¿Cómo quieres ejecutar $EXE_NAME?"
echo "1) Análisis seguro (sandbox)"
echo "2) Ejecutar como juego (persistente)"
echo "3) Salir"
read -p "Elige una opción [1-3] (sugerido: $recomendacion): " opcion

opcion=${opcion:-$recomendacion}