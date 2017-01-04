function t= cal2dec(month, day, hour, minute)
% CAL2DEC converts calander day to decimal day
%
%  Usage:  t= cal2dec(month, day, hour,minute)
%
%
% P. Robbins 94
if nargin <3
  hour = 0;
end
if nargin < 4
  minute = 0;
end

months = [0 31 28 31 30 31 30 31 31 30 31 30 31];
cummon = cumsum(months);

if month > 12
%  disp(['bogus month: ',num2str(month)])
  month = 1;
end

if day > 31
%  disp(['bogus day: ',num2str(day)])
  day = 1;
end


t = cummon(month)' + day + hour/24 + minute/24/60;
