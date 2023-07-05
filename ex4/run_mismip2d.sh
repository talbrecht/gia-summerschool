#!/bin/bash

# Copyright (C) 2023 PISM authors
# created by torsten.albrecht@pik-potsdam.de

###############################################################################
# Test simulation of MISMIP2d case 
# in GIA training school
# check https://github.com/pism/pism/tree/dev/examples/mismip/mismip2d
###############################################################################

PISM_PATH=$1

###############################################################################
# bash run_mismip2d.sh $PISMDIR 
###############################################################################


set -e
set -u
set -x

PISM_PATH=$1

export PATH=${PISM_PATH}/share/pism/examples/preprocessing/:$PATH
export PYTHONPATH=${PISM_PATH}/share/pism/examples/preprocessing

# prepare 12km grid MISMIP setting
cp ${PISM_PATH}/examples/mismip/mismip2d/run.py prepare_mismip.py
python prepare_mismip.py -e 3a --mode=1 > experiment-3a-mode-1.sh

# run first experiment
bash experiment-3a-mode-1.sh 2 #>& out.3a-mode-1 &

# plot first result (or add to PATH variable)
cp ${PISM_PATH}/examples/mismip/mismip2d/plot.py plot_mismip2d.py
cp ${PISM_PATH}/examples/mismip/mismip2d/MISMIP.py ./
python plot_mismip2d.py ABC1_3a_M1_A1.nc


# if you want to run more experiments, you may insert a line in to prepare_mismip.py

#@@ -104,6 +104,8 @@ class Experiment:
# 
#+        boot_filename = "MISMIP_boot_%s_M%s_A%s.nc" % (self.experiment, self.mode, 1)
#+
#         options = ["-energy none",  # isothermal setup; allows selecting cold-mode flow laws

#@@ -112,7 +114,7 @@ class Experiment:
#-                   "-front_retreat_file %s" % input_file, # prescribe the maximum ice extent
#+                   "-front_retreat_file %s" % boot_filename, # prescribe the maximum ice extent


