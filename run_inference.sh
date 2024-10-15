#!/bin/bash

# Define parameter arrays
phases=("val" "test")
datasets=("xarray" "video")
data_paths=("/scratch/users/databases/dynamicearthnet-xarray/" "/scratch/users/databases/dynamicearthnet-video-59psnr/")
models=("utae" "uconvlstm" "single_unet" "3dconv")
times=("weekly" "monthly")

# Log file to capture the output
log_file="inference_results.log"

# Clear the log file at the start
> "$log_file"

# Iterate over all parameter combinations
for phase in "${phases[@]}"; do
  for i in "${!datasets[@]}"; do
    dataset="${datasets[$i]}"
    data="${data_paths[$i]}"
    for model in "${models[@]}"; do
      for time in "${times[@]}"; do
        # Construct the checkpoint path based on the model and time
        checkpoint="./weights/${model}/${time}/best_ckpt.pth"
        
        # Construct the command
        command="python inference.py --phase ${phase} --config config/defaults.yaml --checkpoint ${checkpoint} --dataset ${dataset} --model ${model} --time ${time} --data ${data}"
        
        # Print and execute the command, and redirect the output to the log file
        echo "Running command: ${command}" | tee -a "$log_file"
        ${command} >> "$log_file" 2>&1
      done
    done
  done
done