#!/bin/bash

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
CUDA_VISIBLE_DEVICES=1 ./prof_stream.sh 1 ${SLURM_JOB_ID}  
CUDA_VISIBLE_DEVICES=2 ./prof_stream.sh 2 ${SLURM_JOB_ID}  
CUDA_VISIBLE_DEVICES=3 ./prof_stream.sh 3 ${SLURM_JOB_ID}  
wait
cp *.csv $SCRATCH/benchmark/BabelStream/data-new/.

# ---------------------------------------------------
