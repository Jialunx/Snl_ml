# ML integration scheme

WW3_ml_integration_scheme.m is a matlab file to load ML model in python files and run inside WW3 using run-test-generic1.sh.

The file W3snl1md.F90 in ww3_ts1_test in WW3_ml is modified, the DIA output is replaced with the output from ML model in python files (snl.py) at each integration step. 

ML_models.ipynb is for training the ML models
