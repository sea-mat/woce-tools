function  bot_gui(bot,varn, units)

% BOT_GUI Opens a GUI panel for property-property plots from bottle data.  
%         User can control property assigned to the x-axis, y-axis as
%         well as color-axis.  User can also limit range of every variable.
%
%  USAGE:   bot_guix(bottle_dat,variable_names, units)
%
%  INPUTS
%     bottle_dat - array of bottle data: each column is a property and each
%                  row is one suite of bottle measurements
%     variable_names  - (opt) a string array of the property labels for
%                   each column of bottle_dat
%     units - (opt) a string array of labels specifying the units for each
%                    variable name
%                    
% this can be slow depending on X-server and may still have some bugs....
% Also it doesn't seem to work on PC's, though it works OK on unix boxes.
% 
%   Paul E Robbins, copyright 1995.
% last modified 12/11/96

dontuse = str2mat('CASTNO','SAMPNO','BTLNBR','CTDRAW');  

if nargin < 2
  varn = '1';
  for v = 2:size(bot,2);
    varn = str2mat(varn,num2str(v));
  end
end
if nargin < 3
  units = blanks(size(bot,2))';
end

%get rid of columns specifed not to be used
for i = 1:size(dontuse,1);
  for j = 1:size(bot,2);
    if strcmp(varn(j,:),dontuse(i,:))
      bot(:,j) = [];
      varn(j,:) = [];
      units(j,:) = [];
      break
    end
  end
end

for i = 1:size(bot,2)
  if strcmp(varn(i,:),'STNNBR'); ista = i;end
end
    
clear uselim numcolors
numcolors = 10;
xedge = 10; x1 = xedge;
yedge = 28;
width = 30;
avwidth = 7; % actually 6.8886 +/- 0.4887
height = 26;
maxlen = size(varn,2);
twidth = 1.2*maxlen*avwidth*1.5;

mwwidth = 5*((twidth + width)*1.05 + 2*xedge);
mwheight = (size(varn,1)+6.6)*yedge;	% total height of window

x2 = 2*x1+(width+twidth);
x3 = 3*x1+2*(width+twidth)*1.05;
x4 = 4*x1+3*(width+twidth)*1.05;
x5 = 5*x1+4*(width+twidth)*1.05;
x6 = 5*x1+4.5*(width+twidth)*1.05;


%possible colormaps
clmaps = str2mat('hsv','gray','hot','cool','prism','jet');
%    'sil_col','nit_col','ox_col');
clmap = 1;
caxis = hsv(numcolors);    %need to define for compiler

rect = [10 100 mwwidth mwheight];
fig = figure('Position',rect,'number','off','name',' Plot Control ');
pcf = fig;
set(gca,'Position',[0 0 1 1]); axis off;

nvar = size(varn,1);

%define some colors for buttons
c1 = [.2 1 1]; % X and Y axis buttons
c2 = [1 1 .2]; % range buttons
c3 = [1 .2 1]; % color axis buttons
c4 = [.4 .8 .4];
c5 = [.2 .2 .2]; % frame colors

uicontrol('style','frame','backgroundcolor',c5,'position',....
  [x1-5 5 2*(width+twidth)+20 yedge*(nvar+1)+20])
uicontrol('style','frame','backgroundcolor',c5,'position',....
  [x3-5 5 (width+twidth)+10 yedge*(nvar+1)+20])
uicontrol('style','frame','backgroundcolor',c5,'position',....
  [x4-5 5  (width+twidth)+155 yedge*(nvar+1)+20])

uicontrol('style','text','string','X-AXIS','background',c1*.7,...
'position',[x1 (nvar+.5)*yedge+5 width+twidth height]);
uicontrol('style','text','string','Y-AXIS','background',c1*.7,...
'position',[x2 (nvar+.5)*yedge+5 width+twidth height]);
t1 = uicontrol('style','text','string','COLOR','background',c3*.7,...
'position',[x3 (nvar+.5)*yedge+5 width+twidth height]);
uicontrol('style','text','string','RANGE','background',c2*.7,...
'position',[x4 (nvar+.5)*yedge+5 width+twidth height]);
uicontrol('style','text','string','MINIM','background',c2*.7,...
'position',[x5 (nvar+.5)*yedge+5 60 height]);
uicontrol('style','text','string','MAXIM','background',c2*.7,...
'position',[x5+70 (nvar+.5)*yedge+5 60 height]);



global IX IY ii h1 h2 h3 h4 h5 h6 h7 uselim ID IQ IC numcolors
clear h1 h2 h3 h4 h5 h6 h7 uselim IX
global IX IY ii h1 h2 h3 h4 h5 h6 h7 uselim ID IQ IC numcolors pcf


for ii = 1:size(varn,1)
    % make X-axis buttons
    h1(ii) = uicontrol('position',[x1  (ii-.5)*yedge width+twidth height]);
    set(h1(ii),'callback',['global IX h1 ii; IX=',int2str(ii),...
	    ';set(h1(1:length(h1)~=',int2str(ii),'),''value'',0);' ]);
    set(h1(ii),'string',['  ', varn(ii,:)],'HorizontalAlignment','left');
    set(h1(ii),'style','radio','backgroundcolor',c1);

    % make Y-axis buttons
    h2(ii) = uicontrol('position',[x2  (ii-.5)*yedge width+twidth height]);
    set(h2(ii),'callback',['global IY h2 ii;IY=',int2str(ii),...
	    ';set(h2(1:length(h2)~=',int2str(ii),'),''value'',0);' ]);
    set(h2(ii),'string',['  ', varn(ii,:)],'HorizontalAlignment','left');
    set(h2(ii),'style','radio','backgroundcolor',c1);
    
    % make Color Axis buttons
    h3(ii) = uicontrol('position',[x3  (ii-.5)*yedge width+twidth height]);
    set(h3(ii),'callback',['global IC h3 ii; IC=',int2str(ii),...
	    ';set(h3(1:length(h3)~=',int2str(ii),'),''value'',0);' ]);
    set(h3(ii),'string',['  ', varn(ii,:)],'HorizontalAlignment','left');
    set(h3(ii),'style','radio','backgroundcolor',c3);

    %make Limit axis buttons
    h5(ii) = uicontrol('position',[x4  (ii-.5)*yedge width+twidth height]);
    uselim(ii) = 0;
    set(h5(ii),'callback',['global uselim ii;',...
        'uselim(',int2str(ii),')=~uselim(', int2str(ii),');']);
    set(h5(ii),'string',['  ', varn(ii,:)],'HorizontalAlignment','left');
    set(h5(ii),'style','check','backgroundcolor',c2)
  
    %make fields to display current limits
    h6(ii) = uicontrol('position',[x5  (ii-.5)*yedge 60 height]);  
    set(h6(ii),'style','edit','visible','off','backgroundcolor',c2)
    set(h6(ii),'string',num2str(min(bot(~isnan(bot(:,ii)),ii))));
    
    h7(ii) = uicontrol('position',[x5+70  (ii-.5)*yedge 60 height]);  
    set(h7(ii),'style','edit','visible','off','backgroundcolor',c2)
    set(h7(ii),'string',num2str(max(bot(~isnan(bot(:,ii)),ii))));
end

h10 = uicontrol('position',[x1 mwheight-yedge*1.5 width+twidth height]);
set(h10,'string','QUIT','HorizontalAlignment','center','callback',...
    ['global IQ; IQ=1;'],'backgroundcolor',[1 0 0]);

h11 = uicontrol('position',[x1 mwheight-yedge*3.5 width+twidth height]);
set(h11,'string','DRAW','HorizontalAlignment','center','callback',...
    ['global ID; ID=1;'],'backgroundcolor',[.3 1 .3]);

% use current figure number to find fig numbers of next four windows
figstr = ['FIG. ',num2str(fig+1),'|FIG. ',num2str(fig+2),'|FIG. ',...
  num2str(fig+3),'|FIG. ',num2str(fig+4)];
global h27 fig
h27 = uicontrol('position',[x5,mwheight-yedge*1.5 width+twidth height]);
set(h27,'style','popup','string',figstr,'HorizontalAlignment','center');
set(h27,'backgroundcolor',c4)

h12 = uicontrol('position',[x2 mwheight-yedge*1.5 width+twidth height]);
set(h12,'string','COL PRNT','HorizontalAlignment','center','callback',...
    ['global h27 pcf;figure(get(h27,''value'')+pcf);print -dpsc) ;']);
set(h12,'backgroundcolor',c4)

h13 = uicontrol('position',[x2 mwheight-yedge*2.5 width+twidth height]);
set(h13,'string','BW PRINT','HorizontalAlignment','center','callback',...
    ['global h27 pcf;figure(get(h27,''value'')+pcf);print -dps ;']);
set(h13,'backgroundcolor',c4)

global h20 h21 
h20 = uicontrol('position',[x3 mwheight-yedge*4.5 (width+twidth)/2 height]);
set(h20,'style','text','string',num2str(numcolors),'backgroundcolor',c3)

h21= uicontrol('position',...
       [x4-(width+twidth)/2,mwheight-yedge*4.5 2*width+twidth height]);
set(h21,'style','slider','min',2,'max',20,'value',numcolors)
set(h21,'backgroundcolor',c3)
set(h21,'callback',['global h20 h21 numcolors;',...
   'numcolors=round(get(h21,''value''));set(h20,''string'',num2str(numcolors));'])

t = text(x3,mwheight-yedge*3.2,'NUMBER OF COLORS','units','pixels');



h22 = uicontrol('position',[x5,mwheight-yedge*2.5 width+twidth height]);
set(h22,'string','FLIP X','HorizontalAlignment','center','callback',...
    ['global h27 pcf; figure(get(h27,''value'')+pcf); set(gca,''xdir'',''rev'')']);
set(h22,'backgroundcolor',c4)

h23 = uicontrol('position',[x5,mwheight-yedge*3.5 width+twidth height]);
set(h23,'string','FLIP Y','HorizontalAlignment','center','callback',...
    ['global h27 pcf; figure(get(h27,''value'')+pcf); set(gca,''ydir'',''rev'')']);
set(h23,'backgroundcolor',c4)

h29 = uicontrol('position',[x5,mwheight-yedge*4.5 width+twidth height]);
set(h29,'style','popup','string','GRID OFF|GRID ON','HorizontalAlignment','center')
set(h29,'backgroundcolor',c4)

global h24 
h24 = uicontrol('position',[x4,mwheight-yedge*1.5 width+twidth height]);
set(h24,'backgroundcolor',c3);
set(h24,'string','COLOR|TEXT','HorizontalAlignment','center','style',...
    'popup')
set(h24,'value',1)

clstr = deblank(clmaps(1,:));
for cl = 2:length(clmaps)
   clstr = [clstr,'|',deblank(clmaps(cl,:))];
end
global h26
h26 = uicontrol('position',[x4,mwheight-yedge*2.5 width+twidth height]);
set(h26,'backgroundcolor',c3);
set(h26,'string',clstr,'HorizontalAlignment','center','style',...
   'popup')
set(h26,'value',1);

t = text(x3,mwheight-yedge*2.1,'COLOR MAP:','units','pixels');
t = text(x3,mwheight-yedge*1.1,'COLOR/TEXT:','units','pixels');

IQ = 0; ID = 0; 
IX = 0; IY = 0; IC = 0;

pcf = gcf;  %handle for plot control figure
cf = gcf+1; global cf;


uselim = uselim(1:size(bot,2));
h1 = h1(1:size(bot,2));
h2 = h2(1:size(bot,2));
h3 = h3(1:size(bot,2));
h5 = h5(1:size(bot,2));
h6 = h6(1:size(bot,2));
h7 = h7(1:size(bot,2));

set(h27,'value',1);

while IQ ==0


  while  IQ == 0 & ID == 0 | IY == 0 | IX == 0
    drawnow;
%    waitforbuttonpress
    usetext = get(h24,'value')-1;
    if any(uselim)
      set(h6(uselim),'visible','on'); set(h7(uselim),'visible','on');
    end
    if any(~uselim)
      set(h6(~uselim),'visible','off');set(h7(~uselim),'visible','off');
    end
    if usetext
      set(h26,'visible','off');set(h20,'visible','off');
      set(h21,'visible','off');      set(t1,'string','TEXT');
    else
      set(h26,'visible','on');set(h20,'visible','on');
      set(h21,'visible','on');       set(t1,'string','COLOR')
    end
  end
  
  ID = 0; 
  fs = ones(size(bot(:,1)));  
  if any(uselim)
    for ul = find(uselim)
      bad = (bot(:,ul) <  str2num(get(h6(ul),'string'))... 
	  | bot(:,ul) > str2num(get(h7(ul),'string')));
      fs(bad) = 0*fs(bad);
    end      
  end
  if IQ ~=1
%    figure(cf);  clf
    clmap = get(h26,'value');
    usetext = get(h24,'value')-1;
    figure(get(h27,'value')+pcf);  clf
    if usetext
      plot(bot(fs,IX),bot(fs,IY),'.')
      ff = find(fs);
      for fi = 1:sum(fs)
        if ~isnan(bot(ff(fi),IC))
	 text(bot(ff(fi),IX),bot(ff(fi),IY),sprintf('%5g',bot(ff(fi),IC)),...
	   'horizontalal','center','verticalal','middle','fontsize',8)
        end
      end
    elseif IC ==0;
      plot(bot(fs,IX),bot(fs,IY),'x','markersize',6)
    else

      eval(['caxis = ',deblank(clmaps(clmap,:)),'(numcolors); '])

      ticklabels = [];
      vc = bot(fs,IC);
      v1 = min(vc(~isnan(vc)));
      v2 = max(vc(~isnan(vc)));      
      
      % if a min/max scale is set for colorbar variable then use those limits
      %
      if any(find(uselim) == IC)
	v1 = str2num(get(h6(IC),'string'));
	v2 = str2num(get(h7(IC),'string'));
      end
      
      
      vs = (v2-v1)/(numcolors);
      
      if sum(fs) > 1e4
            msize = 4;
      elseif sum(fs) > 1e3	      
           msize = 10;
      else	
           msize = 14;
      end		
      for c = 0:numcolors-1
	fc = bot(:,IC) >= v1+c*vs & bot(:,IC) <= v1+(c+1)*vs;
	h = plot(bot(fs&fc,IX),bot(fs&fc,IY),'.',....
	    'color',caxis(c+1,:),'markersize',msize);
	hold on
	ticklabels = str2mat(ticklabels,num2str(v1+(c+1)*vs));
      end
      hold off
      ticklabels = ticklabels(2:numcolors+1,:);
      
      eval(['colormap(',deblank(clmaps(clmap,:)),'(numcolors))'])
      hc= colorbar('horiz');
      set(hc,'xtick',[1/2/(numcolors-1):1/(numcolors-1):1-1/2/numcolors])
      set(hc,'xticklabels',ticklabels)
      set(get(hc,'xlabel'),'string',[varn(IC,:),' (',units(IC,:),')'])
    end
    zoom
    ylabel([varn(IY,:),' (',units(IY,:),')'])
    xlabel([varn(IX,:),' (',units(IX,:),')'])
    if get(h29,'value')==2
        grid
      end
    
    % use specified limits to set axis scale  
    if any(find(uselim) == IY)
      ylim =  [str2num(get(h6(IY),'string')) str2num(get(h7(IY),'string'))];
      set(gca,'ylim',ylim)
    end

    if any(find(uselim) == IX)
      xlim =  [str2num(get(h6(IX),'string')) str2num(get(h7(IX),'string'))];
      set(gca,'xlim',xlim)
    end

      
    if strcmp(varn(IY,:),'CTDPRS')
     set(gca,'ydir','rev')
    end	
    if any(ista)
      stas = sort(bot(fs,ista));
      stas(find(diff(stas)==0))=[];
      if length(stas) > 10
        minsta = min(bot(fs,ista));
        maxsta = max(bot(fs,ista));
        title(['Stations ',num2str(minsta),' - ',num2str(maxsta)])
      else
        stastr = [];
        for i = 1:length(stas)
            stastr = [stastr,' ',num2str(stas(i))];
        end	
        title(['Stations ',stastr])
      end
    end
  end
end
end
close(pcf); 






