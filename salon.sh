#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Beauty Salon ~~~~~\n"
echo -e "\nBook your next appointment today!"


    SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
    echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
    do
        echo "$SERVICE_ID) $SERVICE_NAME"
    done


    # service selected
    read SERVICE_SELECTED_ID
    SERVICE_EXIST=$($PSQL " SELECT service_id FROM services WHERE service_id=$SERVICE_SELECTED_ID")

    # if service doesnt exist
    if [[ -z $SERVICE_EXIST ]]
    then
        # send to main menu
        echo "I could not find that service. What would you like to book?"
        MAIN_MENU
    else
    # get customer info
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

        # if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          # get new customer name
          echo -e "\nI don't have a record for that phone number, what's your name?"
          read CUSTOMER_NAME
        

         # insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
        fi

        # get service selected name
        SERVICE_SELECTED_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_SELECTED_ID ")

        # get customer booking time
        echo -e "\nWhat time would you like your $(echo $SERVICE_SELECTED_NAME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
        read SERVICE_TIME

    fi
