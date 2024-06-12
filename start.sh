#!/bin/bash

echo "Worker Initiated"

echo "Symlinking files from Network Volume"
rm -rf /workspace && \
  ln -s /runpod-volume /workspace


# Print the contents of /workspace
echo "Contents of /workspace:"
ls -la /workspace

# Print the contents of /app
echo "Contents of /app:"
ls -la /app

# Print the contents of /app/src
echo "Contents of /app/src:"
ls -la /app/src

echo "Starting ComfyUI API"
export PYTHONUNBUFFERED=true
export HF_HOME="/workspace"
source /workspace/venv/bin/activate

python3 /workspace/ComfyUI/main.py --port 3000 > /workspace/logs/comfyui.log 2>&1 &
deactivate

python3 comfy_serverless.py