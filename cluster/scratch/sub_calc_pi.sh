#!/bin/bash
#SBATCH --ntasks=8
#SBATCH --nodelist=node02

cd $SLURM_SUBMIT_DIR

mpiexec -n $SLURM_NTASKS python3 calc-pi.py
