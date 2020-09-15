#! /bin/bash

# USAGE: source prof_sgemm.sh <Target GPU Num>

# UUID=`cat /proc/driver/nvidia/gpus/*/information | grep UUID | tr ':\t' $'\n'| grep -`; echo $UUID
export export CUDA_DEVICE_ORDER=PCI_BUS_ID

UUID_list=(`nvidia-smi -L | awk '{print $NF}' | tr -d '[)]'`)
UUID=${UUID_list[${1}]}
echo $UUID
ts=`date '+%s'`

for i in 1000
	do 
	# for size in 16464 16632 16800 16968 17136 17304 17472 17640 17808 17976 18144 18312 18480 18648 18816 18984 19152 19320 19488 19656 19824 19992 20160 20328 20496 20664 20832 21000 21168 21336 21504 21672 21840 22008 22176 22344 22512 22680 22848 23016 23184 23352 23520 23688 23856 24024 24192 24360 24528 24696 24864 25032 25200 25368 25536 25704 25872 26040 26208 26376 26544 26712 26880 27048 27216 27384 27552 27720 27888 28056 28224 28392 28560 28728 28896 29064 29232 29400 29568 29736 29904 30072 30240 30408 30576 30744 30912 31080 31248 31416 31584 31752 31920 32088 32256 32424 32592 32760   
	# for size in 8192 16384 24000 28000 32760 32704 32768
	# for size in 21504 23520 25536 26880 27552 32256 
	for size in 629145600 
	do
	echo sgemm_${size}_${i}_${UUID}_${1}_${ts}.csv 
	# touch sgemm_${size}_${i}_${UUID}_${1}.csv 
	__PREFETCH=off nvprof --print-gpu-trace --event-collection-mode continuous --system-profiling on --kernel-latency-timestamps on --csv --log-file streamTriad_${size}_${i}_${UUID}_${HOSTNAME}_${2}_${ts}.csv --device-buffer-size 128 --continuous-sampling-interval 1 -f ./cuda-stream --triad-only -s ${size} -n ${i} --device 0
	#__PREFETCH=off nvprof --print-gpu-trace --event-collection-mode continuous --system-profiling on --kernel-latency-timestamps on --csv --log-file stream_${size}_${i}_${UUID}_${HOSTNAME}_${2}_${ts}.csv --device-buffer-size 128 --continuous-sampling-interval 1 -f ./cuda-stream -s ${size} -n ${i} --device 0
	done
done
