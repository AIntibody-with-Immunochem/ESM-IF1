#!/bin/bash
#SBATCH --job-name=ESMIF1         # short name for your job
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=56G        # memory per cpu-core 
#SBATCH --time=05:00:00          # total run time limit (HH:MM:SS)
#SBATCH --gres=gpu:A100:1        # number of GPUs per node
#SBATCH --partition=gpu          # requested partition
#SBATCH --account=p_2024001_hpccom_immunochem     # billing account

# ------------------------------------------------------------------------------
# Print some info
# ------------------------------------------------------------------------------
echo "job_id             : $SLURM_JOB_ID"
echo "jobname            : $SLURM_JOB_NAME"
echo "number of mpi tasks: $SLURM_NTASKS tasks"
echo "OMP_NUM_THREADS    : $OMP_NUM_THREADS"

# ------------------------------------------------------------------------------
# Activate Conda Environment
# ------------------------------------------------------------------------------
module load devel/python/Anaconda3-2022.05  # Load Anaconda if required
source $(conda info --base)/etc/profile.d/conda.sh  # Ensure `conda activate` works

# Activate your struct-evo Conda environment
conda activate /gpfs/home/immunochem/garmstro/.conda/envs/struct-evo

# **Force the Job to Use the Conda Python**
export PATH=/gpfs/home/immunochem/garmstro/.conda/envs/struct-evo/bin:$PATH
export CONDA_PREFIX=/gpfs/home/immunochem/garmstro/.conda/envs/struct-evo
export CONDA_DEFAULT_ENV=struct-evo
export PYTHONNOUSERSITE=1  # Prevent interference from user-wide packages

# Verify Python Path to ensure Conda's Python is used
echo "Using Python from: $(which python)"
python --version

# ------------------------------------------------------------------------------
# Run the ESM-IF1 recommendation
# ------------------------------------------------------------------------------
# Go to the ESM-IF1 directory (adjust the directory if needed)
cd /gpfs/home/immunochem/garmstro/ESM-IF1

# Start the recommendation
pwd
date
echo "Starting ESM-IF1 recommendation..."

python bin/recommend.py inputs/4KRL.pdb --chain B
wait
echo "Recommendation complete"
date
