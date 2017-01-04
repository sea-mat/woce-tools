function bt_plt1(botfile,sumfile,stations);

% BT_PLT1  A front end program for bot_gui 
%          which allows user to specify
%          a matching sum file to include geographic information.
%
% USAGE:  bt_plt1(botfile,sumfile,stations);
%
% INPUTS
%   botfile: name of WOCE format bottle file
%   sumfile: name of WOCE format sum file
%   stations (opt):  vector of stations to use
%
% Copywrite 1995  Paul E Robbins

disp(['Loading WHP sum file ',sumfile])
[lat,lon,station,time] = whp_sum(sumfile);

disp(['Loading WHP bottle file ',botfile])
[bot,props,units] = whp_bot(botfile,2);

%find index of station number
js = findstrline(props,'STNNBR');
if nargin > 2

 ok = 0*station;
 for i = 1:length(station)
   if any(station(i) == stations)
     ok(i) = 1;
   end
 end
 lat = lat(ok); lon = lon(ok); station = station(ok); time = time(ok);
 ok = 0*bot(:,1);
 for i = 1:length(stations)
  if any(bot(:,js) == stations(i));
    ok(bot(:,js) == stations(i)) = ok(bot(:,js) == stations(i))+1;
  end
 end
 bot = bot(ok,:);
else
 stations=sort(bot(:,js));stations(find(diff(stations)==0))=[];

end

bad = bot == -9;
bot(bad) = nan*(bot(bad));
disp(['Merging in station info....'])
props = str2mat(props,'LONGIT','LATITU');
units = str2mat(units,' ',' ');
ncol = size(bot,2);
for i = 1:length(stations)
  if any(bot(:,js) == stations(i));
    nmat = sum(bot(:,js) == stations(i));
    bot(bot(:,js) == stations(i),ncol+1) = lon(i)*ones(nmat,1);
    bot(bot(:,js) == stations(i),ncol+2) = lat(i)*ones(nmat,1);
  end
end
    
disp(['Calculating derived variables....'])

%find indexes of salinity and temp
jsalt = findstrline(props,'SALNTY');
jtemp = findstrline(props,'CTDTMP');
jpres = findstrline(props,'CTDPRS');

ncol = size(bot,2);
props = str2mat(props,'SIGMA0');
units = str2mat(units,' KG/M^3');
bot(:,ncol+1) = sw_pden(bot(:,jsalt),bot(:,jtemp),bot(:,jpres),0);

% if you have the gamma-routines for neutral density you can uncomment this
%props = str2mat(props,'GAMMAN');
%units = str2mat(units,' KG/M^3');
%bot(:,ncol+2) = gamma_n(bot(:,jsalt),bot(:,jtemp),bot(:,jpres),...
%    bot(:,ncol-1),bot(:,ncol));

bot_gui(bot,props,units)

