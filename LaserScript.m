%% Clear workspace
clc
clear
close all

%% Load Data
LoadData;
clear acc;
% Data loaded in a struct access like: Fs = laser.Fs

%% Line styles
line1style = 'k--';
line2style = 'g:';
xticks_values = [1e0 1e1 1e2 1e3 1e4];
%%
f=(1:1:6400);
pos = 1;

f0 = figure(Name='Mobility Comp',Position =  [100, 0, 880, 780]);
semilogx(f,20*log10(abs(laser.H1_velocity(pos,:))),line1style);
hold on
semilogx(f,20*log10(abs(laser.H2_velocity(pos,:))),line2style);

xticks(xticks_values);
legend('H1','H2',Location='best')
xlabel('Frequency Hz');
ylabel('Estimator amplitude dB');
%ylim([-95 0]);
xlim([2 6400])
grid on

%%
[pks,locs,hbwMag,hbwFreqIntersects] = halfBWFind(20*log10(abs(laser.H1_velocity(pos,:))),10,7);

semilogx(locs,pks,'or')
for i = 1:length(hbwMag)
    x = hbwFreqIntersects(i,1):0.01:hbwFreqIntersects(i,2);
    y = zeros(size(x))+hbwMag(i);
    plot(x,y,'k-',HandleVisibility='off')
end
hpbw = -hbwFreqIntersects(:,1)+hbwFreqIntersects(:,2); %band width in hz
thickenall_big