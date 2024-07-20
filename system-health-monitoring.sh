#!/bin/bash

#############################

CPU=80
MEMORY=80
DISK=80
LOG_FILE="/var/log/health.log"


check_cpu_usage() {
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
  echo "CPU usage: ${cpu_usage}%"
  if (( $(echo "$cpu_usage > $CPU" | bc -l) )); then
    echo "ALERT: CPU usage is above threshold: ${cpu_usage}%" | tee -a $LOG_FILE
  fi
}


check_memory_usage() {
  memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  echo "Memory usage: ${memory_usage}%"
  if (( $(echo "$memory_usage > $MEMORY" | bc -l) )); then
    echo "ALERT: Memory usage is above threshold: ${memory_usage}%" | tee -a $LOG_FILE
  fi
}


check_disk_space() {
  disk_usage=$(df -h / | grep / | awk '{print $5}' | sed 's/%//')
  echo "Disk usage: ${disk_usage}%"
  if [ $disk_usage -gt $DISK ]; then
    echo "ALERT: Disk usage is above threshold: ${disk_usage}%" | tee -a $LOG_FILE
  fi
}


check_running_processes() {
  process_count=$(ps aux | wc -l)
  echo "Running Processes are: ${process_count}"
}

#functions
check_cpu_usage
check_memory_usage
check_disk_space
check_running_processes

