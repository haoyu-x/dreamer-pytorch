#!/bin/bash -l

# The command to run on SSC is qsub -t 1-20 dmc.sh ,
# if you want to run all the evironments in parrallel.
# In case you just want to run the second environment,
# the command should change to qsub -t 2 dmc.sh

# Specify hard time limit for the job.
#   The job will be aborted if it runs longer than this time.
#   The default time is 12 hours
#$ -l h_rt=48:00:00

# Send an email when the job finishes or if it is aborted (by default no email $
#$ -m bea

#$ -M juliusf@bu.edu

# Give job a name
#$ -N dreamer

# memory per core
#$ -l mem_per_core=8G

# Request 8 CPUs
#$ -pe omp 8

# Request 1 GPU (the number of GPUs needed should be divided by the number of C$
#$ -l gpus=0.125

# Specify the minimum GPU compute capability
# Run on V100:
#$ -l gpu_c=7

# Combine output and error files into a single file
#$ -j y

# Specify the output file name
#$ -o dreamer-dmc.qlog

# Submit an array job with 20 tasks
# -t 1-20

# Use the SGE_TASK_ID environment variable to select the appropriate input file from bash array
# Bash array index starts from 0, so we need to subtract one from SGE_TASK_ID value
inputs=(acrobot_swingup cartpole_balance cartpole_balance_sparse cartpole_swingup cartpole_swingup_sparse cheetah_run cup_catch finger_spin finger_turn_easy finger_turn_hard hopper_hop hopper_stand pendulum_swingup quadruped_run quadruped_walk reacher_easy reacher_hard walker_run walker_stand walker_walk)
index=$(($SGE_TASK_ID-1))
taskinput=${inputs[$index]}

# Keep track of information related to the current job
echo "=========================================================="
echo "Start date : $(date)"
echo "Job name : $JOB_NAME"
echo "Job ID : $JOB_ID  $SGE_TASK_ID"
echo "=========================================================="

module load cuda/10.1
module load python3/3.6.9
module load pytorch/1.3

logdir="./data/dmc/$taskinput"

cd /projectnb/saenkog/juliusf/dreamer-pytorch/

python3 main_dmc.py --log-dir $logdir --cuda-idx 0 --game $taskinput

