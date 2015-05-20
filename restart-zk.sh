#!/bin/bash

# this is not needed as I disable NM

HOSTS=$(ruby -rjson -e 'nodes=JSON.parse(File.read("nodes.json"))["nodes"];str=[];nodes.each do |n| str<<  n[0] end;puts str.join(" ")')

for i in ${HOSTS}
do
  if [[ ${i} =~ mesos* ]]
  then
    echo vagrant ssh ${i} -c \"sudo systemctl restart zookeeper.service\"
  fi
done
