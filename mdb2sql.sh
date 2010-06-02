#!/bin/bash
#
# Written By: Jason Gardner (Buhrietoe)
#
# This script exports table data from an access MDB file to an SQL file, ready to be imported

# Parameter given, lets try this!
if [ $# -gt 0 ]; then

# Make sure the MDB file exists
  if [ -e $1 ]; then
# First dump the schema
    mdb-schema -S $1 | perl -wpe 's%^DROP TABLE %DROP TABLE IF EXISTS %i;
      s%(Memo/Hyperlink|DateTime( \(Short\))?)%TEXT%i;
      s%(Boolean|Byte|Byte|Numeric|Replication ID|(\w+ )?Integer)%INTEGER%i;
      s%(BINARY|OLE|Unknown ([0-9a-fx]+)?)%BLOB%i;
      s%\s*\(\d+\)\s*(,?[ \t]*)$%${1}%;'
# Now dump the insert statements
    for i in $(mdb-tables -S $1 | sed '/^MSys*/d'); do echo $i; mdb-export -SIR ";\n" $1 $i; done

  else

# The MDB file specified doesn't exist fool!
    echo $1 "doesn't exist fool!"
  fi

else

# No parameters given, display help
  echo "Written by: Jason Gardner (buhrietoe)"
  echo "This script depends on the mdbtools package, you can obtain a copy at http://sourceforge.net/projects/mdbtools/"
  echo "Usage:" $(basename $0) "MDBFILE"

fi

