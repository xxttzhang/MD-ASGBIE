# 📌 Example Workflow

## Step 1: Initial System Construction
Run `1run_leap0.sh` to:
- Load the protein-peptide complex (`complex.pdb`)
- Add disulfide bonds manually
- Generate `com.pdb`, `com.prmtop`, and `com.inpcrd`

## Step 2: Membrane Embedding
Run `2add_mem.sh` to:
- Launch PACKMOL-Memgen with POPC:CHL1 lipid ratio 9:1
- Output `bilayer_com.pdb`

## Step 3: Post-Processing and Box Setup
Run `3gpu_pre.sh` to:
- Insert TER cards for peptide/protein chain separation
- Rebuild the system using Lipid21 and ff15ipq force fields
- Prepare full equilibration and production input files
- Submit minimization, heating, and production MD jobs via `gpu.sh`

## Step 4: Launch Production Simulations
Run `4gpu_9.sh` to:
- Automatically submit all GPU jobs in directories matching `mut_*`

## Step 5: ASGBIE Free Energy Calculations
Run `5asgbie_9.sh` to:
- Extract peptide and protein coordinates from `sol_com.pdb`
- Copy and execute the ASGBIE workflow  
- Alternatively, use `5asgbie_9_test.sh` for test versions

## Step 6: Result Collection
Run `6result_asgbie.sh` to:
- Collect final ASGB and ASIE values from each mutant folder
- Merge results into `ASGBIE.dat`

## Step 7: RMSD Analysis
Run `7rmsd.sh` to:
- Collect all `*.dat` files
- Generate RMSD plots with `RMSD.py`
