#!/bin/bash

# for loop to write qpwave submission script for each populaiton in set
for i in MachuPicchu Peru
	do
	sed "s/TargetPop/$i/g" qpWave.sh > qpWave_${i}.sh
	sbatch qpWave_${i}.sh
done
