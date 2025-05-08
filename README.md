# MD-Free Energy Calculations
"A Tutorial on Molecular Dynamics and Free Energy Calculations for Membrane Protein–Peptide Complexes"
# 🧬 Tutorial: Molecular Dynamics and Free Energy Calculations for Membrane Protein–Peptide Complexes

This repository provides a step-by-step protocol for performing molecular dynamics (MD) simulations and binding free energy calculations of membrane protein–peptide systems using the AMBER software suite.

## 🧪 System Setup

- **Membrane protein orientation** is obtained from the [OPM database](https://opm.phar.umich.edu), which provides experimentally-informed transmembrane positioning for accurate embedding in lipid bilayers.
- **Lipid bilayer construction** is carried out using the [PACKMOL-Memgen](https://ambermd.org/tutorials/advanced/tutorial20/) tool, enabling automatic membrane insertion and system solvation.
- The **AMBER Lipid21 force field** is employed to model lipid molecules, ensuring high compatibility with the AMBER force fields used for proteins and peptides.
- The overall system preparation and simulation protocol is based on:  
  [https://github.com/callumjd/AMBERMembrane_protein_tutorial/](https://github.com/callumjd/AMBERMembrane_protein_tutorial/)

## ⚙️ Simulation Protocol

Production MD runs are conducted using the PMEMD module with GPU acceleration. Standard equilibration and production steps are adapted for membrane environments, with attention to semi-isotropic pressure coupling and appropriate treatment of membrane-protein interactions.

## 🔬 Free Energy Calculations (ASGBIE Method)

Binding free energy is estimated using the **ASGBIE method** (Alanine Scanning Generalized Born with Interaction Entropy), which combines:

- **MM/GBSA calculations** for estimating binding energies from MD snapshots  
- **Alanine scanning mutagenesis** to probe key residue contributions  
- **Interaction entropy** to account for entropic contributions from side-chain flexibility, improving accuracy over traditional end-point methods  

This method offers a balance between computational efficiency and biophysical interpretability, making it suitable for evaluating peptide binding hotspots in complex membrane environments.

# 🔬Getting Started

This tutorial guides you through setting up and simulating membrane protein–peptide systems using AMBER, with an emphasis on binding free energy calculations via the ASGBIE method.

---

## Requirements

### Software
- [AMBER](https://ambermd.org/) (tested with Amber20 or later)
- [PACKMOL-Memgen](https://ambermd.org/tutorials/advanced/tutorial20/)
- Amber20
- Rosetta2017
- Python3

### External Resources
- [OPM Database](https://opm.phar.umich.edu) — to obtain membrane-embedded protein orientations
- [AMBER Membrane Protein Tutorial](https://github.com/callumjd/AMBERMembrane_protein_tutorial/) — used for setup references

---

## Example Workflow

### Step 1: Initial System Construction
Run `1run_leap0.sh` to:
- Load the protein-peptide complex (`complex.pdb`)
- Add disulfide bonds manually
- Generate `com.pdb`, `com.prmtop`, and `com.inpcrd`

### Step 2: Membrane Embedding
Run `2add_mem.sh` to:
- Launch PACKMOL-Memgen with POPC:CHL1 lipid ratio 9:1
- Output `bilayer_com.pdb`

### Step 3: Post-Processing and Box Setup
Run `3gpu_pre.sh` to:
- Insert TER cards for peptide/protein chain separation
- Rebuild the system using Lipid21 and ff15ipq force fields
- Prepare full equilibration and production input files
- Submit minimization, heating, and production MD jobs via `gpu.sh`

### Step 4: Launch Production Simulations
Run `4gpu_9.sh` to:
- Automatically submit all GPU jobs in directories matching `mut_*`

### Step 5: ASGBIE Free Energy Calculations
Run `5asgbie_9.sh` to:
- Extract peptide and protein coordinates from `sol_com.pdb`
- Copy and execute the ASGBIE workflow  
- Alternatively, use `5asgbie_9_test.sh` for test versions

### Step 6: Result Collection
Run `6result_asgbie.sh` to:
- Collect final ASGB and ASIE values from each mutant folder
- Merge results into `ASGBIE.dat`

### Step 7: RMSD Analysis
Run `7rmsd.sh` to:
- Collect all `*.dat` files
- Generate RMSD plots with `RMSD.py`

---

## ASGBIE Method Overview

**ASGBIE** (Alanine Scanning Generalized Born with Interaction Entropy) combines:
- MM/GBSA end-point energy analysis  
- In silico alanine scanning to assess residue contributions  
- Interaction entropy to improve entropic term estimation  

This hybrid method is both computationally tractable and more accurate than traditional MM/GBSA, especially for protein–peptide interfaces.


### External Resources
- [OPM Database](https://opm.phar.umich.edu) — to obtain membrane-embedded protein orientations
- [AMBER Membrane Protein Tutorial](https://github.com/callumjd/AMBERMembrane_protein_tutorial/) — used for setup references

---

## Example Workflow

### Step 1: Initial System Construction
Run `1run_leap0.sh` to:
- Load the protein-peptide complex (`complex.pdb`)
- Add disulfide bonds manually
- Generate `com.pdb`, `com.prmtop`, and `com.inpcrd`

### Step 2: Membrane Embedding
Run `2add_mem.sh` to:
- Launch PACKMOL-Memgen with POPC:CHL1 lipid ratio 9:1
- Output `bilayer_com.pdb`

### Step 3: Post-Processing and Box Setup
Run `3gpu_pre.sh` to:
- Insert TER cards for peptide/protein chain separation
- Rebuild the system using Lipid21 and ff15ipq force fields
- Prepare full equilibration and production input files
- Submit minimization, heating, and production MD jobs via `gpu.sh`

### Step 4: Launch Production Simulations
Run `4gpu_9.sh` to:
- Automatically submit all GPU jobs in directories matching `mut_*`

### Step 5: ASGBIE Free Energy Calculations
Run `5asgbie_9.sh` to:
- Extract peptide and protein coordinates from `sol_com.pdb`
- Copy and execute the ASGBIE workflow  
- Alternatively, use `5asgbie_9_test.sh` for test versions

### Step 6: Result Collection
Run `6result_asgbie.sh` to:
- Collect final ASGB and ASIE values from each mutant folder
- Merge results into `ASGBIE.dat`

### Step 7: RMSD Analysis
Run `7rmsd.sh` to:
- Collect all `*.dat` files
- Generate RMSD plots with `RMSD.py`

---

## ASGBIE Method Overview

**ASGBIE** (Alanine Scanning Generalized Born with Interaction Entropy) combines:
- MM/GBSA end-point energy analysis  
- In silico alanine scanning to assess residue contributions  
- Interaction entropy to improve entropic term estimation  

This hybrid method is both computationally tractable and more accurate than traditional MM/GBSA, especially for protein–peptide interfaces.

---
