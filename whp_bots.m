function [b,p,u] = whp_bots(a1,a2,a3,a4,a5,a6,a7,a8,a9);

% WHP_BOTS loads multiple woce *.HY2 and *.SEA files
%
% Usage: [bot,props,units] = whp_bots(fname1,fname2,...., fname9)
%
% merges data using column property titles and units.  If some files have
% extra properties or units don't match then the additional data is appended
% as an additional columns.   Files missing properties have appropriate
% columns padded with nan's
% 
% Currently set to disregard data flagged as 'bad' or 'questionable'
% 
% Paul E Robbins, copywrite 1995

%  needs to call woce_bot.m

[b,p,u] = whp_bot(a1);
[b,p,u] = std_bot(b,p,u);
b = [ones(size(b,1),1) b];
p = str2mat('CRSNUM',p);
u = str2mat('  ',u);

for n = 2:nargin
  bo = b; po = p; uo = u;  
  eval(['fname = a',num2str(n),';'])
  [bn,pn,un] = whp_bot(fname,3);
  [bn,pn,un] = std_bot(bn,pn,un);

  bn = [n*ones(size(bn,1),1) bn];  
  pn = str2mat('CRSNUM',pn);   un = str2mat('  ',un);
  % 
  % create new block of data sized for both sets but with nan's for new set
  b = [bo; n*ones(size(bn,1),1)  nan*ones(size(bn,1),size(bo,2)-1)];
  %go through all the variables and check to get properties to line up and
  % to  see if units are same
  
  %keyboard
  matched = 0*ones(1,size(pn,1));matched(1) =1;
  for i = 2:size(po,1);

    for j = 1:size(pn,1)
      if strcmp(po(i,:),pn(j,:))
	%if a match is found then add in appropriate column
	  matched(j) = 1; 	  
	  b(b(:,1)==n,i) = bn(:,j);
	  if ~strcmp(uo(i,:),un(j,:))
	    disp(['Warning! Units mismatch: ',pn(j,:),' has units ',un(j,:),...
                 ' in file ',fname])
            disp([ '     Previous file had units ',uo(i,:)])
          end
        break
      end
    end
  end
  if any(matched==0)
    for j = find(matched == 0)
    %if no match is found append a column to end
      b = [b nan*ones(size(b,1),1)];
      b(b(:,1)==n,size(b,2)) = bn(:,j);
      p = str2mat(p,pn(j,:));
      u = str2mat(u,un(j,:));   
    end
  end
end





