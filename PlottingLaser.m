%% Plotting Laser
clc
clear
close all
%% Load data
load("Data\Laser\Laser.mat")
f_Laser=f;
load("Data\Accelerometer\Accelerometer.mat")
f_Acc=f;
load("Data\Theoretical.mat")
f_Theory=f;
%% Plot style 
line1style = 'k--';
line2style = 'g:';
line3style = 'b-.';

xticks_values = [10e0 10e1 10e2 10e3 10e4];

%% Plot
for i = 1:length(co_ords)
positions = [1 2 5 8];
pos = strcat('Position ',num2str(positions(i)));
pos1 = strcat(pos,' (LDV)');
pos2 = strcat(pos,' (ACC)');
pos3 = strcat(pos,' (THEO)');

f1 = figure(Name='Mobility',Position =  [100, 0, 880, 780]);
semilogx(f_Laser(1:end),20*log10(abs(H1_mobility(co_ords(i),:))),line1style);
hold on
semilogx(f_Acc(2:end),20*log10(abs(saveYmob(i,:))),line2style);
semilogx(f_Theory(1:end),20*log10(abs(Y)),line3style);
hold off
xticks(xticks_values);
legend(pos1,pos2,pos3,Location='best')
xlabel('Frequency Hz');
ylabel('Mobility amplitude dB');
ylim([-95 0]);
xlim([1 12000])
grid on

f2 = figure(Name='Coherence',Position =  [100, 0, 880, 780]);
semilogx(f_Laser,Coherence(co_ords(i),:),line1style);
hold on
semilogx(f_Acc(2:end),saveGamma(i,:),line2style);
xlabel('Frequency Hz');
ylabel('Coherence');
ylim([0 1.05]);
xlim([1 6400]);
xticks(xticks_values);
legend(pos1,pos2,Location='south')
grid on

thickenall_big;
%Save plots
saveFolder = fullfile(pwd,'\Plots\');

    fileName = strcat(pos,'_CompareMobility','.png');
    filePath = fullfile(saveFolder, fileName);
    exportgraphics(f1,filePath,"ContentType","image",'Resolution',600);

    fileName = strcat(pos,'_CompareCoherence','.png');
    filePath = fullfile(saveFolder, fileName);
    exportgraphics(f2,filePath,"ContentType","image",'Resolution',600);

end