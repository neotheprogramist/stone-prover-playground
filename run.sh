#!/usr/bin/env bash

# Define the name of the virtual environment
VENV_NAME=".venv"

# Check if the virtual environment already exists
if [ ! -d "$VENV_NAME" ]; then
    # If it doesn't exist, create the virtual environment
    python -m venv $VENV_NAME

    # Activate the virtual environment
    source $VENV_NAME/bin/activate && \

    # Upgrade pip to the latest version
    pip install --upgrade pip && \

    # Install the required packages from the requirements.txt file
    pip install -r requirements.txt && \

    # Deactivate the virtual environment
    deactivate
else
    # If it does exist, print a message indicating that it already exists
    echo "Virtual environment $VENV_NAME already exists."
fi && \

# Compile the main Cairo file
source .venv/bin/activate && \
cairo-compile \
  main.cairo \
  --output main_compiled.json \
  --proof_mode && \
deactivate && \

# Prove the compiled file
stone-prover-cli prove \
  --program-input main_input.json \
  --layout starknet \
  --prover-config-file cpu_air_prover_config.json \
  --parameter-file cpu_air_params.json \
  --output-file main_proof.json \
  main_compiled.json
