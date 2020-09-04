#!/usr/bin/env bash
# 20200512 - update links to extra year directory
for bl in MRprojects/7TBrainMech/*/DICOM/* MRprojects/7TBrainMech/*/CSIPFC/siarray.1.1 MRprojects/7TBrainMech/*/CoregPFC/CoregPFC; do
  # no star, is readable (link)
  [[ $bl =~ \* ]] && echo "# '$bl' is not a good name!" && continue
  [ -d "$bl" ] && echo "# '$bl' is a dir" && continue
  [ -r "$bl" ] && echo "# '$bl' is readable" && continue
  # skip if link is okay
  [ ! -L "$bl" ] && echo "#'$bl' link is no okay" && continue
  to=$(find $bl -printf '%l')
  ! [[ $to =~ /(20[0-9][0-9]) ]] && echo "# no date in '$to' (from $bl)" && continue
  fix=${to/Data\//Data\/${BASH_REMATCH[1]}\/}
  [ ! -r "$fix" ] && echo "# fix $fix DNE (from $to)" && continue
  echo "rm $bl # $to"
  echo "ln -s $fix $bl"
 done 
