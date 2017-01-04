function i = findstrline(matstr,str)
% FINDSTRLINE returns indexes of lines of 'matstr' which contain 'str' 
%
%  Usage: i = findstrline(matstr,str)
%
% Paul Robbins 1996

i = [];
for j = 1:size(matstr,1);
  if any(findstr(matstr(j,:),str))
    i = [i j];
  end
end
