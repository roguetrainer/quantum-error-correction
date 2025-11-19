#!/bin/bash

# --- Environment Setup Script ---

VENV_NAME=".venv"

echo "Starting project setup..."
echo "1. Creating virtual environment: $VENV_NAME"

# Create a virtual environment if it doesn't exist
if [ ! -d "$VENV_NAME" ]; then
    python3 -m venv "$VENV_NAME"
    echo "Virtual environment created successfully."
else
    echo "Virtual environment '$VENV_NAME' already exists."
fi

# Attempt to activate the virtual environment and install dependencies
echo "2. Activating environment and installing dependencies from requirements.txt..."

# Source the activation script (using bash syntax for sourcing)
source "$VENV_NAME/bin/activate"

# Install dependencies
if [ -f "requirements.txt" ]; then
    pip install --upgrade pip
    pip install -r requirements.txt
    echo "Dependencies installed successfully."
else
    echo "Warning: 'requirements.txt' not found. Skipping dependency installation."
fi

echo "3. Deactivating environment"
# Deactivate the environment after setup is complete (optional, but good practice for scripts)
deactivate

echo "--- Setup Complete ---"
echo "To start working, run: source $VENV_NAME/bin/activate"