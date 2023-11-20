#!/bin/bash
# Identify the process using port 8000
PID=$(lsof -t -i:8000)

# Kill the process if it exists
if [ ! -z "$PID" ]; then
  echo "Killing process on port 8000 with PID: $PID"
  kill $PID
else
  echo "No process found on port 8000"
fi

java -jar /var/lib/jenkins/workspace/test2/target/demo-0.0.1-SNAPSHOT.jar &
