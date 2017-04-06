
%main script
%% load data
clear;
clc;
load('C:\Users\wuB\Documents\MATLAB\055_1m.mat');

%% proprecess
[ppgs_preprocess,interval]=preprocess(ppgs,fs,ppgt);
%% segmentation
ppgSeg = Segmentation(ppgs_preprocess,fs,interval,ppgt);
%% ai(augmentation index)
[ai,ait]=AI(ppgSeg,1);
%average_ai=nanmean(ai);%calculate average AI
%% HRDN(half rise to dicrotic notch)
[hrdn,hrdnt]=HRDN(ppgSeg,1);
%average_hrdn=nanmean(hrdn);%calculate average HRDN
%% TD(time delay)
[td,tdi]=TD(ppgSeg,1);
%average_td=nanmean(td);%calculate average td

%% sa(systolic ampliude)
[sa,sat]=SA(ppgSeg,1);
%calculate the average systolic amplitude
%average_sa=mean(sa);

%% pulse width
[pw,pwt]=PW(ppgSeg,1);
%average_pw=mean(pw);

%% peak-peak interval
[ppi,ppit]=PPI(ppgSeg,interval,1);
%average_ppi=nanmean(ppi);

%% Inflection Point Area
[ipa,ipat]=IPA(ppgSeg,1);
%average_ipa=nanmean(ipa);

%% Inflection and Harmonic area ratio
[ihar,ihart] =IHAR(ppgSeg,ipa,1);
%average_ihar=nanmean(ihar);

%% PAT
[pat,patt] = PAT(ecgt,ecgs,ppgSeg,interval,1);
%average_pat = nanmean(pat);

%% PA
% pa = PA(ppg_t,ppg_s,Fs);
% average_pa = mean(pa);

%% DAP
dap = DAP(ppgs,fs,ppgt); 

%% GUI
show_GUI;