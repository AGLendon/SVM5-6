%%
load("H1_Acc.mat","H1_acc")
load("H2_Acc.mat","H2_acc")
load("ACC_pos1.mat")
%%
xticks_values = [10e0 10e1 10e2 10e3 10e4];
%%
da2=SVMT_spectra(data,info,2^12);
gamma.gamma_12 = da2.gamma2;
f.f_12 = da2.f;
da2=SVMT_spectra(data,info,2^14);
gamma.gamma_14 = da2.gamma2;
f.f_14 = da2.f;
da2=SVMT_spectra(data,info,2^16);
gamma.gamma_16 = da2.gamma2;
f.f_16 = da2.f;
da2=SVMT_spectra(data,info,2^18);
gamma.gamma_18 = da2.gamma2;
f.f_18 = da2.f;
save("Gamma Compare","gamma",'f')
%%
chan1 = 1;
chan2 = 2;
f1 = figure(Name='Coherence',Position =  [100, 0, 880, 780]);
semilogx(f.f_18,gamma.gamma_18(:,chan1,chan2),'g-.',f.f_16,gamma.gamma_16(:,chan1,chan2),'b--',f.f_14,gamma.gamma_14(:,chan1,chan2),'r:',f.f_12,gamma.gamma_12(:,chan1,chan2),'k-')
legend('2^{18}','2^{16}','2^{14}', '2^{12}',Location='best')
grid on
ylim([0 1.1])
xlabel('Frequency Hz');
ylabel('Coherence');
%%
H1Mob_acc = 20*log10(abs(H1_acc(:,chan1,chan2)./(1j*2*pi*f.f_14')));
H2Mob_acc = 20*log10(abs(H2_acc(:,chan1,chan2)./(1j*2*pi*f.f_14')));
save('H1Mob_Acc',"H1Mob_acc")
save('H2Mob_Acc',"H2Mob_acc")
f2 = figure(Name='Estimators',Position =  [100, 0, 880, 780]);
semilogx(f.f_14,H1Mob_acc,'k-',f.f_14,H2Mob_acc,'g:')
grid on
xlabel('Frequency Hz');
ylabel('Estimator Amplitude dB');
xticks(xticks_values);
%ylim([-95 0]);
xlim([2 6400])
grid on
%%
thickenall_big
%%
startPos = 55;
bw_acc = powerbw(abs(H2_acc(startPos:end,1,2)./(1j*2*pi.*f.f_14(startPos:end)')),f.f_14(startPos:end));