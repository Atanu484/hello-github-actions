#!/bin/bash

# Process name to monitor
PROCESS_NAME="Runner.Listener"

# Duration for monitoring (in seconds)
DURATION=600

# Interval for checking usage (in seconds)
INTERVAL=5

# Initialize counters
total_cpu=0
total_mem=0
count=0

# Start monitoring
end=$((SECONDS+DURATION))
while [ $SECONDS -lt $end ]; do
    # Extract CPU and memory usage of the process
    while read -r pid cpu mem; do
        total_cpu=$(echo "$total_cpu + $cpu" | bc)
        total_mem=$(echo "$total_mem + $mem" | bc)
        ((count++))
    done < <(ps -C "$PROCESS_NAME" -o pid=,%cpu=,%mem=)

    sleep $INTERVAL
done

# Calculate averages
if [ $count -ne 0 ]; then
    avg_cpu=$(echo "scale=2; $total_cpu / $count" | bc)
    avg_mem=$(echo "scale=2; $total_mem / $count" | bc)
    echo "Average CPU Usage: $avg_cpu%"
    echo "Average Memory Usage: $avg_mem%"
else
    echo "No process found with the name $PROCESS_NAME"
fi
