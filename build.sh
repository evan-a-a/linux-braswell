#!/bin/bash
DEFCONFIG=$1

if [ -z $DEFCONFIG ]; then 
	echo "Please specify defconfig as an argument"
	exit
fi

cd ~/linux-braswell

echo "Building linux for edgar..."

#echo "Clobbering previous build"
#make mrproper 2&> /dev/null
rm -rf ~/linux-out/*

echo "Configuring build"
make $DEFCONFIG

echo "Building start"
TIME_START=$(date +%s.%N)

make -j40

echo "Build done!"
TIME_END=$(date +%s.%N)

echo "Copying modules to ~/linux-out..."
make modules_install INSTALL_MOD_PATH=~/linux-out

echo "Copying bzImage..."
cp arch/x86_64/boot/bzImage ~/linux-out

echo "Creating archive of output..."
PKG=$(git symbolic-ref --short HEAD)
cd ~
tar -cf linux-$PKG-$DEFCONFIG.tar linux-out

echo "Package complete!"
echo "Kernel build time: $(echo "($TIME_END - $TIME_START) / 60" | bc) minutes ($(echo "$TIME_END - $TIME_START" | bc) seconds)"
