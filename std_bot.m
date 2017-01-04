function [bot,prop,units]  = std_bot(bot,prop,units)

% STD_BOT converts bottle data to standardized units of micromol/kg
%
%  Usage: [b,p,u]  = std_bot(bot,prop,units)
% 
% Copywrite 1995  Paul E Robbins

% first check label strings for lower case
units = upper(units);
prop = upper(prop);

% check for strings in non standard format
for i = 1:size(units,1)
  if strcmp(units(i,:),'  DBARS')
     units(i,:) = '   DBAR';
  end	
  if strcmp(units(i,:),'  PM/KG')
     units(i,:) = 'PMOL/KG';
  end	
end

itheta = 0; isalt = 0; 
% compute density
for i = 1:size(prop,1)
  if strcmp(prop(i,:),' THETA')
    itheta = i;
  end
  if strcmp(prop(i,:),'SALNTY')
    isalt = i;
  end
end	

if itheta == 0 | isalt == 0
  disp(['Unable to locate Theta and Salt for nutrient conversions'])
else
  % check for units in non-standard units
  for i = 1:size(units,1)
    if strcmp(units(i,:),'   ML/L')
      xx = ox_units(bot(:,i),bot(:,isalt),bot(:,itheta));
      bot(:,i) = xx;
      units(i,:) = 'UMOL/KG';
      disp(['  Converted ',prop(i,:),' from ml/l to umol/kg'])
    end		
    if strcmp(units(i,:),' UMOL/L') | strcmp(units(i,:),'UMOL/L ')
      xx = nut_units(bot(:,i),bot(:,isalt));
      bot(:,i) = xx;
      units(i,:) = 'UMOL/KG';
      disp(['  Converted ',prop(i,:),' from umol/l to umol/kg'])
    end		
  end
end


