#!/bin/bash
CPU_THRESHOLD=80.0
MEM_THRESHOLD=80.0
TO="krishnasairayavaram2005@gmail.com"
subj="System Resource Usage Alert"
log_file="./usage.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
mem_usage=$(free | grep "Mem" | awk '{printf "%.2f", $3/$2 * 100.0}')
echo "$TIMESTAMP - CPU: $cpu_usage%, Memory: $mem_usage%" >> "$log_file"
alert=false
msg="System Resource Alert at $TIMESTAMP\n\n"
if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
  msg+="⚠️ CPU usage is above threshold!\nCurrent: $cpu_usage% | Limit: $CPU_THRESHOLD%\n\n"
  alert=true
fi

if (( $(echo "$mem_usage > $MEM_THRESHOLD" | bc -l) )); then
  msg+="⚠️ Memory usage is above threshold!\nCurrent: $mem_usage% | Limit: $MEM_THRESHOLD%\n\n"
  alert=true
fi

if [ "$alert" = true ]; then
  echo -e "$msg" | mail -s "$subj" "$TO"
fi
