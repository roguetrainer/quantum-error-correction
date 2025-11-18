# **Quantum Error Correction (QEC) Tooling and Framework Summary**

This report combines information on general-purpose Python frameworks that provide out-of-the-box QEC capabilities with a detailed overview of the specialized Fault-Tolerant Quantum Computing (FTQC) stacks from Entropica Labs and Riverlane.

## **1\. Python Frameworks for QEC Simulation and Experimentation**

Several open-source Python frameworks are available for researchers and developers to simulate, implement, and analyze quantum error correcting codes, often providing standard codes (like the Surface Code or Steane Code) for immediate use.

| Framework | Primary Focus | Key Features & Standard Codes |
| :---- | :---- | :---- |
| **FlamingPy** | Simulation of QEC under noise and decoding. | Focuses on statistical inference and decoding for stabilizer codes. Provides implementations for popular codes like the **5-qubit code**, **Steane code**, **Shor's code**, and **topological codes** (like the Surface Code). |
| **CUDA-Q QEC** | High-performance, GPU-accelerated QEC research. | Provides a framework for defining and simulating novel QEC codes. Includes GPU-accelerated decoders like **Tensor Network Decoder** and **Belief Propagation \+ OSD (BP+OSD)**. Python-accessible for defining code parameters and decoding syndromes. |
| **Qiskit** | General quantum computing and circuit design. | Qiskit includes modules and tutorials (often via the qiskit-experiments and related QEC packages) for constructing and simulating various QEC circuits, including those for the **Repetition Code** and **Surface Code**. |
| **Stim** | Fast, specialized stabilizer circuit simulation. | Developed by Google, Stim is designed for fast simulation of large stabilizer circuits and generating detector error models (DEMs) for decoding. It is often used in conjunction with other Python tools for visualization and analysis. |
| **Riverlane Deltakit** | Open-Source QEC learning and SDK. | Provides a Python SDK and interactive textbook for learning and experimenting with QEC concepts, codes, decoders, and noise models. This is Riverlane's developer-facing component for practical QEC adoption. |

## **2\. Industry-Focused QEC Stacks: Entropica Labs and Riverlane**

Both Entropica Labs and Riverlane are building end-to-end infrastructure to move the industry toward Fault-Tolerant Quantum Computing (FTQC), but with different strategic emphasis.

### **2.1 Entropica Labs**

Entropica focuses heavily on the **software stack for design, compilation, and orchestration**, simplifying the process of turning high-level quantum programs into fault-tolerant, hardware-ready circuits.

| Pillar | Framework/Tool | Description |
| :---- | :---- | :---- |
| **Design & Simulation** | **Loom Design (Open-Source)** | An open-source toolkit that includes **Entwine** (a visual, drag-and-drop IDE) combined with the programmatic power of Loom for designing, simulating, and experimenting with QEC circuits (e.g., surface codes/lattice surgery). |
| **Weave & Orchestration** | **Loom** (Flagship Platform) | The core software platform that automates QEC code design, translates logical QEC instructions into physical-level circuits, and generates the hybrid quantum-classical code required for execution. |
| **Data Structure** | **EKA** | A specialized data structure designed to preserve the context of low-level QEC instructions throughout the execution stack, serving as a single source of truth for error correction protocols. |

### **2.2 Riverlane**

Riverlane positions itself as a leader in QEC implementation, focusing on the **real-time hardware/software stack for high-speed decoding and control** that must operate faster than errors occur.

| Component | Framework/Tool | Description |
| :---- | :---- | :---- |
| **Real-Time Stack** | **Deltaflow** | Riverlane's comprehensive, full-stack QEC solution. It includes qubit data readout, highly optimized decoding (often on custom FPGA/ASIC chips), logical operations, and orchestration, all operating in real-time. |
| **Decoder Technology** | **Collision Clustering (CC) Decoder** | A proprietary, hardware-based decoder that uses optimized algorithms (like Union-Find) to achieve extremely fast decoding speeds (sub-microsecond), crucial for cryogenically-constrained quantum systems. |
| **Interface Standard** | **Quantum Error Correction Interface (QECi)** | A universal interface developed to standardize the communication protocol between a quantum computer's control system and any QEC stack, promoting interoperability. |
| **Developer Toolkit** | **Deltakit (Open-Source)** | An open-source SDK and textbook designed to help researchers and developers learn, simulate, and experiment with QEC circuits and real-time decoding protocols. |

**Summary:** While general Python libraries like **FlamingPy** and **CUDA-Q QEC** provide the foundational building blocks and standard code implementations for QEC research, companies like **Entropica Labs** (**Loom**) and **Riverlane** (**Deltaflow**) are creating full, integrated software and hardware platforms to manage the entire lifecycle of fault-tolerant quantum operations, from high-level code compilation to real-time error correction on physical hardware.