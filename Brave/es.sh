#!/bin/bash
# ==============================================
# Script de instalación de Brave Browser en un solo paso
# Enlace alternativo(Canvia lo de avajo): https://raw.githubusercontent.com/XJH-gh/llq/main/Brave/es.sh
# Ejecución rápida:
# bash <(wget -qO- https://is.gd/esbrave)
# O descargar y ejecutar:
# wget -O brave-es.sh https://is.gd/esbrave
# bash brave-es.sh
# ==============================================
set -e

# ====== Salida en color ======
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

log_info() { echo -e "${GREEN}$1${RESET}"; }
log_warn() { echo -e "${YELLOW}$1${RESET}"; }
log_error() { echo -e "${RED}$1${RESET}"; }

# ====== Comprobación de red ======
log_info "🌐 Comprobando conexión a Internet..."
if ! ping -c 1 google.com >/dev/null 2>&1; then
  log_error "❌ No hay conexión. Por favor revisa tu red e inténtalo de nuevo."
  exit 1
fi
log_info "✅ Conexión correcta, continuando..."

# ====== Comprobar si Brave ya está instalado ======
if command -v brave-browser >/dev/null 2>&1; then
  log_warn "⚠️ Brave ya está instalado. Se saltará la instalación y solo se configurará el idioma."
  skip_install=true
else
  skip_install=false
fi

# ====== Pantalla de bienvenida ======
echo "👋 ¡Hola! Bienvenido al script de instalación de Brave Browser. ^_^"
echo
echo "Antes, un pequeño resumen de Brave:"
echo "🦁 Ventajas:"
echo " - Bloqueador de anuncios integrado, gran protección de privacidad"
echo " - Basado en Chromium, compatible con extensiones"
echo " - Más ligero que Chrome, consume menos memoria"
echo " - Menos procesos en segundo plano, interfaz más limpia"
echo
echo "⚠️ Inconvenientes:"
echo "- Necesitas mínimo 3 GB de espacio libre para linux"
echo " - Algunas webs/extensiones pueden ir lentas"
echo " - Configuración de privacidad estricta, hay que ajustar permisos manualmente"
echo " - En CrazyGames puede ir lento, o otros mas."
echo
echo "🔒 Función especial: Tor incorporado"
echo " - Permite acceder a webs bloqueadas"
echo " - Soporta la dark web (⚠️ úsalo con cuidado)"
echo " - Cómo usar: ≡ → Nueva ventana privada con Tor (Shift+Alt+N)"
echo " - Desventaja: lento y a veces inestable"
echo " - Para máxima seguridad, Tor Browser oficial es mejor"
echo " - Documentación(Sobre El Tor): https://support.brave.app/hc/es/articles/7816553516045--C%C3%B3mo-utilizo-los-puentes-Tor-en-Brave"
echo " Si tienes mas pregunta envia un mail al: hjzgcn@gmail.com o enviar un comentario a https://xjha.blogspot.com/2025/09/no-tenemos-leaf-browser-y-ahora-que.html "
echo
read -p "¿Quieres instalar Brave Browser? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  log_warn "Vale, ¡hasta la próxima! 👋"
  exit 0
fi

# ====== Instalación de Brave ======
if [ "$skip_install" = false ]; then
  log_info "📦 Instalando Brave Browser..."
  sudo apt install -y curl
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
  sudo apt update
  sudo apt install -y brave-browser
  log_info "✅ Brave Browser instalado correctamente."
fi

# ====== Configuración de idioma ======
echo
echo "Elige cómo configurar el idioma:"
echo " 1) Cambiar el idioma del sistema a Español (incluyendo Brave)"
echo " 2) Solo poner Brave en Español"
read -p "Escribe 1 o 2 (por defecto 2): " lang_choice
lang_choice=${lang_choice:-2}

if [[ "$lang_choice" == "1" ]]; then
  log_info "⚙️ Configurando el sistema en Español..."
  if ! grep -q '^es_ES.UTF-8 UTF-8' /etc/locale.gen; then
    echo "es_ES.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen > /dev/null
  else
    sudo sed -i '/^#.*es_ES.UTF-8 UTF-8/s/^#//' /etc/locale.gen
  fi
  sudo locale-gen
  sudo update-locale LANG=es_ES.UTF-8 LANGUAGE=es_ES:es LC_ALL=es_ES.UTF-8
  log_info "✅ Idioma del sistema cambiado a Español. Cierra sesión o reinicia para aplicar cambios."
else
  log_info "🌏 Solo configurando Brave en Español..."
fi

# ====== Mensaje final ======
echo
launcher_name="Brave Browser"
log_info "🎉 ¡Listo! Ahora puedes encontrar “$launcher_name” en el menú y usarlo en Español."
log_info "🧑‍💻 Ejecución alternativa por terminal:"
echo "  LANG=es_ES.UTF-8 brave-browser --lang=es-ES"
echo
log_info "Consejo: en Chromebook, si no ves Brave en el menú después de instalarlo, reinicia el contenedor de Linux (apágalo y vuelve a encenderlo desde Configuración)."

exit 0


