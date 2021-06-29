#! /bin/bash
set -euo

hostTerm=$1
company=$2
username=$3
password=$4
target=$5

auth="$company.$username:$password"
hostPreFix="http://"
host=""

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

curl --location -u "${auth}" -X POST "$host/fs/import?issys=true" --form "uploadfile=@${target}"

echo
rm -rf ${target}
echo '应用发布结束**********************************************************************';
