//qec_codes.qs

namespace QuantumErrorCorrection {open Microsoft.Quantum.Canon;open Microsoft.Quantum.Intrinsic;open Microsoft.Quantum.Measurement;open Microsoft.Quantum.Diagnostics;//////////////////////////////////////////////////////////////////////
// 1. 3-QUBIT BIT-FLIP CODE (Simple Repetition Code)
// Corrects single X-errors (bit-flips).
//////////////////////////////////////////////////////////////////////

/// # Summary
/// Encodes a single logical qubit (qL) into three physical qubits.
/// Logical state |0>L -> |000>, |1>L -> |111>.
operation EncodeBitFlipCode(qL: Qubit, codeRegister: Qubit[]) : Unit is Adj+Ctl {
    // Assume codeRegister has 3 physical qubits
    Controlled X(qL, codeRegister[0]);
    Controlled X(qL, codeRegister[1]);
    Controlled X(qL, codeRegister[2]);
}

/// # Summary
/// Measures the syndrome (S1=Z1Z2, S2=Z2Z3) to identify the error location.
/// Syndrome measurements are non-destructive to the logical state.
operation MeasureSyndrome(codeRegister: Qubit[], syndromeRegister: Qubit[]) : (Result, Result) {
    // S1: Z0Z1 check using syndromeRegister[0]
    [Controlled] ApplyToEach(Z, [codeRegister[0], codeRegister[1]], syndromeRegister[0]);
    // S2: Z1Z2 check using syndromeRegister[1]
    [Controlled] ApplyToEach(Z, [codeRegister[1], codeRegister[2]], syndromeRegister[1]);

    // Measure ancilla qubits (syndrome) and reset them
    let s1 = M(syndromeRegister[0]);
    let s2 = M(syndromeRegister[1]);

    Reset(syndromeRegister[0]);
    Reset(syndromeRegister[1]);

    return (s1, s2);
}

/// # Summary
/// Applies the necessary correction based on the measured syndrome.
operation RecoverBitFlipCode(syndrome: (Result, Result), codeRegister: Qubit[]) : Unit {
    let (s1, s2) = syndrome;

    // Syndrome mapping:
    // (0, 0) -> No error (I)
    // (1, 0) -> Error on Qubit 0 (X0)
    // (1, 1) -> Error on Qubit 1 (X1)
    // (0, 1) -> Error on Qubit 2 (X2)
    if (s1 == One and s2 == Zero) {
        X(codeRegister[0]); // Correction on Qubit 0
    } elif (s1 == One and s2 == One) {
        X(codeRegister[1]); // Correction on Qubit 1
    } elif (s1 == Zero and s2 == One) {
        X(codeRegister[2]); // Correction on Qubit 2
    }
    // else (0,0): no error, no correction
}

/// # Summary
/// Pure Q# test operation demonstrating the code's effectiveness.
operation TestBitFlipCode() : (Result, Result) {
    // Allocate 1 logical qubit (to hold data) and 3 physical qubits (code register)
    use (qL, codeReg, syndromeReg) = (Qubit(), Qubit[3], Qubit[2]);

    // 1. Encode the logical state (|0>L)
    EncodeBitFlipCode(qL, codeReg);

    // 2. Apply a simulated error (Bit-flip on Qubit 1)
    X(codeReg[1]);

    // 3. Measure Syndrome
    let syndrome = MeasureSyndrome(codeReg, syndromeReg);

    // 4. Recover
    RecoverBitFlipCode(syndrome, codeReg);

    // 5. Decode and check if the original logical state is recovered
    // We only need to check the first qubit after correction due to the repetition code structure.
    let correctedState = M(codeReg[0]);
    
    // Clean up
    Reset(qL);
    ResetAll(codeReg);
    
    return (correctedState, syndrome[0]);
}


//////////////////////////////////////////////////////////////////////
// 2. 5-QUBIT STABILIZER CODE (Block Code)
// Corrects any single X or Z error.
//////////////////////////////////////////////////////////////////////

/// # Summary
/// Implements one of the four essential stabilizer generators for the 5-qubit code: Z_0 X_1 X_2 Z_3 I_4.
/// The full code requires four such measurements for full syndrome extraction.
operation MeasureFiveQubitStabilizer(codeReg: Qubit[], ancilla: Qubit) : Result {
    
    // Stabilizer G1: Z0 X1 X2 Z3 I4
    
    // X-parts (X1, X2) are measured in the X-basis (apply H before and after CNOTs/Control)
    H(ancilla);
    
    // CZ0: Z component (Qubit 0)
    Controlled Z(codeReg[0], ancilla);
    
    // CX1, CX2: X components (Qubit 1, Qubit 2)
    Controlled X(ancilla, codeReg[1]);
    Controlled X(ancilla, codeReg[2]);
    
    // CZ3: Z component (Qubit 3)
    Controlled Z(codeReg[3], ancilla);

    // X-parts end (measure in Z basis relative to ancilla's X-basis)
    H(ancilla);

    // Measure and return the stabilizer result
    let result = M(ancilla);
    Reset(ancilla);
    return result;
}
}