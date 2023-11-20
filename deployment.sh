#!/bin/bash

# GitHub Actions runner process name
RUNNER_PROCESS_NAME="Runner.Listener"

# Log file where memory and CPU usage will be stored
LOG_FILE="github_actions_usage.log"

# Interval in seconds between each memory check
INTERVAL=10

# Number of deployments
NUM_DEPLOYMENTS=5

# Function to get memory and CPU usage of the runner process
get_usage() {
    ps aux | grep "$RUNNER_PROCESS_NAME" | awk '/[R]unner.Listener/ {print $3, $4}'
}

# Function to calculate average usage
calculate_averages() {
    awk 'NR>1 {cpu_sum += $2; mem_sum += $3; count++} END {print "Average CPU Usage: " cpu_sum/count "%, Average Memory Usage: " mem_sum/count "%"}' $LOG_FILE
}

# Main monitoring loop
monitor() {
    echo "Monitoring memory and CPU usage of GitHub Actions runner..."
    echo "Timestamp, CPU Usage (%), Memory Usage (%)" > $LOG_FILE

    for (( i=1; i<=$NUM_DEPLOYMENTS; i++ ))
    do
        echo "Starting monitoring for deployment $i. Press any key to stop..."
        while true; do
            # Check if a key has been pressed
            read -t $INTERVAL -n 1 key
            if [ $? = 0 ]; then
                echo -e "\nStopped monitoring for deployment $i."
                break
            fi

            # Getting current memory and CPU usage
            read cpu_usage memory_usage <<< $(get_usage)

            # Getting current timestamp
            timestamp=$(date +"%Y-%m-%d %H:%M:%S")

            # Logging to file
            echo "$timestamp, $cpu_usage, $memory_usage" >> $LOG_FILE
        done
    done

    calculate_averages
}

monitor
