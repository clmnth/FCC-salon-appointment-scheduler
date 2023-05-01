#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Beauty Salon ~~~~~\n"
echo -e "\nBook your next appointment today!"

MAIN_MENU() {
    SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
    echo "$SERVICES" | while read SERVICE_ID BAR NAME
    do
        echo "$SERVICE_ID) $NAME "
    done

    # service selected
    read SERVICE_ID_SELECTED
    SERVICE_EXIST=$($PSQL " SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

    if [[ -z $SERVICE_EXIST ]]
    then
        # send to main menu
        echo "I could not find that service. What would you like to book?"
        MAIN_MENU
    fi
}

MAIN_MENU
