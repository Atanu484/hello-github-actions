# hello-github-actions
# Bash Script that calculates memory and cpu usage
#!/bin/bash

# Check for required arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <process_name> <number_of_sessions>"
    exit 1
fi

# Process name to be monitored
PROCESS_NAME=$1

# Number of monitoring sessions
NUM_SESSIONS=$2

# Log file where memory and CPU usage will be stored
LOG_FILE="process_usage.log"

# Interval in seconds between each check
INTERVAL=10

# Function to get memory and CPU usage of the specified process
get_usage() {
    ps aux | grep "$PROCESS_NAME" | grep -v grep | awk '{cpu+=$3; mem+=$4; count++} END {if (count > 0) print cpu/count, mem/count; else print 0, 0}'
}

# Function to calculate average usage
calculate_averages() {
    awk 'NR>1 {cpu_sum += $2; mem_sum += $3; count++} END {if (count > 0) {print "Average CPU Usage: " cpu_sum/count "%, Average Memory Usage: " mem_sum/count "%"} else {print "No data collected"}}' $LOG_FILE
}

# Main monitoring function
monitor() {
    echo "Monitoring $PROCESS_NAME..."
    echo "Timestamp, Average CPU Usage (%), Average Memory Usage (%)" > $LOG_FILE

    for (( i=1; i<=$NUM_SESSIONS; i++ ))
    do
        echo "Starting monitoring session $i. Press any key to stop..."
        read -t $INTERVAL -n 1
        if [ $? = 0 ]; then
            echo "Stopped monitoring for session $i."
            return
        fi

        while true; do
            # Getting current average memory and CPU usage
            read cpu_usage memory_usage <<< $(get_usage)

            # Getting current timestamp
            timestamp=$(date +"%Y-%m-%d %H:%M:%S")

            # Logging to file
            echo "$timestamp, $cpu_usage, $memory_usage" >> $LOG_FILE

            # Wait for the specified interval
            sleep $INTERVAL
        done
    done

    calculate_averages
}

monitor

