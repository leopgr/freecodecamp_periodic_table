#!/bin/bash
if [ $# -eq 0 ]; then
   echo -e "Please provide an element as an argument."
   exit 1
else
   SCRIPT_PARAM=$1
fi

PSQL_COMM="/usr/bin/psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

   re='^[0-9]+$'
   if [[ $SCRIPT_PARAM =~ $re ]] ; then
      # check if was provided atomic_number
      QUERY="select count(*) from elements where atomic_number=$SCRIPT_PARAM"
      ELEM_EXISTS=$($PSQL_COMM "$QUERY")

      if [ $ELEM_EXISTS -ne 0 ]; then
         ATOMIC_NUMBER=$SCRIPT_PARAM
      fi
   fi
   
   # check if was provided symbol
   if [ $ELEM_EXISTS -eq 0 ]; then
      QUERY="select count(*) from elements where symbol='${SCRIPT_PARAM^}'"
      ELEM_EXISTS=$($PSQL_COMM "$QUERY")

      if [ $ELEM_EXISTS -ne 0 ]; then
         QUERY="select atomic_number from elements where symbol='${SCRIPT_PARAM^}'"
         ATOMIC_NUMBER=$($PSQL_COMM "$QUERY")
      else
        # check if was provided name
         QUERY="select count(*) from elements where name='${SCRIPT_PARAM^}'"
         ELEM_EXISTS=$($PSQL_COMM "$QUERY")

         if [ $ELEM_EXISTS -ne 0 ]; then
            QUERY="select atomic_number from elements where name='${SCRIPT_PARAM^}'"
            ATOMIC_NUMBER=$($PSQL_COMM "$QUERY")
         fi
      fi
   fi

   if [ $ELEM_EXISTS -ne 0 ]; then
      QUERY="select name from elements where atomic_number=$ATOMIC_NUMBER"
      ELEMENT_NAME=$($PSQL_COMM "$QUERY")
      
      QUERY="select symbol from elements where atomic_number=$ATOMIC_NUMBER"
      ELEMENT_SYMBOL=$($PSQL_COMM "$QUERY")

      QUERY="select types.type from types join properties on types.type_id=properties.type_id \
join elements on elements.atomic_number=properties.atomic_number where elements.atomic_number=$ATOMIC_NUMBER"
      ELEMENT_TYPE=$($PSQL_COMM "$QUERY")

      QUERY="select melting_point_celsius from properties where atomic_number=$ATOMIC_NUMBER"
      MELTING_POINT=$($PSQL_COMM "$QUERY")

      QUERY="select boiling_point_celsius from properties where atomic_number=$ATOMIC_NUMBER"
      BOILING_POINT=$($PSQL_COMM "$QUERY")

      QUERY="select atomic_mass::REAL from properties where atomic_number=$ATOMIC_NUMBER"
      ATOMIC_MASS=$($PSQL_COMM "$QUERY")

      ATOMIC_NUMBER="$(echo -e "${ATOMIC_NUMBER}" | tr -d '[:space:]')"
      ELEMENT_NAME="$(echo -e "${ELEMENT_NAME}" | tr -d '[:space:]')"
      ELEMENT_SYMBOL="$(echo -e "${ELEMENT_SYMBOL}" | tr -d '[:space:]')"
      ATOMIC_MASS="$(echo -e "${ATOMIC_MASS}" | tr -d '[:space:]')"
      MELTING_POINT="$(echo -e "${MELTING_POINT}" | tr -d '[:space:]')"
      BOILING_POINT="$(echo -e "${BOILING_POINT}" | tr -d '[:space:]')"

      echo -e "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a nonmetal, with a mass of $ATOMIC_MASS amu. \
$ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
   else
      echo -e "I could not find that element in the database."
   fi

# main
fn get_element
