#!/bin/bash
# udpate-unreal.sh
# Downloads and compiles Unreal Engine from Epic's github account.
# based on https://wiki.unrealengine.com/Building_On_Linux
# (see also https://github.com/EpicGames/UnrealEngine/tree/release/Engine/Build/BatchFiles/Linux)

# 2015-May-21 code@codywohlers.ca - initial creation.


UNREAL_DIR="/opt/UnrealEngine"  # must be owned by you (don't use sudo)

set -e

cd "$UNREAL_DIR"

git pull https://github.com/EpicGames/UnrealEngine.git release  # must have linked your github account to your epic account.

./Setup.sh
./GenerateProjectFiles.sh

if [ "$1" == "-clean" ] ;then
make CrashReportClient-Linux-Shipping \
	ShaderCompileWorker \
	UnrealPak \
	UnrealLightmass \
	UnrealFrontend \
	UE4Editor \
	ARGS=-clean
fi
make

