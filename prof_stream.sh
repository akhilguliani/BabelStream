#! /bin/bash

# USAGE: source prof_sgemm.sh <Target GPU Num>

# UUID=`cat /proc/driver/nvidia/gpus/*/information | grep UUID | tr ':\t' $'\n'| grep -`; echo $UUID
export export CUDA_DEVICE_ORDER=PCI_BUS_ID

UUID_list=(`nvidia-smi -L | awk '{print $NF}' | tr -d '[)]'`)
UUID=${UUID_list[${1}]}
echo $UUID
ts=`date '+%s'`

for i in 10
	do 
	# for size in 16777216 33554432 67108864 134217728 268435456 536870912 
	for size in 536870912 
	do
	echo sgemm_${size}_${i}_${UUID}_${1}_${ts}.csv 
	# touch sgemm_${size}_${i}_${UUID}_${1}.csv 
	__PREFETCH=off nvprof --print-gpu-trace --event-collection-mode continuous --system-profiling on --kernel-latency-timestamps on --csv --log-file streamTriad_${size}_${i}_${UUID}_${HOSTNAME}_${2}_${ts}.csv --device-buffer-size 128 --continuous-sampling-interval 1 -f ./cuda-stream --triad-only -s ${size} -n ${i} --device 0
	#__PREFETCH=off nvprof --print-gpu-trace --event-collection-mode continuous --system-profiling on --kernel-latency-timestamps on --csv --log-file stream_${size}_${i}_${UUID}_${HOSTNAME}_${2}_${ts}.csv --device-buffer-size 128 --continuous-sampling-interval 1 -f ./cuda-stream -s ${size} -n ${i} --device 0
	done
done
