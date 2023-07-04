GIA-summerschool excercises
========

Copyright 2023, Torsten Albrecht (PIK), albrecht@pik-potsdam.de

This repository contains jupter notebooks for the excercises on numerical ice sheet modeling. They have been used for the [International GIA Summer School in Gävle, Sweden 2023](https://polenet.org/2023-gia-training-school/).



In Terminal (bash):

```
git clone https://github.com/talbrecht/gia-summerschool.git
 
cd gia-summerschool/

(conda create --name <env> jupyter netcdf4 scipy matplotlib numpy)

conda activate <env>

jupyter notebook --no-browser --port=9427 
```

go to browser: http://localhost:9427/
