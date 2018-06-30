for r in $(cat /Users/plexus/jqara/jqara-skripte/repositories.dat);
do
	p=$(echo $r | cut -f 2 -d '/' | sed -e 's/.git//g')
	git clone $r $p
	cd $p
	git config --local --unset-all user.name
	git config --local --add user.name "Oliver B. Fischer"
    	git config --local --unset-all user.email
    	git config --local --add user.email "o.b.fischer@swe-blog.net"
	
	cd ..
done	
