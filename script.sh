#!/bin/bash
# OLDHOME refers to the path from the previous Bitbucket server instance where the repositories are stored.
# BB_URL refers to the URL of the new Bitbucket server instance
# UP refers to the admin account and password that will be used by the REST API to create the project and repositories
# GUSER refers to the user used by git to push the repository data. This should be the admin account unless you have added a new user with permissions to access the repisitory.
# GEMAIL refers to the email address of the git user

OLDHOME=/old/bitbucket/home/shared/data/repositories
BB_URL=http://localhost:7990
UP=admin:admin1998

GUSER=admin
GEMAIL=admin@org.com

cd $OLDHOME

for i in [0-9]*
do
PRJ=`grep 'project =' $i/repository-config| cut -d' ' -f3-`
REP=`grep 'repository =' $i/repository-config| cut -d' ' -f3-`

cp=`curl -s -o /dev/null -w "%{http_code}" -u "$UP" -X POST -H "Content-Type: application/json" $BB_URL/rest/api/1.0/projects \
      -d '{"key": "'"$PRJ"'", "name": "'"$PRJ"'", "description": "'"$PRJ"' is the project created from the API"}'`
if [ $cp == "201" ]
then
    echo Creating project $PRJ
fi
      
cr=`curl -s -o /dev/null -w "%{http_code}" -u "$UP" -X POST -H "Content-Type: application/json" -H "Accept: application/json" \
      -d '{ "name": "'"$REP"'" }' $BB_URL/rest/api/1.0/projects/"$PRJ"/repos`
if [ $cr == "201" ]
then
    echo repository $PRJ/$REP
    mkdir tmp
    cd tmp
    git clone $OLDDIR/$i
    git config user.name $GUSER
    git config user.email $GEMAIL
    cd $i
    git remote set-url origin $BB_URL/scm/$PRJ/$REP.git

    git push -u --all origin
    git push -u --tags origin
    cd ../..
    rm -rf tmp
fi     

done