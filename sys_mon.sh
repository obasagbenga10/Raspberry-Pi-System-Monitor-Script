#!/bin/bash

LOG_FILE="/home/pi/monitor.txt"

get_temp() {
   temperature=$(cat /sys/class/thermal/thermal_zone0/temp)
   temperature=$(echo "scale=2; $temperature/1000" | bc)
   echo "$temperature"
}

get_cpu_usage() {
   cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
   cpu_usage=$(echo "scale=2; $cpu_usage" | bc)
   echo "$cpu_usage"
}

get_ram() {
   ram_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
   ram-usage=$(echo "scale=2; $ram_usage" | bc)
   echo "$ram_usage"
}


get_clock() {
  clock_speed=$(vcgencmd measure_clock arm | awk -F "=" '{print $2}')
  clock_speed=$(echo "scale=2; $clock_speed/1000000" | bc)
  echo "$clock_speed"
}

get_most_proc() {
   most_cpu_process=$(ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | awk 'NR==2 {print $3}')
   echo "$most_cpu_process"
}

while true; do

	current_time=$(date +"%Y-%m-%d %H:%M:%S")

	temperature=$(get_temp)

	cpu_usage=$(get_cpu_usage)

	ram_usage=$(get_ram)

	clock_speed=$(get_clock)

	most_cpu_process=$(get_most_proc)

	echo "Time: $current_time | Temperature: $temperature C | CPU Usage: $cpu_usage% | RAM Usage: $ram_usage% | Clock Speed: $clock_speed MHz | Most CPU Process: $most_cpu_process" >> "$LOG_FILE"

	sleep 1
done
