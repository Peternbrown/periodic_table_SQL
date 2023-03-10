#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  # find input (atomic number)
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER_VAR=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name='$1'")
  else
    ATOMIC_NUMBER_INT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  fi

  # define ATOMIC_NUMBER
  if [[ -z $ATOMIC_NUMBER_VAR ]]
  then
    ATOMIC_NUMBER=$ATOMIC_NUMBER_INT
  else
    ATOMIC_NUMBER=$ATOMIC_NUMBER_VAR
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    # define necessary variables
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types JOIN properties on types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_PT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_PT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

    # format necessary variables (get rid of leading spaces)
    ATOMIC_NUMBER_FORMAT=$(echo $ATOMIC_NUMBER | sed 's/ //g')
    NAME_FORMAT=$(echo $NAME | sed 's/ //g')
    SYMBOL_FORMAT=$(echo $SYMBOL | sed 's/ //g')
    TYPE_FORMAT=$(echo $TYPE | sed 's/ //g')
    ATOMIC_MASS_FORMAT=$(echo $ATOMIC_MASS | sed 's/ //g')
    MELTING_PT_FORMAT=$(echo $MELTING_PT | sed 's/ //g')
    BOILING_PT_FORMAT=$(echo $BOILING_PT | sed 's/ //g')

    # print message
    echo "The element with atomic number $ATOMIC_NUMBER_FORMAT is $NAME_FORMAT ($SYMBOL_FORMAT). It's a $TYPE_FORMAT, with a mass of $ATOMIC_MASS_FORMAT amu. $NAME_FORMAT has a melting point of $MELTING_PT_FORMAT celsius and a boiling point of $BOILING_PT_FORMAT celsius."
  fi
fi

# This works. Commenting to add git commit. 
# adding one more comment for commit #5
