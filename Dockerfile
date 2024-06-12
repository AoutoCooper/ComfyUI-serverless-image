# Use Nvidia CUDA base image
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04 as base

# Prevents prompts from packages asking for user input during installation
ENV DEBIAN_FRONTEND=noninteractive
# Prefer binary wheels over source distributions for faster pip installations
ENV PIP_PREFER_BINARY=1
# Ensures output from python is printed immediately to the terminal without buffering
ENV PYTHONUNBUFFERED=1 

# Set the working directory
WORKDIR /app

# Install Python, git and other necessary tools
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    wget

# Clean up to reduce image size
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*


# Add requirements.txt file
ADD requirements.txt /app

# Add comfy_serverless.py to the root of the container
ADD comfy_serverless.py /app/

# Add test_payload.json to the root of the container
ADD test_payload.json /app/

# Add source code
ADD src /app/src

#add start.sh
ADD start.sh /app/


# Install Python dependencies
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 \
    && pip3 install --no-cache-dir xformers==0.0.21 \
    && pip3 install -r requirements.txt && \
    rm requirements.txt

# Install runpod
RUN pip3 install runpod requests

# Set the PYTHONPATH environment variable to include /app
ENV PYTHONPATH="/app"

RUN chmod +x /app/start.sh


# Start the container
ENTRYPOINT ["/app/start.sh"]
