#!/bin/sh

cd "$(dirname "$0")"


# makes things easier if script needs debugging
if [ x$FTB_VERBOSE = xyes ]; then
    set -x
fi

# cleaner code
eula_false() {
    grep -q 'eula=false' eula.txt
    return $?
}



# run install script if MC server or launchwrapper s missing
if [ ! -f minecraft_server.1.7.10.jar ]; then
    echo "Missing required jars. Running install script!"
    sh ./FTBInstall.sh
fi

# check if there is eula.txt and if it has correct content
if [ -f eula.txt ] && eula_false ; then
    echo "Make sure to read eula.txt before playing!"
    echo "To exit press <enter>"
    read ignored
    exit
fi

# inform user if eula.txt not found
if [ ! -f eula.txt ]; then
    echo "Missing eula.txt. Startup will fail and eula.txt will be created"
    echo "Make sure to read eula.txt before playing!"
    echo "To continue press <enter>"
    read ignored
fi

echo "Starting server"
java -server -Xms512m -Xmx2048M -XX:PermSize=256m -d64 -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10 -jar FTBServer-1.7.10-1291.jar nogui
echo "Server process finished"