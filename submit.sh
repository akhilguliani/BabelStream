#! /bin/bash
for i in {0..15}
do
echo submitting job $i
sbatch run.slurm
#sbatch dcgmi.slurm

done
