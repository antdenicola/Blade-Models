#!/bin/bash/


rm vscf1.dat
grep -binary vscf1 fort.7 > vscf1.dat

echo "   set title 'VSCF'">> set.gnu
echo "   set xlabel 'steps'" >> set.gnu
echo "   set ylabel 'V-SCF [kJ/mol]'" >> set.gnu

echo "   plot 'vscf1.dat' u 2:3 w lp t 'V-SCF 1'" >> set.gnu
echo "   pause -1 " >> set.gnu

gnuplot  set.gnu
rm set.gnu vscf1.dat


rm temp.dat
grep -binary temp fort.7 > temp.dat

echo "   set title 'TEMPERATURE'">> set.gnu
echo "   set xlabel 'steps'" >> set.gnu
echo "   set ylabel 'Temp. [K]'" >> set.gnu

echo "   plot 'temp.dat' u 2:3 w lp t 'Temp'" >> set.gnu
echo "   pause -1 " >> set.gnu

gnuplot  set.gnu
rm set.gnu temp.dat


