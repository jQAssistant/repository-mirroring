wd=/tmp/jqa-update-$(date -u +"%Y-%m-%d-%H-%M-%S%-Z")
mkdir -p ${wd}

for r in $(cat ~/jqara/jqara-skripte/repositories.dat);
do
    p=${wd}/$(echo $r | cut -f 2 -d '/' | sed -e 's/.git//g')
    m=$(echo $r | sed -e 's/jqara/buschmais/g')

    echo $m
    git clone $r $p
    cd $p

    git config --local --unset-all user.name
    git config --local --add user.name "Oliver B. Fischer"
    git config --local --unset-all user.email
    git config --local --add user.email "o.b.fischer@swe-blog.net"
    
    git remote add buschmais $m
    git fetch --all
    git tag -d IMPORT
    git tag -d ZERO
    git push --delete origin IMPORT
    git push --delete origin ZERO
    git reset --hard buschmais/master
    git tag IMPORT
    sed -i.backup -e "s/github.com:buschmais\//github.com:jqara\//g" pom.xml
    sed -i.backup -e "s/github.com:buschmais\//github.com:jqara\//g" pom.xml
    git commit -a -m "Umsetzung von buschmais auf jqara"
    git tag ZERO
    git push --tags --force -u origin master
    
    cd ..
done	
