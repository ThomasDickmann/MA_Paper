# An adaptive mechatronic exoskeleton for force-controlled finger rehabilitation
>This repository represents the source code for a novel mechatronic exoskeleton architecture for finger rehabilitation. The system consists of an underactuated kinematic structure that enables the exoskeleton to act as an adaptive finger stimulator. 


 <img src="results\Exo_mech_fein_L12.png" alt="Drawing" style="width: 500px;">


## Setup

* Install Matlab


## What does each file do? 

    .     
    ├── MATLAB_Functions                 # Folder for all functions in 'm' format
    |   |
    │   ├── CSV_Interpretation.m         # calculates diagnostic data from .csv
    │   ├── getActuationAngle.m          # determines the angle phi_1 at point B depending the actor
    │   ├── getActuationForce.m          # calculates the external force of the actuator
    │   ├── getActuationSignal.m         # determines the delta_s position of the actuator from phi_1
    │   ├── getAngle.m                   # finds the angle of a vector (r_i) in the worldframe
    │   ├── getConstParam.m              # calculation of the const parameters depending on the finger
    │   ├── getExtForces.m               # determines the external forces of the exoskeleton
    │   ├── getJointAngles.m             # calculates the finger joint angles from the joint positions
    │   ├── getJointAnglesDeg.m          # in Degrees
    │   ├── getJointAnglesRad.m          # in Rad
    │   ├── getJointTorques.m            # calculates the finger moments for the quasistatic state
    │   ├── getKinConfig.m               # position of all joints of the kinematics from the encoders
    │   ├── getPhalanxForces.m           # rotates the external forces on the phalanges
    │   ├── getPoint.m                   # position of a joint in the world system
    │   ├── plotBR.m                     # plots the range of motion of the index finger
    │   ├── plotBR_alternative.m         # alternative to plotBR.m
    │   └── plotKinConfig.m              # plots the current kinematic position 
    |
    ├── MATLAB_Models                    # Folder for all models in 'm' format 
    |                  
    └── results.txt                      # Folder for all result images

# Citation

If you use this project in any of your work, please cite:

```
tbd.
```