

#!/bin/bash



# Define variables

APACHE_STATUS_URL=${APACHE_STATUS_URL}

MAX_REQUESTS=${MAX_REQUESTS}

MAX_IDLE_WORKERS=${MAX_IDLE_WORKERS}



# Get Apache server status

STATUS=$(curl -s $APACHE_STATUS_URL)



# Extract number of requests and idle workers from the server status

REQUESTS=$(echo "$STATUS" | awk '/^Total Accesses/ {print $3}')

IDLE_WORKERS=$(echo "$STATUS" | awk '/^IdleWorkers/ {print $2}')



# Check if the number of requests exceeds the maximum allowed

if [ "$REQUESTS" -gt "$MAX_REQUESTS" ]; then

    echo "Error: Number of requests ($REQUESTS) exceeds maximum allowed ($MAX_REQUESTS)"

fi



# Check if the number of idle workers is below the minimum required

if [ "$IDLE_WORKERS" -lt "$MAX_IDLE_WORKERS" ]; then

    echo "Error: Number of idle workers ($IDLE_WORKERS) is below the minimum required ($MAX_IDLE_WORKERS)"

fi



# Exit with success status

exit 0