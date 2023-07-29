#! /bin/bash
#number guessing game for fcc certification

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"

USER_NAME=""
while [[ $USER_NAME == "" ]] || [[ ${#USER_NAME} -gt 22 ]]
do
  read USER_NAME
done

IFS="|" read -r USER_ID GAMES_PLAYED BEST_GAME<<< $($PSQL "SELECT user_id, games_played, best_game FROM users WHERE user_name='$USER_NAME'")

if [[ $USER_ID =~ ^[0-9]+$ ]]
then
  echo -e "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
else
  IFS="|" read -r USER_ID BEST_GAME <<< $($PSQL "INSERT INTO users (user_name) VALUES ('$USER_NAME') RETURNING user_id, best_game")
  echo -e "Welcome, $USER_NAME! It looks like this is your first time here."
fi

RANDOM_NUMBER=$(( $RANDOM % 999 + 1))

echo -e "\nGuess the secret number between 1 and 1000:"

GUESSES=0

while [[ $GUESS -ne $RANDOM_NUMBER ]]
do
  read GUESS
  GUESSES=$(( GUESSES+=1 ))
  
  if [[ $GUESS -eq $RANDOM_NUMBER ]]
  then
    #update number of games played
    RESULT=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE user_id=$USER_ID")
    #update best game IF lower then current best game
    if [[ GUESSES -lt BEST_GAME ]]
    then
      RESULT=$($PSQL "UPDATE users SET best_game = $GUESSES WHERE user_id=$USER_ID")
    fi
    #print done game to terminal
    echo -e "You guessed it in $GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"
  elif ! [[ $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $GUESS -lt $RANDOM_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  elif [[ $GUESS -gt $RANDOM_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  fi

done