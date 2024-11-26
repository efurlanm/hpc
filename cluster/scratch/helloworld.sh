#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=mycluster

cd $SLURM_SUBMIT_DIR

echo "Hello, World!" > helloworld.txt
echo "OK."
