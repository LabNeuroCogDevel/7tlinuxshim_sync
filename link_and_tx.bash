#!/usr/bin/env bash


ROOT=$HOME/MRprojects/7TBrainMech/
[ ! -d $ROOT ] && mkdir -p $ROOT

# link without the yyyy-mm/ root folder to match whats on rhea
for d in /Disk4/Data/*/*[lL]una*/DICOM/T*/; do
   # get subj/dicom part                e.g. $ROOT/20200103Luna2/DICOM
   ndir=$ROOT/$(echo $d|cut -d/ -f 5-6)
   # skip if we already have e.g. 20200103Luna2/DICOM/TIEJUN_JREF-LUNA_20200103_162648_531000
   [ -d $ndir/$(basename $d) ] && continue
   # make dir and link 
   mkdir -p $ndir
   ln -s $d $_
 done

# sync to LNCD server. 'r' config in ~/.ssh/config
rsync -Lavhi --size-only $ROOT r:/Volumes/Hera/Raw/MRprojects/7TBrainMech/
