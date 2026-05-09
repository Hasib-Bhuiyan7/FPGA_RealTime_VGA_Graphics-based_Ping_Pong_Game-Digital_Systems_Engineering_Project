\# FPGA VGA Ping Pong Game – Digital Systems Engineering Project



\## Project Overview



This project was completed as part of \*\*COE 758 – Digital Systems Engineering\*\* using the \*\*Xilinx Spartan-3E FPGA platform\*\* and the \*\*Xilinx ISE CAD environment\*\*. The objective of the project was to design and implement a complete real-time VGA video system capable of generating and controlling graphical output directly from FPGA hardware logic. The final implementation resulted in a fully functional two-player Ping Pong video game rendered entirely through custom VHDL logic.



The project focused on understanding and implementing the functionality of a video-output subsystem and the VGA standard, including synchronization timing, pixel generation, frame rendering, and real-time graphical processing. The design required generating a stable 640×480 VGA signal operating at approximately 60 Hz using a 25 MHz pixel clock derived from the onboard 50 MHz FPGA clock source.



Unlike software-rendered graphics systems, every visual element in this project was generated directly in hardware using synchronous digital logic. Every pixel displayed on the monitor was calculated and driven in real time through FPGA processes responsible for synchronization, rendering, collision handling, and object movement.



\---



\# Project Objectives



The primary objectives of this project were:



\* Learn the operation and timing requirements of the VGA video standard.

\* Implement horizontal synchronization (HSync) and vertical synchronization (VSync) signals.

\* Generate a stable 640×480 display operating at 60 frames per second.

\* Design a real-time graphics subsystem entirely in VHDL.

\* Implement static and dynamic graphical objects using FPGA hardware logic.

\* Develop a fully functional Ping Pong game with collision detection and object movement.

\* Gain practical experience using the Xilinx Spartan-3E FPGA development environment.

\* Understand real-time digital systems where strict timing and synchronization constraints are required.



\---



\# VGA Video System Implementation



The VGA subsystem was implemented from the ground up using custom VHDL processes. The display system follows the standard VGA timing requirements for a 640×480 resolution at approximately 59.52 Hz.



The FPGA outputs RGB signals together with synchronization pulses to continuously refresh the display. The implementation required precise control over pixel timing and screen synchronization to ensure stable image generation.



\## VGA Timing Specifications



\### Horizontal Timing



Each horizontal line consists of 800 clock cycles:



\* 640 visible pixel clock cycles

\* 16 clock cycles for Front Porch

\* 96 clock cycles for Sync Pulse

\* 48 clock cycles for Back Porch



The HSync signal marks the end of a horizontal line and synchronizes the monitor before the next line begins.



\### Vertical Timing



Each frame consists of:



\* 480 visible rows

\* 10 Front Porch rows

\* 2 Sync Pulse rows

\* 33 Back Porch rows



The VSync signal informs the monitor when a frame has completed and prepares the display for rendering the next frame.



The implementation strictly followed VGA timing standards to avoid display instability, image distortion, or synchronization errors.



\---



\# Game Design



The final application implemented was a two-player Ping Pong game consisting of both static and dynamic graphical elements.



\## Static Elements



The static game environment includes:



\* Green background

\* White concrete border walls surrounding the screen

\* Openings on the left and right sides of the frame



These walls form the boundaries of the game arena while allowing scoring regions for both players.



\## Dynamic Elements



Three major dynamic elements were implemented:



\### Player 1 Paddle



A vertically moving paddle positioned on the left side of the screen used to defend the left opening.



\### Player 2 Paddle



A vertically moving paddle positioned on the right side of the screen used to defend the right opening.



\### Ball Object



A yellow moving rectangular ball that continuously travels throughout the screen while interacting with both paddles and walls.



The game logic includes:



\* Ball trajectory calculations

\* Paddle collision detection

\* Wall collision detection

\* Ball reflection at 90-degree angles

\* Ball reset behavior after entering scoring openings

\* Dynamic respawn trajectories

\* Real-time position updates synchronized to the VGA timing system



When the ball enters one of the openings, the ball changes color to red, resets to the center of the screen, and launches again with a predefined trajectory depending on the side that was scored on.



\---



\# Hardware Architecture



The system architecture was divided into multiple VHDL processes working together synchronously.



\## Process Overview



\### Process 1 – Clock Divider



The onboard 50 MHz FPGA clock was divided into a 25 MHz clock used for VGA pixel timing.



\### Process 2 – Horizontal and Vertical Counters



Responsible for tracking pixel positions across the screen by counting horizontal columns and vertical rows.



\### Process 3 – Horizontal Synchronization



Generated the HSync pulse used by the monitor to determine the end of each horizontal scan line.



\### Process 4 – Vertical Synchronization



Generated the VSync pulse used to signal the completion of a frame.



\### Process 5 – Video Enable Logic



Generated the VideoOn signal to determine whether RGB data should be transmitted during visible display regions.



\### Process 6 – Pixel Rendering Engine



Generated RGB values for every visible pixel on the screen.



This process was responsible for rendering:



\* Background colors

\* Border walls

\* Paddles

\* Ball object

\* Collision visuals



\### Process 7 – Ball Position Logic



Calculated ball movement, trajectory updates, and collision responses.



\### Process 8 – Paddle Control Logic



Calculated paddle movement and updated player positions in real time.



\---



\# Real-Time System Design



One of the major challenges of this project was maintaining strict real-time timing constraints.



The system continuously updated and rendered approximately 300,000 pixels nearly 60 times per second while simultaneously:



\* Generating synchronization signals

\* Calculating object positions

\* Detecting collisions

\* Updating trajectories

\* Driving RGB outputs



Because VGA systems operate with extremely strict timing requirements, even small timing mismatches could result in unstable video output or distorted graphics. This project emphasized precise synchronous digital design and deterministic hardware behavior.



\---



\# Collision Detection and Game Physics



The collision system was implemented entirely in hardware logic.



The ball dynamically interacts with:



\* Top and bottom walls

\* Left and right concrete borders

\* Both player paddles



Whenever a collision occurs:



\* The ball trajectory changes direction

\* Motion vectors are updated

\* Real-time rendering immediately reflects the new position



The collision system ensures that the ball reflects at 90-degree angles relative to the impacted surface, reproducing the expected Ping Pong behavior.



\---



\# Results and Validation



The final implementation successfully met all project specifications.



\## Functional Verification



The VGA timing signals were verified using ChipScope waveform analysis. The timing diagrams confirmed proper HSync and VSync generation according to VGA standards.



The captured waveforms demonstrated:



\* Correct synchronization pulse generation

\* Proper horizontal timing intervals

\* Stable frame timing

\* Correct operation at 25 MHz pixel clock frequency



\## Visual Verification



The final game output displayed:



\* Stable VGA rendering

\* Proper synchronization

\* Correct object movement

\* Functional collision handling

\* Dynamic paddle movement

\* Real-time gameplay

\* Accurate color rendering



The implementation produced a smooth and responsive real-time game operating entirely on FPGA hardware.



\---



\# Technical Skills Demonstrated



This project demonstrates practical experience in:



\* FPGA Design

\* VHDL Hardware Description Language

\* VGA Video Signal Generation

\* Real-Time Digital Systems

\* Synchronous Digital Logic

\* Finite State and Process-Based Design

\* Hardware Timing Analysis

\* Collision Detection Logic

\* Embedded Graphics Systems

\* Hardware-Level Game Development

\* Xilinx Spartan-3E FPGA Development

\* Xilinx ISE CAD Tools

\* Digital Signal Timing and Synchronization



\---



\# Key Engineering Concepts Applied



Throughout the project, several important digital systems engineering concepts were implemented and validated:



\* Pixel-level graphics generation

\* Real-time hardware rendering

\* FPGA clock management

\* Frame synchronization

\* Hardware process coordination

\* Video timing standards

\* RGB signal generation

\* Hardware state/process management

\* Deterministic real-time execution

\* Low-level display interfacing



The project required combining hardware timing theory with practical FPGA implementation to achieve stable video output and responsive gameplay.



\---



\# Conclusion



This project successfully implemented a fully functional FPGA-based Ping Pong video game using custom VGA controller logic written entirely in VHDL. The final system achieved stable real-time graphics rendering at 640×480 resolution while maintaining correct VGA synchronization timing.



The project provided extensive experience in digital systems engineering, real-time hardware design, FPGA development, and low-level graphics generation. All required specifications were successfully implemented, including dynamic object rendering, paddle control, collision handling, synchronization timing, and real-time video output.



The resulting system demonstrates how complex interactive graphical systems can be implemented directly in hardware using synchronous digital logic without relying on software-based graphics processing.



\---



\# Technologies Used



\* VHDL

\* Xilinx ISE Design Suite

\* Xilinx Spartan-3E FPGA

\* VGA Video Standard

\* ChipScope Logic Analyzer

\* Digital Logic Design

\* Real-Time Hardware Systems



\---



\# Authors



Developed for:



\*\*COE 758 – Digital Systems Engineering\*\*

Toronto Metropolitan University

Fall 2025



Contributors:



\* Ahmad Hafian

\* Hasib Bhuiyan



