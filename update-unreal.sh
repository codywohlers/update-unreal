#!/bin/bash
# udpate-unreal.sh [ -check | -clean ]
# Downloads and compiles Unreal Engine from Epic's github account.
# - Use argument "-check" to check for an update.
# - Use argument "-clean" to do a full build.
# based on https://wiki.unrealengine.com/Building_On_Linux
# (see also https://github.com/EpicGames/UnrealEngine/tree/release/Engine/Build/BatchFiles/Linux)

# 2015-Jun-11 code@codywohlers.ca - added check option.
# 2015-May-24 code@codywohlers.ca - updated usage description.
# 2015-May-21 code@codywohlers.ca - initial creation.


UNREAL_DIR="/opt/UnrealEngine"  # must be owned by you (don't use sudo)

set -e

cd "$UNREAL_DIR"

if [ "$1" == "-check" ] ;then
	git remote update
	git status
	exit
else
	git pull https://github.com/EpicGames/UnrealEngine.git release  # must have linked your github account to your epic account.
fi

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

