#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Longhorn v100 nodes
#
#   *** Multiple Serial Jobs in v100 Queue ***
#
# Notes:
#
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch sample.slurm" on a Longhorn login node.
#
#   -- Serial codes run on a single node (upper case N = 1).
#        A serial code ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#----------------------------------------------------
#SBATCH -J BigProfile           # Job name
#SBATCH -o profile-out/streamProfile.o%j       # Name of stdout output file
#SBATCH -e profile-out/streamError.e%j       # Name of stderr error file
#SBATCH -p v100-lm            # Queue (partition) name
#SBATCH -N 8               # Total # of nodes (must be 1 for serial)
#SBATCH -n 8               # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 00:15:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=guliani@wisc.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A Measurement-study-of    # Allocation name (req'd if you have more than 1)

# Setup to launch jobs at scale

# Get list of nodes allocated
scontrol show hostnames $SLURM_NODELIST > /tmp/hostfile

cat /tmp/hostfile

# Launch run script on each node
mpiexec -hostfile /tmp/hostfile -N 1 ./run.sh
