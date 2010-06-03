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
    mdb-schema -S $1 | sed -e '
      /^--*/d;
      s/^drop table /DROP TABLE IF EXISTS /i;
      s%memo/hyperlink%TEXT%i;
      s/datetime (short)/DATETIME/i;
      s/boolean/INT/i;
      s/byte/INT/i;
      s/numeric/INT/i;
      s/replication ID/INT/i;
      s/long integer/INT/i;
      s/integer/INT/i;
      s/binary/BLOB/i;
      s/ole/BLOB/i;
      s/unkown ([0-9a-fx]+)?)/BLOB/i;
      s/currency/FLOAT/i;
      s/double/FLOAT/i;
      s/single/INT/i'

# Now dump the insert statements
    for i in $(mdb-tables -S $1 | sed -e '/^MSys*/d'); do
      mdb-export -SIR ";\n" $1 $i
    done

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

