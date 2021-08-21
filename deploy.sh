#! /bin/bash
set -euo

hostTerm=$1
company=$2
username=$3
password=$4
target=$5
appname=${target//.zip/}

auth="$company.$username:$password"
hostPreFix="http://"
host=""

# AppStore
fileName="/matrix/m3appstore/appStoreAuto.js"
fileForm="input={\"action\": \"c\",\"param\":{ \"name\": \"$target\", \"title\": \"$appname\", \"version\": \"v0.5\", \"author\": \"wecise\" }}"

if [[ $hostTerm =~ $hostPreFix ]] 
then
    host=$hostTerm
else
    host="http://$hostTerm"
fi

echo
echo '应用发布开始**********************************************************************'
echo
echo '发布地址：'${host}
echo
echo '发布租户：'${company}
echo

curl --location -u "${auth}" -X POST "$host/fs/import?issys=true" --form "uploadfile=@${target}" | python -m json.tool

curl -u "${auth}" -X POST "$host/script/exec/js?filepath=${fileName}"  -F "${fileForm}" -F "isfile=true" | python -m json.tool

echo
rm -rf ${target}
echo '应用发布结束**********************************************************************';
