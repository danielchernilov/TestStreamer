#!/bin/bash
set -e

mkdir liveStreamer
cd liveStreamer
# Download the zip file
wget https://github.com/impleotv/live-streamer-release/releases/download/v1.0.6/liveStreamerLinux.zip

# Extract the contents of the zip file
unzip liveStreamerLinux.zip

# Create the necessary directory structure
mkdir DEBIAN
mkdir -p opt/impleotv/liveStreamer/bin/
mkdir -p opt/impleotv/liveStreamer/share/

rm -r linux-x64

mv liveStreamer.run opt/impleotv/liveStreamer/bin
mv README.pdf  opt/impleotv/liveStreamer/share 
mv README.md  opt/impleotv/liveStreamer/share 

chmod +x opt/impleotv/liveStreamer/bin/liveStreamer.run 

# Create the control file
cat <<EOF > ./DEBIAN/control
Package: liveStreamer
Version: 1.0.6
Architecture: amd64
Maintainer: ImpleoTV <info@impleotv.com>
Depends: ffmpeg, ffprobe
Live Streamer
EOF
# Create the postinst script
cat <<EOF > ./DEBIAN/postinst
#!/bin/bash
set -e
sudo ln -sf opt/impleotv/liveStreamer/bin/liveStreamer.run /usr/bin/liveStreamer.run
exit 0
EOF

# Make the postinst script executable
chmod +x ./DEBIAN/postinst

rm -r liveStreamerLinux.zip

cd ..

dpkg-deb --build liveStreamer

exit 0