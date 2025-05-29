#!/bin/bash
# Script to show information about chemical elements from the periodic_table from database

# Set up the PSQL variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check Arg if was passed
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Determine the query condition
if [[ $1 =~ ^[0-9]+$ ]]; then
  CONDITION="atomic_number = $1"
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]; then
  CONDITION="symbol = '$1'"
else
  CONDITION="name = '$1'"
fi

# Perform the query
ELEMENT=$($PSQL "
  SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
  FROM elements 
  JOIN properties USING(atomic_number) 
  JOIN types USING(type_id) 
  WHERE $CONDITION
")

# Check if element was found
if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

# Read values from the result
IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$ELEMENT"

# Print result
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
# This is a great exercise.