#/bin/bash
#update the atomic mass based on atomic_mass.txt

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

cat ./atomic_mass.txt | while read ATOMIC_NUMBER BAR ATOMIC_MASS
do
  if [[ $ATOMIC_NUMBER -ne 'atomic_number' ]]
  then
    UPDATE_MASS=$($PSQL "UPDATE properties SET atomic_mass=$ATOMIC_MASS WHERE atomic_number=$ATOMIC_NUMBER")
    echo $UPDATE_MASS
  fi
done