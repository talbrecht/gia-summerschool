#!/bin/bash

# Copyright (C) 2023 PISM authors
# created by torsten.albrecht@pik-potsdam.de

###############################################################################
# Test simulation of Antarctic ice sheet model 
# in GIA training school
###############################################################################

PISM_PATH=$1
MPIEXEC=$2
PISM_SOURCE_DIR=$3

###############################################################################
# bash run_antarctica.sh $PISMDIR 
###############################################################################

set -e
set -u
set -x

PISM_PATH=$1
PISM_SOURCE_DIR=${PISM_PATH}

input_file=${PISM_SOURCE_DIR}/test/regression/pico_split/bedmap2_schmidtko14_50km.nc

#temp_dir=$(mktemp -d -t pism_ant_pico_lc.XXXX) || exit 1
temp_dir=results
mkdir -p ${temp_dir}

cp $input_file ${temp_dir}/input_01.nc

#pushd ${temp_dir}

cat > script.txt <<EOF
mask=basins * 0;
mask@units="";
mask@flag_values="0, 2, 3, 4";
mask@long_name="ice-type (ice-free/grounded/floating/ocean) integer mask";
mask@pism_intent="diagnostic";

where(thk >  topg / (-910.0 / 1028.0)) mask=2;
where(thk <= topg / (-910.0 / 1028.0)) mask=3;
where(thk == 0 && topg < 0) mask=4;
EOF

ncap2 -S script.txt -O ${temp_dir}/input_01.nc ${temp_dir}/input_01.nc

# 50km
grid="-bootstrap -Mx 120 -My 120 -Lz 6000 -Lbz 2000 -Mz 81 -Mbz 21"

stressbalance="-pik -stress_balance ssa+sia -ssa_method fd"
pico="-ocean pico -ocean_pico_file $input_file -gamma_T 1.0e-5 -overturning_coeff 0.8e6 -exclude_icerises -continental_shelf_depth -2500"
surface="-atmosphere uniform -surface simple"   #"-surface pik"
earth="-bed_def none" #lc


mpiexec -n 2  ${PISM_PATH}/bin/pismr -verbose 2 -i ${temp_dir}/input_01.nc \
              -config ${PISM_PATH}/share/pism/pism_config.nc \
              $grid \
              $stressbalance \
              $surface \
              $pico \
              $earth \
              -y 10 \
              -ts_file ${temp_dir}/ts_01.nc -ts_times 0:yearly:100 \
              -o ${temp_dir}/o_01.nc | tee ${temp_dir}/output_01.log


