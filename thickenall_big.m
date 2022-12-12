function thickenall_big();
% THICKENALL is a function to make all LINES in plot thicker and all TEXT
%	and AXIS LABELS larger

% Berndt Zeitler 20030213 / ITA TU Berlin
% Wolfgang Kropp: 2019 Chalmers

axislinewidth = 1.0;
linelinewidth = 2;

axisfontsize = 24;
ledgendfontsize = 18;
textfontsize = 18;
labelfontsize = 24;
titlefontsize = 24;

h_axes = findobj('type','axes');
set(h_axes,'linewidth',axislinewidth);
set(h_axes,'fontsize',axisfontsize);

h_title = get(h_axes,'title');
for n = 1:length(h_title),
   if length(h_title)==1,
      set(h_title,'fontsize',titlefontsize);
   else
      set(h_title{n},'fontsize',titlefontsize);
   end
end
h_xlabel = get(h_axes,'xlabel');
for n = 1:length(h_xlabel),
   if length(h_xlabel)==1,
      set(h_xlabel(n),'fontsize',labelfontsize);
   else
      set(h_xlabel{n},'fontsize',labelfontsize);
   end
end
h_ylabel = get(h_axes,'ylabel');
for n = 1:length(h_ylabel),
   if length(h_xlabel)==1,
      set(h_ylabel(n),'fontsize',labelfontsize);
   else
      set(h_ylabel{n},'fontsize',labelfontsize);
   end
   
end


h_ledgend = findobj('type','text');
set(h_ledgend,'fontsize',ledgendfontsize);

h_line=findobj('type','line');
set(h_line,'linewidth',linelinewidth);