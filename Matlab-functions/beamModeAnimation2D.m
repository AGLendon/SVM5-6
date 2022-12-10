clear variables
close all
clc

%% ===========================================================================
% load data
% ============================================================================
% needs to be adjusted for your data, if the whole measurement chain is properly
% calibrated, then this value should be 1
scaling_factor = 100;

load comparison_upper_edge_and_center.mat
H1=da.HS(:,1,2)*scaling_factor;     % needs to be adjusted for the structure of your data
fa1=da.f;
load position_2_and_3.mat
H2=da.HS(:,1,2)*scaling_factor;
H3=da.HS(:,1,3)*scaling_factor;
load position_4_and_5.mat
H4=da.HS(:,1,2)*scaling_factor;
H5=da.HS(:,1,3)*scaling_factor;
load position_6_and_7.mat
H6=da.HS(:,1,2)*scaling_factor;
H7=da.HS(:,1,3)*scaling_factor;

%% ===========================================================================
% plot input mobility to select frequency
% NOTE: for a precise selection of the resonance frequency it is probably better
% to select fnow manually and not graphically from the plot
% ============================================================================
figure(1)
semilogx(fa1,20*log10(abs(H1./(1j*2*pi*fa1'))))
[fnow,dummy]=ginput(1);
%fnow=1000;
ii=find(fa1<=fnow,1,'last');
fprintf('Selected frequency: %5.1f Hz\n',fa1(ii))

z1=0:15.25:93.5;
xi=[H1(ii) H2(ii) H3(ii) H4(ii) H5(ii) H6(ii) H7(ii)]./(1j*2*pi*fa1(ii))^2;
xi=xi/max(abs(xi));

%% ===========================================================================
% plot mode shape animation
% ============================================================================
figure(2)
for nt=0:0.1:2*2*pi
 mag=real(xi.*exp(1j*nt));
 plot(z1,mag,'.-');
 axis([-1 94 -2 2])
 pause(0.1)
end


