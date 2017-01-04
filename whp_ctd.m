function [p,t,s,o2] = whp_ctd(flname);

% WHP_CTD Reads in standard WOCE ctd ascii file specified by flname
%         Checks the header record and if the temperature is in ITS-90, 
%         if is converted to IPTS-68 before being returned
%
% Usage: [p,t,s,o2] = whp_ctd(flname); 
%
% Output : (column vectors)
%  p : pressure 
%  t : (in situ) temperature
%  s : salinity 
%  ox: oxygen
%  
%
% Paul E. Robbins copyright 1995
fid = fopen(flname,'r');

if fid == -1
   %try to find file in matlab_data directory
  fid = fopen([getenv('MATLAB_DATA'),flname],'r');
  if fid == -1
    fid = fopen([getenv('MATLAB_DATA'),'ctd/woce/',flname],'r');
    if fid == -1;
     disp(['File ',flname,' not found'])
     break
    end
  end	
end

% read in 6 lines of header data
for l = 1:2
  line = fgetl(fid);  disp(line);
end

for l = 3:5
  line = fgetl(fid);  
end
if any(findstr(line,'ITS-90'))
  dotemp = 1;
  disp(['  Converting temperature from ITS-90 to IPTS-68'])
else
  dotemp = 0;
end

line = fgetl(fid); 
% read in data block
dat = fscanf(fid,'%f',[6 inf]);

p = dat(1,:);
t = dat(2,:);
s = dat(3,:);
o2 = dat(4,:);
fclose(fid);

if dotemp
  t = 1.00024*t;
end

p = p(:); t = t(:); s = s(:); o2 = o2(:);
