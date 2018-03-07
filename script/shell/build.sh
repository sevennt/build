#!/bin/bash

set -e
basePath=$(dirname $(dirname $(dirname $(dirname $(readlink -f $0)))))

echo -e "\nBuilding binaries in ${basePath}"
declare -a bins=${@:2}

cd ${basePath}
rm -rf ./bin/*
for task in ${bins[@]}
do
    echo building ${task}...
    read pkgPath binName <<< $(echo ${task} | awk -F ":" '{ print $1; print $2 }')
    echo pkgPath:${pkgPath}, binName:${binName}
    go build -ldflags "$1" -o ./bin/$(echo $(echo ${binName} -v | awk -F/ '{print $NF}') ${pkgPath})
    echo -e "\n"
done
