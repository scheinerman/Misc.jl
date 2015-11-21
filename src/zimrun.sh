#!/bin/bash -l

# run this script with "sbatch zimrun.sh"

#SBATCH
#SBATCH --job-name=Zimmer
#SBATCH --time=10
#SBATCH --partition=parallel
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=24


time julia -p 40 zimmertest.jl > zim.out
