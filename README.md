```markdown
# SmartLauncher - Ejecuta archivos `.exe` con seguridad en Linux

**Desarrollado por YLOGTHER**

SmartLauncher es un script bash que permite ejecutar archivos `.exe` en Linux usando Wine, con un enfoque dual:

- **Modo Análisis Seguro** (tipo sandbox): para archivos sospechosos o desconocidos
- **Modo Juego Persistente**: para aplicaciones confiables que quieras usar o jugar normalmente

Este entorno simula parte de las capacidades de plataformas, permitiendo observar procesos, cambios en archivos y posibles intentos de conexión de red.

---

## Características Principales

- **Entorno aislado con Firejail** sin acceso a internet ni al resto del sistema
- **Análisis heurístico** para detectar archivos potencialmente maliciosos
- **Monitoreo en tiempo real** de procesos y archivos modificados
- **Registros detallados (logs)** de cada ejecución
- **Modo persistente opcional** para disfrutar de juegos de forma segura
- **Compatible con Arch Linux y derivados**

---

## Requisitos

Debes tener estas herramientas instaladas en tu sistema:


```bash
sudo pacman -S wine winetricks firejail inotify-tools lsof figlet xdotool xterm zenity

```

## Instalación de dependencias

Este script fue diseñado y probado principalmente en *Arch Linux*. Sin embargo, también puede funcionar en otras distribuciones si se instalan las herramientas necesarias.

### En Arch Linux y derivados (Manjaro, EndeavourOS, etc.)
Ejecuta:

```bash
   sudo pacman -S wine winetricks firejail inotify-tools lsof figlet xdotool xterm zenity
```
### En Debian, Ubuntu y derivados:
Ejecuta:

```bash
sudo apt update
sudo apt install wine winetricks firejail inotify-tools lsof figlet xdotool xterm zenity
```

### En Fedora:
```bash
sudo dnf install wine winetricks firejail inotify-tools lsof figlet xdotool xterm zenity
```

### En openSUSE:
```bash
sudo zypper install wine winetricks firejail inotify-tools lsof figlet xdotool xterm zenity
```

> *Nota*: Algunas distribuciones podrían usar diferentes nombres de paquetes o necesitar habilitar repositorios adicionales (como multilib para wine en Arch).

---

## Cómo usarlo

1. Descarga el script:
   ```bash
   git clone https://github.com/Ylogther/ejecutar-wine-con-y-sin-entorno-seguro.git
   cd ejecutar-wine-con-y-sin-entorno-seguro
   chmod +x smart_launcher.sh
   ```

2. Ejecuta el script pasándole el archivo `.exe` que deseas analizar o jugar:
   ```bash
   ./smart_launcher.sh MiPrograma.exe
   ```

3. El script analizará el archivo:
   - Hash SHA256
   - Tamaño
   - Nombre sospechoso
   - Tipo de ejecución recomendada

4. Elige una opción:
   - **1**: Modo análisis seguro (con sandbox)
   - **2**: Modo juego persistente
   - **3**: Salir

---

## Archivos y Directorios

- Los logs se guardan en: `~/wine-logs/`
- Prefijos Wine separados:
  - Análisis seguro: `~/wine-sandbox`
  - Juegos persistentes: `~/wine-juegos`

---

## Nivel de Seguridad

Este script aísla procesos usando Firejail, sin acceso a red y en un entorno privado. Sin embargo:

> **Advertencia**: Aunque ofrece una buena capa de protección, no es infalible. Malware avanzado podría aprovechar vulnerabilidades en Wine o Firejail para escapar del entorno. Para máxima seguridad, usa una **máquina virtual** cuando analices archivos peligrosos.

---

## Autor

**YLOGTHER**  
Proyecto de análisis seguro para ejecutables de Windows en Linux
