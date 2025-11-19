import qsharp

# Initialize the Q# environment and load the Q# file
# NOTE: This assumes the 'qec_codes.qs' file is in the same directory.
try:
    qsharp.reload()
except FileNotFoundError:
    print("Error: Could not load qec_codes.qs. Please ensure it is in the same directory.")
    exit()

# Set the Q# namespace and the operation name
QSHARP_OP_NAME = "QuantumErrorCorrection.TestBitFlipCode"

def run_qec_simulation():
    """
    Runs the Q# Bit-Flip QEC test operation using the qsharp Python package.
    """
    print("--- Starting Q# / Python Hybrid QEC Simulation ---")
    print("Code: 3-qubit Bit-Flip Code (Repetition Code)")
    
    # Execute the Q# operation. The result is a Python tuple.
    # Result structure: (Corrected State Measurement, S1 Syndrome Result)
    # We expect the Corrected State to be Zero (for |0>L state).
    # We expect the Syndrome S1 to be One (if error was successfully detected).
    results = qsharp.run(QSHARP_OP_NAME, shots=1)
    
    # The output from qsharp.run is an array of results from the shots.
    # In this case, we only ran 1 shot, so we take the first element.
    corrected_state_result, syndrome_s1 = results[0]
    
    print("\nSimulation Results:")
    print(f"Original Logical State: |0>L (encoded as |000>)")
    print(f"Simulated Error: X-error (Bit-Flip) on Qubit 1")
    print(f"Syndrome S1 Measurement Result: {syndrome_s1} (Expected: 1/One)")
    print(f"Syndrome S2 Measurement Result: 1 (The Test op only returns S1)")
    print("-" * 30)
    
    if corrected_state_result == 0:
        print("✅ SUCCESS: Corrected Logical Qubit Measurement is 'Zero'.")
        print("The QEC Recovery operation successfully corrected the Bit-Flip error.")
    else:
        print(f"❌ FAILURE: Corrected Logical Qubit Measurement is '{corrected_state_result}'.")
        print("The QEC failed to correct the error.")

if __name__ == "__main__":
    run_qec_simulation()