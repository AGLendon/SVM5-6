%% Clear workspace
clc
clear
close all

%% Load Data
LoadData;
clear bg; clear pos12; clear pos34; clear pos56; clear pos78; clear u_pos34; 
% Data loaded in a struct access like: Fs = laser.Fs

%%
f=(1:1:64000);


Avrg_coherence = mean(Coherence);
H1_mobility = AP_velocity./H1_velocity;

semilogx(f,Avrg_coherence)
