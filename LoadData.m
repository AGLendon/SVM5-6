clear
clc
close all
%% Loading The Data
%Laser
laser = load("Data\Laser\Group2_laser.mat");

%Accelerometer
acc.bg = load("Data\Accelerometer\background.mat");
acc.u_pos34 = load("Data\Accelerometer\pos_34_without_tape.mat");
acc.pos12= load("Data\Accelerometer\pos_12.mat");
acc.pos34 = load("Data\Accelerometer\pos_34.mat");
acc.pos56 = load("Data\Accelerometer\pos_56.mat");
acc.pos78 = load("Data\Accelerometer\pos_78.mat");

%%
