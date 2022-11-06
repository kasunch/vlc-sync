#!/bin/bash

script_name_full=$(basename "${0}")
script_name_base="${script_name_full%%.*}"
script_file_full=$(readlink -f "${0}")
script_file_base="${script_file_full%%.*}"
script_dir=$(dirname "${script_file_full}")
script_dir_full=$(readlink -f "${script_dir}")

round=0
delay_start=0
delay_end=25
delay_increment=1

input_file="${script_dir_full}/ber_test_frames.csv"
data_dir="${script_dir_full}/delayed_tx_data_${round}"

if [ ! -f "${input_file}" ]; then
    echo "ERROR: Input file not found"
    exit 1
fi

mkdir -p ${data_dir}

counter=0
while [ ${counter} -le ${delay_end} ]; do
    delay=${counter}
    output_file="${data_dir}/delayed_tx-delay_${delay}.csv"

    if [ -f "${output_file}" ]; then
        echo "ERROR: Output file already exist: ${output_file}"
        counter=$(( ${counter} + ${delay_increment} ))
        continue
    fi

    python delayed_tx_test.py -o "${output_file}" -i "${input_file}" -d ${delay}
    
    counter=$(( ${counter} + ${delay_increment} ))
done
