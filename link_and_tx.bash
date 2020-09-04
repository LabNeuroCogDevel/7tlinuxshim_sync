#!/usr/bin/env bash

# link data into consistant folders
# transfer liket that to "rhea", loffler building server for LNCD

# 20200512WF - per year folders
# 20200904WF - 2020-08 CSI are in double nested participant folders


ROOT=$HOME/MRprojects/7TBrainMech/
[ ! -d $ROOT ] && mkdir -p $ROOT

# record duration
log() { echo -e "$(date +"%F\t%H:%M\t%s")\t$@" >> $HOME/tx_log.txt; }

# link old dicoms that were missing:
# for id in 20191011Luna1 20191021Luna1 20191025Luna1 20191028Luna2 20191101Luna1 20191101Luna2 20191125Luna1; do d=/Disk4/Data/DICOMxfer/${id^^}*; test -r $d -a '!' -r  MRprojects/7TBrainMech/$id/DICOM && ln -s $d $_; done

[ -z "$DRYRUN" ] && log start-link
# link without the yyyy-mm/ root folder to match whats on rhea
# todo: do we need /Disk4/Data/*/*[lL]una*/CoregPFC/registration_out/17*FlipLR.MPRAGE
for d in /Disk4/Data/20*/20*/*[Ll][Uu][Nn][Aa]*/{DICOM/{,*/}TIEJUN_JREF*/,{,20*/}CSIPFC/siarray.1.1,{,20*/}CoregPFC/}; do
   [ ! -r "$d" ] && echo "cannot read '$d'" && continue
   # get subj/dicom part                e.g. $ROOT/20200103Luna2/DICOM or id/CSIPFC
   ! [[ $d =~ /([^/]*[Ll][Uu][^/]*)/.*/?(DICOM|CSIPFC|CoregPFC)/ ]] && echo "# $d does not match lunadate +  DICOM, CSIPFC, or CoregPFC!" && continue
   ndir="$ROOT/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
   # skip if we already have e.g. 20200103Luna2/DICOM/TIEJUN_JREF-LUNA_20200103_162648_531000

   [ -n "$VERBOSE" ] && [ "$VERBOSE" -gt 1 ] && echo "## looking at $d -> $ndir"

   [ -r "$ndir/$(basename "$d")" ] && continue

   [ -n "$VERBOSE" ] && echo "# mkdir and link '$d' -> '$ndir'"
   [ -n "$DRYRUN" ] && echo "# dryrun skip" && continue

   # make dir and link 
   mkdir -p "$ndir"
   ln -s "$d" "$_"
 done

[ -n "$DRYRUN" ] && exit
log start-tx
# sync to LNCD server. 'r' config in ~/.ssh/config
rsync -Lavhi --size-only $ROOT r:/Volumes/Hera/Raw/MRprojects/7TBrainMech/
rsync -Lavhi --size-only $HOME/Data/ProcessedLunaROI-based/ r:/Volumes/Hera/Raw/MRprojects/7TBrainMech/MRSI_BrainMechR01/


log finish-tx
