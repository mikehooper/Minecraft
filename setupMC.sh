#!/bin/sh -e

#determine if host system is 64 bit arm64 or 32 bit armhf
if [ ! -z "$(file "$(readlink -f "/sbin/init")" | grep 64)" ];then
  BITS=64
elif [ ! -z "$(file "$(readlink -f "/sbin/init")" | grep 32)" ];then
  BITS=32
else
  echo "Failed to detect or unsupported CPU architecture! Something is very wrong."
fi
DIR=~/Minecraft
LWJGL3_DIR=~/lwjgl3arm$BITS
LWJGL2_DIR=~/lwjgl2arm32

# create folders
echo Setup 1/9
mkdir -p "$DIR"
cd "$DIR"

echo Setup 2/9
    mkdir -p "$LWJGL3_DIR"
if [ $BITS == 32 ]; then
    mkdir -p "$LWJGL2_DIR"
fi

# download minecraft launcher
echo Setup 3/9
wget -nc https://launcher.mojang.com/v1/objects/eabbff5ff8e21250e33670924a0c5e38f47c840b/launcher.jar
 
# download java  
echo Setup 4/9
wget -nc https://github.com/mikehooper/Minecraft/raw/main/jdk-8u251-linux-arm${BITS}-vfp-hflt.tar.gz

# download lwjgl3arm*
echo Setup 5/9
wget -nc https://github.com/mikehooper/Minecraft/raw/main/lwjgl3arm${BITS}.tar.gz
if [ $BITS == 32 ]; then
    wget -nc https://github.com/mikehooper/Minecraft/raw/main/lwjgl2arm32.tar.gz
fi

echo Setup 6/9
sudo mkdir -p /opt/jdk
 
# extract oracle java  8
echo Setup 7/9
echo Extracting java ...
sudo tar -zxf jdk-8u251-linux-arm${BITS}-vfp-hflt.tar.gz -C /opt/jdk
if [ $BITS == 64 ]; then
    # install opnjdk for launcher.jar and optifine install
    sudo apt install openjdk-11-jdk -y
fi

# extract lwjgl*
echo Setup 8/9
echo Extracting lwjgl...
tar -zxf lwjgl3arm${BITS}.tar.gz -C $LWJGL3_PATH
if [ $BITS == 32 ]; then
    tar -zxf lwjgl2arm32.tar.gz -C $LWJGL2_PATH
fi

echo Setup 9/9
echo Configure java
sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_251/bin/java 0
sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_251/bin/javac 0
if [ "$MACHINE" = "aarch64" ]; then
    echo Setting Open jdk
    sudo update-alternatives --set java /usr/lib/jvm/java-11-openjdk-arm64/bin/java
    sudo update-alternatives --set javac /usr/lib/jvm/java-11-openjdk-arm64/bin/javac
else
    echo Setting Oracle jdk
    sudo update-alternatives --set java /opt/jdk/jdk1.8.0_251/bin/java
    sudo update-alternatives --set javac /opt/jdk/jdk1.8.0_251/bin/javac
fi
 
echo end setupMC
