#!/bin/bash -l

# The command to run on SSC is qsub -t 1-3 script.sh , if you want to run all the evironments in parrallel. In case you just want to run the second environment, the command should change to qsub -t 2 script.sh 

# Specify hard time limit for the job.
#   The job will be aborted if it runs longer than this time.
#   The default time is 12 hours
#$ -l h_rt=48:00:00

# Send an email when the job finishes or if it is aborted (by default no email $
#$ -m bea

#$ -M kasra0gh@bu.edu

# Give job a name
#$ -N dreamer

# memory per core
# -l mem_per_core=12G

# Request 4 CPUs
#$ -pe omp 4

# Request 1 GPU (the number of GPUs needed should be divided by the number of C$
#$ -l gpus=0.25

# Specify the minimum GPU compute capability
#$ -l gpu_c=3.5

# Combine output and error files into a single file
#$ -j y

# Specify the output file name
# -o example.qlog

# Submit an array job with 3 tasks 
# -t 1-3

# Use the SGE_TASK_ID environment variable to select the appropriate input file from bash array
# Bash array index starts from 0, so we need to subtract one from SGE_TASK_ID value
inputs=(pong alien assault)
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

pip install -r requirements.txt

python3 main.py --log-dir "./logdir/dreamer/$taskinput" --cuda-idx 0 --game $taskinput

