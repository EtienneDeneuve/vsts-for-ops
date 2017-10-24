#! /bin/bash
while getopts ":d:s:" opt; do
  case $opt in
    a) DESTACCOUNTKEY="$OPTARG"
    ;;
    p) SOURCEACCOUNTKEY="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done
echo "#################### Existing ENV ####################"
env
echo "#################### Split IMAGEURI ####################"
set -- "$IMAGEURI"
export IFS="/"
declare -a Array=($*)
echo $IFS
echo "Destination Container "${DESTCONTAINER}""
echo "Destination ACCOUNT NAME "${DESTACCOUNTNAME}""
echo "Destination DESTACCOUNT KEY "${DESTACCOUNTKEY}""
echo "SOURCE ACCOUNTNAME "${SOURCEACCOUNTNAME}""
echo "SOURCE ACCOUNTKEY "${SOURCEACCOUNTKEY}""
echo "${Array[@]}"
echo "#################### Create "${DESTCONTAINER}" in "${DESTACCOUNTNAME}" ####################"
create="$(az storage container create -n "${DESTCONTAINER}" --account-key "${DESTACCOUNTKEY}" --account-name "${DESTACCOUNTNAME}")"
echo "#################### Start Copy of "${Array[-4]}/${Array[-3]}/${Array[-2]}/${Array[-1]}" in "${DESTACCOUNTNAME}" "${DESTFILENAME}" ####################"
az storage blob copy start --account-name "${DESTACCOUNTNAME}" --account-key "${DESTACCOUNTKEY}" --destination-blob "${DESTFILENAME}" --destination-container "${DESTCONTAINER}" --source-account-key "${SOURCEACCOUNTKEY}" --source-account-name "${SOURCEACCOUNTNAME}" --source-blob "${Array[-4]}/${Array[-3]}/${Array[-2]}/${Array[-1]}" --source-container "${Array[3]}" 
echo "#################### Check the status of copy each 5 seconds ####################"
export AZURE_STORAGE_ACCOUNT="${DESTACCOUNTNAME}"
export AZURE_STORAGE_KEY="${DESTACCOUNTKEY}"
status="$(az storage blob show --container-name "${DESTCONTAINER}" --name "${DESTFILENAME}" --account-name "${DESTACCOUNTNAME}" | jq .properties.copy.status)"
while [ "${status}" != "\"success\"" ]
do 
	status=$(az storage blob show --container-name "${DESTCONTAINER}" --name "${DESTFILENAME}" --account-name "${DESTACCOUNTNAME}" | jq .properties.copy.status)
	copied=$(az storage blob show --container-name "${DESTCONTAINER}" --name "${DESTFILENAME}" --account-name "${DESTACCOUNTNAME}" | jq .properties.copy.progress)
	echo "Copy in Progress... ${copied}"
	sleep 5
done