#!/bin/bash

echo 'DENS PROF CALCULATION'

### NORMAL DIRECTION TO THE BILAYER
dir="Z"

tail -n 2939 trj.gro > last.gro
cp ../pre_files/topol.tpr .

echo 'density profile calculation'

echo '3'> opt
gmx density -f trj.gro -s topol.tpr -sl 25 -d $dir -n index.ndx -dens number -b 10000 -o W.xvg < opt

echo '4'> opt
gmx density -f trj.gro -s topol.tpr -sl 25 -d $dir -n index.ndx -dens number -b 10000 -o N.xvg < opt

echo '5'> opt
gmx density -f trj.gro -s topol.tpr -sl 25 -d $dir -n index.ndx -dens number -b 10000 -o P.xvg < opt

echo '6'> opt
gmx density -f trj.gro -s topol.tpr -sl 25 -d $dir -n index.ndx -dens number -b 10000 -o G.xvg < opt

echo '7'> opt
gmx density -f trj.gro -s topol.tpr -sl 25 -d $dir -n index.ndx -dens number -b 10000 -o C.xvg < opt

rm opt

xmgrace W.xvg C.xvg N.xvg P.xvg C.xvg


