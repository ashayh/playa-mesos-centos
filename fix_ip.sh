#!/bin/bash

# this is not needed as I disable NM

HOSTS=$(ruby -rjson -e 'nodes=JSON.parse(File.read("nodes.json"))["nodes"];str=[];nodes.each do |n| str<<  n[0] end;puts str.join(" ")')

for i in ${HOSTS}
do
  vagrant ssh ${i} -c " sudo systemctl disable NetworkManager.service ; sudo systemctl stop NetworkManager.service ; sudo ifdown enp0s8 ; sudo ifup enp0s8 "
done
