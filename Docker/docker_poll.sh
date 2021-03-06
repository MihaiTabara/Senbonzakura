#!/bin/bash
# Author: Anhad Jai Singh

#set -e

req=0

script_dir=$(dirname $0)
echo $script_dir

TRAVIS=false
#MD5_OSX='7db10de649864c45d2da6559cf2ca766' # Old Hash without channelID and product Version
MD5_OSX='b6d74f5283420d83f788711bdd6722d1' # New hash with channelID and product Version
#MD5_LINUX='97c403cc1d7375f2f1efee3731f85f4c' # Old Hash without channelID and product Version
MD5_LINUX='9da1d36ebcb6473b2cf260f37ddd60e7' # New hash with channelID and product Version
FF28_FF29_PARTIAL_MD5=$MD5_OSX #Default to OSX because that's the dev machine.

CT='docker-curl-test.sh'


while getopts "t" opt
do
  case $opt in

    t)
      TRAVIS=true
      FF28_FF29_PARTIAL_MD5=$MD5_LINUX
      ;;
  esac
done

echo "Starting tests"
bash $script_dir/$CT trigger-release
echo "Crossed the curl-test call"
start_time=$(date +%s)
sleep 5
echo "Hum drum"
echo $PWD
#bash $CT get-release
while true
do
  #POLL=$( bash $CT -i get-release | head -1 | awk '{print $2}')
  POLL=$( bash $script_dir/$CT -i get-release | awk '{print $2}' | head -1 )
  req=$(($req + 1))
  if [[ $POLL -eq 200 ]]
  then
    echo "Why the hell does the pipe break"
    break
  fi
  # Timeout within 600 seconds
  if [ $(expr $(date +%s) - $start_time) -gt 600 ]
  then
    break
  fi
  echo "REQUEST #:$req"
  sleep 5
done

# Essentially doing the following, but using files incase we need to confirm headers
#GENERATED_HASH=$(bash $script_dir/$CT get-release | md5sum | cut -d ' ' -f 1)
tmp_file="/tmp/temp$(echo $RANDOM).mar"
bash $script_dir/$CT get-release > $tmp_file
GENERATED_HASH=$(md5sum $tmp_file | cut -d ' ' -f 1)
echo "Gen Hash: $GENERATED_HASH"
#rm $tmp_file
if [ $GENERATED_HASH == $FF28_FF29_PARTIAL_MD5 ]
then
  echo "TEST PASSED, W00t"
  exit 0 # imply success
else
  echo "Test failed :("
  echo "Expected hash: $FF28_FF29_PARTIAL_MD5"
  exit 1
fi
