#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $# -ne 1 ]]
then
  echo "Please provide an element as an argument."
else
  #determine what the input is (symbol, name, atom number)
  ELEMENT_FOUND="false"
  #check if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #do queries here for atom number input
    IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $($PSQL "SELECT elements.atomic_number, name, symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number LEFT JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number=$1")
    if [[ $ATOMIC_NUMBER ]]
    then
      ELEMENT_FOUND="true"
    fi
  else
    #check if argument is only 
    if [[ ${#1} -le 2 ]]
    then
      #do queries for symbol
      IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $($PSQL "SELECT elements.atomic_number, name, symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number LEFT JOIN types ON properties.type_id=types.type_id WHERE elements.symbol='$1'")
      if [[ $ATOMIC_NUMBER ]]
      then
        ELEMENT_FOUND="true"
      fi
    else
      #do queries for name
      IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $($PSQL "SELECT elements.atomic_number, name, symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number LEFT JOIN types ON properties.type_id=types.type_id WHERE elements.name='$1'")
      if [[ $ATOMIC_NUMBER ]]
      then
        ELEMENT_FOUND="true" 
      fi
    fi
  fi
  if [[ $ELEMENT_FOUND == "false" ]]
  then
    echo "I could not find that element in the database."
  else
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi