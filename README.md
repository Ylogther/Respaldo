# Smart EXE Launcher (Linux + Wine)

Este tutorial esta mas enfocado en usuarios de arch linux, pero en otra distribución también funcionara

```markdown
# Smart EXE Launcher (Linux + Wine)

Este proyecto te permite ejecutar archivos `.exe` de Windows en Linux de forma **inteligente y segura**, usando Wine y Firejail.

## ¿Qué hace?

Cuando lanzas un `.exe`, el script analiza el archivo y te da **dos opciones**:

1. **Análisis seguro (modo sandbox)**  
   Ejecuta el `.exe` en un entorno totalmente aislado:
   - Sin acceso a internet
   - Sin acceso a tus archivos personales
   - Monitorea y registra los procesos que lanza
   - Ideal para probar cracks, keygens, activadores, o archivos sospechosos

2. **Modo juego (entorno persistente)**  
   Ejecuta el `.exe` con acceso total y guarda tus progresos:
   - Útil para juegos o programas confiables
   - Todo se guarda en un entorno separado (`~/.wine-juegos`)
   - Compatible con la mayoría de juegos que funcionan con Wine

## ¿Qué requisitos tiene?

- [Wine](https://wiki.archlinux.org/title/Wine)
- [Firejail](https://firejail.wordpress.com/)
- Bash y herramientas básicas de GNU/Linux

En Arch Linux puedes instalarlos con:

```bash
sudo pacman -S wine firejail
```

## ¿Cómo usarlo?

1. Clona este repositorio:

```bash
git clone https://github.com/tuusuario/smart-exe-launcher.git
cd smart-exe-launcher
chmod +x smart_launcher.sh
```

2. Ejecuta un `.exe`:

```bash
./smart_launcher.sh archivo.exe
```

3. El script te mostrará:
   - Hash del archivo
   - Tamaño
   - Recomendación automática (análisis o juego)
   - Un menú para que elijas

## ¿Dónde guarda cosas?

- **Logs de procesos** (si usas modo análisis): `~/wine-logs/`
- **Juegos y programas confiables**: `~/.wine-juegos`
- **Pruebas y entornos seguros**: entorno temporal aislado con Firejail

## Captura de pantalla 

Agrega aquí una captura del menú si quieres.

## ¿Quieres más?

Puedes mejorarlo añadiendo:
- Integración con VirusTotal (con API key)
- Detección de conexiones de red
- Detección de cambios en el sistema de archivos
- Interfaz gráfica con Zenity o Yad


