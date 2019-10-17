#!/bin/bash

# See https://stackoverflow.com/questions/59895/
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${script_dir}/includes/colors.sh

for r in $(cat ${script_dir}/repositories.dat);
do
	p=$(echo $r | cut -f 2 -d '/' | sed -e 's/.git//g')

	echo "${GREEN}About to clone ${r} to ${p}${RESET}"
	git clone $r $p
	cd $p
	git config --local --unset-all user.name
	git config --local --add user.name "Oliver B. Fischer"
    	git config --local --unset-all user.email
    	git config --local --add user.email "o.b.fischer@swe-blog.net"
	
	cd ..
done	
