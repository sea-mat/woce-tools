function [p,t,s,o2,lat,lon] = read_prs(flname,dd);

%   READ_PRS Reads in standard *.PRS ascii file specified by flname
%
%   Usage:  [p,t,s,o2,lat,lon] = read_prs(flname,decimation); 
%
% Output : (column vectors)
%   p : pressure 
%   t : (in situ) temperature
%   s : salinity 
%   ox: oxygen
%   lat: latitude
%   lon: longitude
%  
%  INPUT
%    flname: file name (may include path)
%    (opt) decimation: specify decimation interval (e.g. 20 for 20 dbar)
%
% Paul E. Robbins copywrite 1995

l = length(flname);
if ~strcmp(flname(l-3:l),'prs') & ~strcmp(flname(l-1:l),'PRS');
   flname = [flname,'.prs'];
end
fid = fopen(flname,'r');

if fid == -1
  %try to find file in matlab_data directory
  fid = fopen([getenv('MATLAB_DATA'),flname],'r');
  if fid == -1
    fid = fopen([getenv('MATLAB_DATA'),'/ctd/prs/',flname],'r');
    if fid == -1
      disp(['File ',flname,' not found'])
      break
   end
  end	
end

% read in 5 lines of header data
for l = 1:5
  line = fgetl(fid);  
end

% read in lat and longitude
lats = fscanf(fid,' St.Lat.:%d:%d:%d',3); fgetl(fid);
if lats(1) > 0
  lat  = lats(1) + lats(2)/60 + lats(3)/3600;
else 
  lat  = lats(1) - lats(2)/60 - lats(3)/3600;
end

lons = fscanf(fid,' St.Long:%d:%d:%d',3); fgetl(fid);
if lons(1) > 0
  lon  = lons(1) + lons(2)/60 + lons(3)/3600;
else 
  lon  = lons(1) - lons(2)/60 - lons(3)/3600;
end

% read in 8 more lines of header data
for l = 1:8
  line = fgetl(fid);  
end


dat = fscanf(fid,'%f,%f,%f,%f,%f',[5 inf]);

p = dat(1,:);
t = dat(2,:);
s = dat(3,:);
o2 = dat(4,:);
fclose(fid);

if nargin > 1  % decimate data
  l = length(p);
  dp = diff(p(1:2));
  step = round(dd/dp);
  p = p(1:step:l);
  s = s(1:step:l);
  t = t(1:step:l);
  o2 = o2(1:step:l);
end

p = p(:); t = t(:); s = s(:); o2 = o2(:);

