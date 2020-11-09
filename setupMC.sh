#!/bin/sh -e

MACHINE=$(uname -m)
DIR=~/Minecraft

# create folders
echo Setup 1/9
if [ ! -d "$DIR" ]; then
    mkdir "$DIR"
fi
cd "$DIR"
pwd

echo Setup 2/9
if [ "$MACHINE" = "aarch64" ]; then
    echo "Raspberry Pi OS (64 bit)"
    if [ ! -d ~/lwjgl3arm64 ]; then
        mkdir ~/lwjgl3arm64
    fi
else
    echo "Raspberry Pi OS (32 bit)"
    if [ ! -d ~/lwjgl3arm32 ]; then
        mkdir ~/lwjgl3arm32
    fi
    if [ ! -d ~/lwjgl2arm32 ]; then
        mkdir ~/lwjgl2arm32
    fi
fi

# download minecraft launcher
echo Setup 3/9
if [ ! -f launcher.jar ]; then
    wget https://launcher.mojang.com/v1/objects/eabbff5ff8e21250e33670924a0c5e38f47c840b/launcher.jar
fi
 
# download java  
echo Setup 4/9
if [ "$MACHINE" = "aarch64" ]; then
    if [ ! -f jdk-8u251-linux-arm64-vfp-hflt.tar.gz ]; then
        wget https://www.dropbox.com/s/ft7fwlrjq5cnu87/jdk-8u251-linux-arm64-vfp-hflt.tar.gz
    fi
else
    if [ ! -f jdk-8u251-linux-arm32-vfp-hflt.tar.gz ]; then
        wget https://www.dropbox.com/s/mwelmbpq7vvs7pp/jdk-8u251-linux-arm32-vfp-hflt.tar.gz
    fi
fi

# download lwjgl3arm*
echo Setup 5/9
if [ "$MACHINE" = "aarch64" ]; then
    if [ ! -f lwjgl3arm64.tar.gz ]; then
        wget https://www.dropbox.com/s/0x765uoy6ihj3gr/lwjgl3arm64.tar.gz
    fi
else
    if [ ! -f lwjgl3arm32.tar.gz ]; then
        wget https://www.dropbox.com/s/xzegvb4srsuvhl3/lwjgl3arm32.tar.gz
    fi
    if [ ! -f lwjgl2arm32.tar.gz ]; then
        wget https://www.dropbox.com/s/ew7jnw7noygpkny/lwjgl2arm32.tar.gz
    fi
fi

echo Setup 6/9
if [ ! -d /opt/jdk ]; then
    sudo mkdir /opt/jdk
fi
 
# extract oracle java  8
echo Setup 7/9
echo Extracting java ...
if [ "$MACHINE" = "aarch64" ]; then
    sudo tar -zxf jdk-8u251-linux-arm64-vfp-hflt.tar.gz -C /opt/jdk
    # install opnjdk for launcher.jar and optifine install
    sudo apt install openjdk-11-jdk -y
else
    sudo tar -zxf jdk-8u251-linux-arm32-vfp-hflt.tar.gz -C /opt/jdk
fi

# extract lwjgl*
echo Setup 8/9
echo Extracting lwjgl...
if [ "$MACHINE" = "aarch64" ]; then
    tar -zxf lwjgl3arm64.tar.gz -C ~/lwjgl3arm64
else
    tar -zxf lwjgl3arm32.tar.gz -C ~/lwjgl3arm32
    tar -zxf lwjgl2arm32.tar.gz -C ~/lwjgl2arm32
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