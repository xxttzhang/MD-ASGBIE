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
