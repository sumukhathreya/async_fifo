# Design and Verification of Asynchronous FIFO

This repository contains the RTL design and verification of an Asynchronous FIFO (First-In-First-Out) buffer, which is crucial for managing data transfer between different clock domains in digital systems. The Asynchronous FIFO ensures reliable and efficient data handling, even when the source and destination operate at different clock frequencies.

Key Features:
RTL Design: The Asynchronous FIFO is designed to facilitate data transfer across clock domains by implementing dual-port memory with separate read and write clock inputs. It includes gray code counters for pointer management and mechanisms for full and empty flag generation.

Cross-Clock Domain Synchronization: The FIFO employs gray code counters to manage read and write pointers, minimizing the risk of metastability issues. The design ensures data integrity during asynchronous data transfers.

Full and Empty Flag Management: The design includes logic to accurately generate full and empty flags, preventing data overflow or underflow, which is critical for reliable system operation.

Verification Using SystemVerilog: A comprehensive testbench was developed in SystemVerilog to verify the functionality of the Asynchronous FIFO. The testbench covers various scenarios, including different clock frequencies and data burst conditions.

This project showcases the complete design and verification process for an Asynchronous FIFO, making it a useful resource for those working on similar digital design challenges.
