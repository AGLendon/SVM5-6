clear
clc
close all
%% Loading The Data
%Laser
laser = load("Data\Laser\Group2_laser.mat");

%Accelerometer
bg = load("Data\Accelerometer\background.mat");
u_pos34 = load("Data\Accelerometer\pos_34_without_tape.mat");
pos12= load("Data\Accelerometer\pos_12.mat");
pos34 = load("Data\Accelerometer\pos_34.mat");
pos56 = load("Data\Accelerometer\pos_56.mat");
pos78 = load("Data\Accelerometer\pos_78.mat");

%%
