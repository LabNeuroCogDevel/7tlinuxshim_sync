#!/usr/bin/env bash

ROOT=$HOME/MRprojects/7TBrainMech/
for d in /Disk4/Data/20*/*[lL]una*; do 
 [ ! -r $ROOT/$(basename $d) ] && echo missing $d
done

find /Disk4/Data/20*/*[lL]una*/ -maxdepth 2 -type d -iname 'CSI*' |
  xargs -I{} find {} -iname 'siarray.1.1' |
  grep -Po '/20[0-9][0-9][0-9].*?Luna.*?/'|
  uniq |
 while read id; do
   [ ! -r $ROOT/$id ] && echo "$id: have si.array but not in $ROOT"
done
