%% Clear workspace
clear
clc
close all

%% Load Data
LoadData;
clear laser
% Data loaded in a struct access like: somevariable = bg.da.AS

%%
line1style = 'k--';
line2style = 'g:';
xticks_values = [10e0 10e1 10e2 10e3 10e4];
fn=fieldnames(acc);
for i=1: numel(fn)
    fn1=fieldnames(acc.(fn{i}));    
    for j=1: numel(fn1)
        assignin("caller",fn1{j},acc.(fn{i}).(fn1{j}))
    end
%%
 [pos1, pos2] = findPosition(fn{i});
    %% Defining variables from provided data

f = da.f;
fs = info.fs;
%fs = 5;
AS = da.AS;
AD = da.AD;
gamma2 = pagetranspose(da.gamma2);

HS = da.HS;
HD = da.HD;

ref_value = 2 * 10^-5;
%% Coherence function
%(:,i,j) ch1 is always force shaker, i is ch2, j is ch3 ch2 and 3 change

gamma2_force_tr = pagetranspose(da.gamma2(:,1,1));
gamma2_accel_odd = pagetranspose(da.gamma2(:,1,2));
gamma2_accel_even = pagetranspose(da.gamma2(:,1,3));

f1 = figure(Name='Coherence',Position =  [100, 0, 880, 780]);
% semilogx(f,gamma2_force_tr);
% hold on
semilogx(f,gamma2_accel_odd,line1style);
hold on
semilogx(f,gamma2_accel_even,line2style);

xlabel('Frequency Hz');
ylabel('Coherence');
ylim([0 1.05]);
xlim([1 11000]);
xticks(xticks_values);
legend(pos1,pos2,Location='best')

%%  Input mobility: Check p25 lab 4
% Mobility Y = v / f;

% HS_force_tr = pagetranspose(HS(:,1,1));
% Ymob_force = (da.HS(2:end))'./(2*1j*pi*f(2:end));

HS_odd = pagetranspose(HS(:,1,2));
Ymob_odd = HS_odd(2:end)./(2*1j*pi*f(2:end));
% Ymob_odd = (da.HS(2:end,1,2))'./(2*1j*pi*f(2:end));

HS_even = pagetranspose(HS(:,1,3));
Ymob_even = HS_even(2:end)./(2*1j*pi*f(2:end));
% Ymob_even = (da.HS(2:end,1,3))'./(2*1j*pi*f(2:end));


%% Plotting real part of Ymob
 f2 = figure(Name='Mobility',Position =  [100, 0, 880, 780]);
% semilogx(f(2:end),20*log10(abs(Ymob_force)));
%  hold on
 semilogx(f(2:end),20*log10(abs(Ymob_odd)),line1style);
 hold on
 semilogx(f(2:end),20*log10(abs(Ymob_even)),line2style);
 hold off
 xticks(xticks_values);
 legend(pos1,pos2,Location='best')
 xlabel('Frequency Hz');
 ylabel('Mobility amplitude dB');
 ylim([-95 0]);
 xlim([1 12000])

% % Plotting angle of mobility
% figure(3)
% 
% semilogx(f(2:end), angle(Ymob_odd));
% hold on
% semilogx(f(2:end), angle(Ymob_even)); 
% legend('Odd position','Even position')
% xlabel('Frequency (Hz)');
% ylabel('Input mobility angle');

f4 = figure(Name='Amplitude',Position =  [100, 0, 880, 780]);
semilogx(f,10*log10(da.AS(:,1,1)),line1style);
xlabel('Frequency Hz');
ylabel('Amplitude dB');
legend('Force inducer',Location='best')
xticks(xticks_values);

thickenall_big;
%% Save figures
saveFolder = fullfile(pwd,'\Plots\Accelerometer\');

    fileName = strcat(fn{i},'_Coherence','.png');
    filePath = fullfile(saveFolder, fileName);
    exportgraphics(f1,filePath,"ContentType","image",'Resolution',600);

    fileName = strcat(fn{i},'_Mobility','.png');
    filePath = fullfile(saveFolder, fileName);
    exportgraphics(f2,filePath,"ContentType","image",'Resolution',600);

    fileName = strcat(fn{i},'_Amplitude','.png');
    filePath = fullfile(saveFolder, fileName);
    exportgraphics(f4,filePath,"ContentType","image",'Resolution',600);
%% Save Comparison Data
if isequal('u_pos34',fn{i})
    Ymob_odd3U = Ymob_odd;
    gamma2_accel_odd3U = gamma2_accel_odd;

elseif isequal('pos34',fn{i})
    Ymob_odd3 = Ymob_odd;
    gamma2_accel_odd3 = gamma2_accel_odd;

end
end
%% 
f5 = figure(Name='Mobility UC',Position =  [100, 0, 880, 780]);
 semilogx(f(2:end),20*log10(abs(Ymob_odd3)),line1style);
 hold on
 semilogx(f(2:end),20*log10(abs(Ymob_odd3U)),line2style);
 hold off
 xticks(xticks_values);
 legend('Damped Stringer','Undamped Stringer',Location='best')
 xlabel('Frequency Hz');
 ylabel('Mobility amplitude dB');
 ylim([-95 0]);
 xlim([100 1000])

f6 = figure(Name='Coherence UC',Position =  [100, 0, 880, 780]);
% semilogx(f,gamma2_force_tr);
% hold on
semilogx(f,gamma2_accel_odd3,line1style);
hold on
semilogx(f,gamma2_accel_odd3U,line2style);

xlabel('Frequency Hz');
ylabel('Coherence');
ylim([0 1.05]);
xlim([1 11000]);
xticks(xticks_values);
legend('Damped Stringer','Undamped Stringer',Location='best')
thickenall_big

fileName = strcat('UC_Mobility','.png');
    filePath = fullfile(saveFolder, fileName);
    exportgraphics(f5,filePath,"ContentType","image",'Resolution',600);

fileName = strcat('UC_Coherence','.png');
    filePath = fullfile(saveFolder, fileName);
    exportgraphics(f6,filePath,"ContentType","image",'Resolution',600);