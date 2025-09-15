echo "Starting script..."

PROGRAM_PATH="/home/jialun/keydoc/ww3_fortran/WW3_ml/"
COMMAND_PATH="./regtests/bin/run_cmake_test"
MODEL_PATH="model"
OUTPUT_PATH="temp"
RUN_NAME="regtests/ww3_ts1_test"

cd $PROGRAM_PATH

$COMMAND_PATH -w $OUTPUT_PATH -s ST4 -N -o netcdf $MODEL_PATH $RUN_NAME

echo "Script finished."

