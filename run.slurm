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
#SBATCH -J mystream           # Job name
#SBATCH -o output/mystream.o%j       # Name of stdout output file
#SBATCH -e output/mystream.e%j       # Name of stderr error file
#SBATCH -p development            # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for serial)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 00:15:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=guliani@wisc.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A Measurement-study-of    # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...
mkdir /tmp/stream
cp $SCRATCH/benchmark/BabelStream/cuda-stream /tmp/stream/.
cp $SCRATCH/benchmark/BabelStream/prof_stream.sh /tmp/stream/.
cd /tmp/stream

module load cuda/10.1

module list
pwd
date

# Launch serial code to specific GPUs...
CUDA_VISIBLE_DEVICES=0 ./prof_stream.sh 0 ${SLURM_JOB_ID}
#CUDA_VISIBLE_DEVICES=1 ./prof_stream.sh 1 ${SLURM_JOB_ID}  
#CUDA_VISIBLE_DEVICES=2 ./prof_stream.sh 2 ${SLURM_JOB_ID}  
#CUDA_VISIBLE_DEVICES=3 ./prof_stream.sh 3 ${SLURM_JOB_ID}  
# wait
cp *.csv $SCRATCH/benchmark/BabelStream/data/.

# ---------------------------------------------------
