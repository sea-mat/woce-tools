function o = ox_units(ox,salt,temp);
% OX_UNITS  converts oxygen from ml/l to micromol/kg
%           using the potential density of water sample
%
%  Usage: o = ox_units(ox,salt,potentialtemp);
%
% Paul Robbins 1995
rho = sw_dens(salt,temp,0);
o = ox*1e3./rho/.022403;

