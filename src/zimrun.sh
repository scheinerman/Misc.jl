#!/bin/bash -l

# run this script with "sbatch zimrun.sh"

#SBATCH
#SBATCH --job-name=Zimmer
#SBATCH --time=10
#SBATCH --partition=parallel
#SBATCH --nodes=5
#SBATCH --ntasks-per-node=24


time julia -p 100 zimmertest.jl > zim.out 2> errors.out
