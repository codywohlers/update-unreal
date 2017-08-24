#!/bin/bash
# udpate-unreal.sh [ -check | -clean ]
# Downloads and compiles Unreal Engine from Epic's github account.
# - Use argument "-check" to check for an update.
# - Use argument "-clean" to do a full build.
# based on https://wiki.unrealengine.com/Building_On_Linux
# (see also https://github.com/EpicGames/UnrealEngine/tree/release/Engine/Build/BatchFiles/Linux)

# 2017-Aug-24 code@codywohlers.ca - added "-partial-clean" argument.
# 2017-Jul-03 code@codywohlers.ca - added UnrealPak to make target.
# 2017-Jun-11 code@codywohlers.ca - added check option.
# 2017-May-24 code@codywohlers.ca - updated usage description.
# 2017-May-21 code@codywohlers.ca - initial creation.


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

if [ "$1" == "-partial-clean" ] ;then
    find Engine/Intermediate/Build/Linux/ -name PCH.Core.h.gch -exec rm -v '{}' \;
    find Engine/Intermediate/Build/Linux/ -name SharedPCH.Core.h.gch -exec rm -v '{}' \;
    find Engine/Intermediate/Build/Linux/ -name SharedPCH.CoreUObject.h.gch -exec rm -v '{}' \;
    find Engine/Intermediate/Build/Linux/ -name PCH.CoreUObject.h.gch -exec rm -v '{}' \;
fi

make
make UnrealPak
