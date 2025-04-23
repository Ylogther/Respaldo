#!/bin/bash

EXE_PATH="$(realpath "$1")"
EXE_NAME="$(basename "$1")"
WINE_GAME_PREFIX="$HOME/wine-juegos"
WINE_SANDBOX_PREFIX="$HOME/wine-sandbox"
LOG_DIR="$HOME/wine-logs"
HASH=$(sha256sum "$EXE_PATH" | cut -d ' ' -f1)
SIZE=$(stat -c%s "$EXE_PATH")
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$LOG_DIR/analisis_$EXE_NAME-$TIMESTAMP.log"

if [ -z "$1" ]; then
  echo "Uso: ./smart_launcher.sh archivo.exe"
  exit 1
fi

mkdir -p "$WINE_GAME_PREFIX" "$WINE_SANDBOX_PREFIX" "$LOG_DIR"

# Heurísticas simples
sospechoso=0
[[ "$EXE_NAME" =~ (hack|crack|keygen|setup|activator|patch|loader) ]] && sospechoso=1
[ "$SIZE" -lt 200000 ] && sospechoso=1  # menor de 200KB

echo "Archivo: $EXE_NAME"
echo "SHA256 : $HASH"
echo "Tamaño : $((SIZE / 1024)) KB"

if [ $sospechoso -eq 1 ]; then
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

case "$opcion" in
  1)
    echo "[*] Ejecutando en modo análisis..."
    [ ! -f "$WINE_SANDBOX_PREFIX/system.reg" ] && WINEPREFIX="$WINE_SANDBOX_PREFIX" winecfg > /dev/null 2>&1
    firejail --quiet --net=none --private --env=WINEPREFIX="$WINE_SANDBOX_PREFIX" wine "$EXE_PATH" &
    WINE_PID=$!
    VISTOS=()
    echo "Inicio del análisis: $(date)" > "$LOG_FILE"
    while kill -0 "$WINE_PID" 2>/dev/null; do
      echo "--- $(date +%H:%M:%S) ---" >> "$LOG_FILE"
      for PID in $(pstree -p "$WINE_PID" | grep -oP '\(\d+\)' | tr -d '()'); do
        if [[ ! " ${VISTOS[*]} " =~ " $PID " ]]; then
          INFO=$(ps -p "$PID" -o pid=,comm=,args= --no-headers)
          echo "$INFO" | tee -a "$LOG_FILE"
          VISTOS+=("$PID")
        fi
      done
      sleep 2
    done
    echo "[*] Análisis terminado. Log guardado en: $LOG_FILE"
    ;;

  2)
    echo "[*] Ejecutando en modo juego..."
    [ ! -f "$WINE_GAME_PREFIX/system.reg" ] && WINEPREFIX="$WINE_GAME_PREFIX" winecfg > /dev/null 2>&1
    WINEPREFIX="$WINE_GAME_PREFIX" wine "$EXE_PATH"
    ;;

  3)
    echo "Saliendo..."
    exit 0
    ;;

  *)
    echo "Opción inválida."
    exit 1
    ;;
esac
