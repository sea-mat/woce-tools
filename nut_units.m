function n = nut_units(nut,salt);

% NUT_UNITS  Converts nutrient data from micromol/l to micromol/kg
%            using a standard lab temperture of 22 C
%
%  Usage:   n = nut_units(nutrients,salt);
%
%  nutrients: vector of nutrient measurements
%  salt:      vector of salinity measurements (psu)
%
% Paul Robbins 1995
l = length(salt);
rho = sw_dens(salt,22*ones(l,1),zeros(l,1));
n = nut*1000./rho;
