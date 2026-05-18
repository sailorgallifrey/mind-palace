#!/bin/bash
#
# Example:
#   time /bin/bash ./ramp.sh
#
# Description:
#   Every iteration we'll increase the number of concurrent users by 50
#   Each iteration adds an aditional 5 minutes (300s)
#   So after 75 minutes we'll reach our final iteration
#   Which will then run for 30mins and will push through 300 concurrent requests a second over that period
#   So on the last iteration we'll hit the service 540,000 times over the last 30 minutes period (300*1800)

rates=(5 10 40 50 75 100)
durations=(5s 10s 90s 120s 200s 300s)
url=$1

for i in $(seq 0 5); do
   printf "\t- rate: ${rates[$i]} rps | duration: ${durations[$i]}\n" # Bash 4.2 supports ${var::-1} for removing n number of characters from end of a string
   echo "GET $url" | vegeta attack -rate="${rates[$i]}" -duration="${durations[$i]}" -insecure > "results-${i}.bin"
done

# Main result
printf "\n\nCombined results:\n\n"
vegeta report -inputs="$(echo results-*.bin | tr ' ' ',')"

# Individual results
printf "\n\nIndividual results:\n\n"
for i in $(seq 0 5); do
  cat "results-${i}.bin" | vegeta report
  printf "\n\n"
done

# Cleanup
for i in $(seq 0 5); do
   rm "results-${i}.bin"
done
