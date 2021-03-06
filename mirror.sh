#!/bin/bash

# See https://stackoverflow.com/questions/59895/
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${script_dir}/includes/colors.sh

wd=/tmp/jqa-update-$(date -u +"%Y-%m-%d-%H-%M-%S%-Z")
mkdir -p ${wd}

echo "${GREEN}Working dir will be ${wd}${RESET}"

for r in $(cat ${script_dir}/repositories.dat);
do
    p=${wd}/$(echo $r | cut -f 2 -d '/' | sed -e 's/.git//g')
    m=$(echo $r | sed -e 's/jqara/jqassistant/g')

    echo "${GREEN}Mirroring $m to $r${RESET}"
    git clone $r $p
    cd $p

    git config --local --unset-all user.name
    git config --local --add user.name "Oliver B. Fischer"
    git config --local --unset-all user.email
    git config --local --add user.email "o.b.fischer@swe-blog.net"

    git remote rename origin jqara
    git remote add jqa $m
    git fetch --all
    git tag -d IMPORT
    git tag -d ZERO
    git push --delete jqara IMPORT
    git push --delete jqara ZERO
    git reset --hard jqa/master
    git tag IMPORT
    sed -i.backup -e "s/github.com:jqassistant\//github.com:jqara\//g" pom.xml
    git commit -a -m "Umsetzung von jqassistant auf jqara"
    git tag ZERO
    git push --tags --force -u jqara master
    
    cd ..
done	
