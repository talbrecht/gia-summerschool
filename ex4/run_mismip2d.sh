#!/bin/bash

# Copyright (C) 2023 PISM authors
# created by torsten.albrecht@pik-potsdam.de

###############################################################################
# Test simulation of MISMIP2d case 
# in GIA training school
###############################################################################

PISM_PATH=$1
MPIEXEC=$2
PISM_SOURCE_DIR=$3

###############################################################################
# bash run_mismip2d.sh $PISMDIR 
###############################################################################

set -e
set -u
set -x

PISM_PATH=$1
PISM_SOURCE_DIR=${PISM_PATH}

# check out: ${PISM_SOURCE_DIR}/examples/mismip/mismip2d/README.md

export PATH=${PISM_SOURCE_DIR}/share/pism/examples/preprocessing/:$PATH
export PYTHONPATH=${PISM_SOURCE_DIR}/share/pism/examples/preprocessing

# 12km grid
cp ${PISM_SOURCE_DIR}/examples/mismip/mismip2d/run.py prepare_mismip.py

# --- a/examples/mismip/mismip2d/run.py
#+++ b/examples/mismip/mismip2d/run.py
#@@ -104,6 +104,8 @@ class Experiment:
#         "Options corresponding to modeling choices."
#         config_filename = self.config(step)
# 
#+        boot_filename = "MISMIP_boot_%s_M%s_A%s.nc" % (self.experiment, self.mode, 1)
#+
#         options = ["-energy none",  # isothermal setup; allows selecting cold-mode flow laws
#                    "-ssa_flow_law isothermal_glen",  # isothermal setup
#                    "-yield_stress constant",
#@@ -112,7 +114,7 @@ class Experiment:
#                    "-gradient eta",
#                    "-pseudo_plastic_q %e" % MISMIP.m(self.experiment),
#                    "-pseudo_plastic_uthreshold %e" % MISMIP.secpera(),
#-                   "-front_retreat_file %s" % input_file, # prescribe the maximum ice extent
#+                   "-front_retreat_file %s" % boot_filename, # prescribe the maximum ice extent
#                    "-config_override %s" % config_filename,
#                    "-ssa_method fd",
#                    "-cfbc",                # calving front boundary conditions


python prepare_mismip.py -e 3a --mode=1 > experiment-3a-mode-1.sh

bash experiment-3a-mode-1.sh 2 #>& out.3a-mode-1 &

cp ${PISM_SOURCE_DIR}/examples/mismip/mismip2d/plot.py plot_mismip2d.py
cp ${PISM_SOURCE_DIR}/examples/mismip/mismip2d/MISMIP.py ./
python plot_mismip2d.py ABC1_3a_M1_A1.nc

