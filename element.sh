#!/bin/bash
if [ $# -eq 0 ]; then
   echo -e "Please provide an element as an argument."
   exit 1
else
   SCRIPT_PARAM=$1
fi

PSQL_COMM="/usr/bin/psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"


# main
