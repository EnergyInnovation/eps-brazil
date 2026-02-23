#!/bin/bash

# Script to time Vensim model execution and log results
# Usage: ./time_model_run.sh [vensim_path] [script_file]
# Example: ./time_model_run.sh "/Applications/VensimDSSMC.app/Contents/MacOS/VensimDSSMC" "run_model.cmd"

# Default values
VENSIM_APP_NAME="VensimDSSMC-Dev.app"
VENSIM_PATH="${1:-/Applications/$VENSIM_APP_NAME/Contents/MacOS/VensimDSSMC}"
SCRIPT_FILE="${2:-run_model.cmd}"
LOG_FILE="run_times.log"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to script directory
cd "$SCRIPT_DIR" || exit 1

# Initialize log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    echo "Vensim Model Execution Times" > "$LOG_FILE"
    echo "=============================" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
fi

# Record start time
START_TIME=$(date +%s.%N)
START_TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "Starting model run at $START_TIMESTAMP"
echo "Vensim App: $VENSIM_APP_NAME"
echo "Vensim: $VENSIM_PATH"
echo "Script: $SCRIPT_FILE"
echo ""

# Execute the Vensim command
"$VENSIM_PATH" "$SCRIPT_FILE"
EXIT_CODE=$?

# Record end time
END_TIME=$(date +%s.%N)
END_TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Calculate duration
DURATION=$(echo "$END_TIME - $START_TIME" | bc)

# Format duration as minutes and seconds using awk
# eval $(echo "$DURATION" | awk '{minutes=int($1/60); seconds=$1-(minutes*60); printf "DURATION_MIN=%d DURATION_SEC=%.1f", minutes, seconds}')
eval $(echo "$DURATION" | awk '{minutes=int($1/60); seconds=$1-(minutes*60); printf "DURATION_MIN=%d DURATION_SEC=%d", minutes, seconds}')

# Log the results
echo "" >> "$LOG_FILE"
echo "Vensim App:   $VENSIM_APP_NAME" >> "$LOG_FILE"
echo "Run started:  $START_TIMESTAMP" >> "$LOG_FILE"
echo "Run ended:    $END_TIMESTAMP" >> "$LOG_FILE"
echo "Duration:     ${DURATION_MIN}m ${DURATION_SEC}s (${DURATION}s)" >> "$LOG_FILE"
echo "Exit code:    $EXIT_CODE" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"

# Display results
echo "Model run completed at $END_TIMESTAMP"
echo "Duration: ${DURATION_MIN}m ${DURATION_SEC}s (${DURATION}s)"
echo "Exit code: $EXIT_CODE"
echo ""
echo "Results logged to $LOG_FILE"

# Audible notification - three gentle beeps
printf '\a'
sleep 0.2
printf '\a'
sleep 0.2
printf '\a'

exit $EXIT_CODE
