#very fast,seems best remote desktop solution,support sound


export UBUNTU_RELEASE=20.04
export SELKIES_VERSION=1.3.7
export GSTREAMER_PATH=/opt/gstreamer
export WEB_ROOT=/opt/gst-web



export GPROXY=https://ghproxy.com/

sudo apt-get update && sudo apt-get install --no-install-recommends -y adwaita-icon-theme-full build-essential python3-pip python3-dev python3-gi python3-setuptools python3-wheel tzdata sudo udev xclip x11-utils xdotool wmctrl jq gdebi-core x11-xserver-utils xserver-xorg-core libopus0 libgdk-pixbuf2.0-0 libsrtp2-1 libxdamage1 libxml2-dev libwebrtc-audio-processing1 libcairo-gobject2 pulseaudio libpulse0 libpangocairo-1.0-0 libgirepository1.0-dev libjpeg-dev libvpx-dev zlib1g-dev x264

sudo apt-get update && sudo apt-get install --no-install-recommends -y xcvt

cd /opt && curl -fsSL ${GPROXY}https://github.com/selkies-project/selkies-gstreamer/releases/download/v${SELKIES_VERSION}/selkies-gstreamer-v${SELKIES_VERSION}-ubuntu${UBUNTU_RELEASE}.tgz | sudo tar -zxf -

cd /tmp && curl -O -fsSL ${GPROXY}https://github.com/selkies-project/selkies-gstreamer/releases/download/v${SELKIES_VERSION}/selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl && sudo pip3 install selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl && rm -f selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl


cd /opt && curl -fsSL ${GPROXY}https://github.com/selkies-project/selkies-gstreamer/releases/download/v${SELKIES_VERSION}/selkies-gstreamer-web-v${SELKIES_VERSION}.tgz | sudo tar -zxf -





export DISPLAY=:0
export GST_DEBUG=*:2
# Initialize the GStreamer environment after setting GSTREAMER_PATH to the path of your GStreamer directory
export GSTREAMER_PATH=/opt/gstreamer
source /opt/gstreamer/gst-env
# Start a virtual X11 server, skip this line if an X server already exists or you are already using a display
Xvfb -screen :0 8192x4096x24 +extension RANDR +extension GLX +extension MIT-SHM -nolisten tcp -noreset -shmem 2>&1 >/tmp/Xvfb.log &
# Ensure the X server is ready
until [[ -S /tmp/.X11-unix/X0 ]]; do sleep 1; done && echo 'X Server is ready'

# Initialize PulseAudio (set PULSE_SERVER to unix:/run/pulse/native if your user is in the pulse-access group), omit the below lines if a PulseAudio server is already running
export PULSE_SERVER=tcp:127.0.0.1:4713
sudo /usr/bin/pulseaudio -k >/dev/null 2>&1
sudo /usr/bin/pulseaudio --daemonize --system --verbose --log-target=file:/tmp/pulseaudio.log --realtime=true --disallow-exit -L 'module-native-protocol-tcp auth-ip-acl=127.0.0.0/8 port=4713 auth-anonymous=1'
# Replace this line with your desktop environment session or skip this line if already running, use VirtualGL `vglrun` here if needed

[[ "${START_XFCE4:-true}" == "true" ]] && rm -rf ~/.config/xfce4 && xfce4-session &

# Write Progressive Web App (PWA) config.
export PWA_APP_NAME="Selkies WebRTC"
export PWA_APP_SHORT_NAME="selkies"
export PWA_START_URL="/index.html"
sudo sed -i \
    -e "s|PWA_APP_NAME|${PWA_APP_NAME}|g" \
    -e "s|PWA_APP_SHORT_NAME|${PWA_APP_SHORT_NAME}|g" \
    -e "s|PWA_START_URL|${PWA_START_URL}|g" \
/opt/gst-web/manifest.json
sudo sed -i \
    -e "s|PWA_CACHE|${PWA_APP_SHORT_NAME}-webrtc-pwa|g" \
/opt/gst-web/sw.js

# Choose your video encoder
export WEBRTC_ENCODER=${WEBRTC_ENCODER:-x264enc}
# Do not enable resize if there is a physical display
export WEBRTC_ENABLE_RESIZE=${WEBRTC_ENABLE_RESIZE:-true}
# Replace to your resolution if using without resize, skip if there is a physical display
selkies-gstreamer-resize 1280x720
# Starts the remote desktop process
selkies-gstreamer &




















































