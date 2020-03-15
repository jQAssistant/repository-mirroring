#!/bin/bash

# See https://stackoverflow.com/questions/59895/
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${script_dir}/includes/colors.sh

wd=/tmp/jqa-reset-$(date -u +"%Y-%m-%d-%H-%M-%S%-Z")

echo "${GREEN}Working directory will be ${wd}${RESET}"
echo "${GREEN}Resetting mirrored repositories to tag ZERO${RESET}"

for r in $(cat ${script_dir}/repositories.dat);
do
	p=${wd}/$(echo $r | cut -f 2 -d '/' | sed -e 's/.git//g')
	git clone $r $p
	cd $p
	git remote rename origin jqa
	git config --local --unset-all user.name
	git config --local --add user.name "Oliver B. Fischer"
    git config --local --unset-all user.email
    git config --local --add user.email "o.b.fischer@swe-blog.net"
	git reset --hard ZERO
	git push -f jqa master

	for ref in $(git show-ref --tags | cut -f 2 -d " "); do
        case "$ref" in
            refs/tags/IMPORT)
			    ;;
		    refs/tags/ZERO)
                ;;
		    *)
			    git push jqa ":${ref}"
			    ;;
	    esac
	done
	
	cd ..
done	
