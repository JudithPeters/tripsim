function Barplot_fMRIrespperCorticalROI
%-----------------------------------------
%% creates Figure 3 of Peters et al., 2019
% Figures show the TMS-induced BOLD changes in cortical ROIs for Trials with Weak versus Strong pre-TMS alpha power
% color legend: Bars representing Motor Execution (ME) and TMS-responsive ROIs are shown in dark and light shades, respectively.
%               Blue and red bars represent Weak versus Strong pre-TMS alpha power, respectively.
% Upper and Lower row represent data from participant 1 and 2, respectively.
% Judith Peters, december 2019
%-----------------------------------------
% load 5-dimensional array Alpha_TrialsxPowerClassxROITypexROIsxSubj:
% The 5 dimensions represent: 1) TMS-evoked BOLD responses (indexed by their average beta value) in 40 trials
% 2) Weak and strong power class 3) Motor Execution and TMS- responsive ROIs
% 4) Cortical and subcortical ROIs ('rPMd','lPMd','rM1','SMA','rCN','rPut','rThal','lThal','lPut','lCN') 5) Participants
load('fMRIactivity_AlphaClasses.mat', 'Alpha_TrialsxPowerClassxROITypexROIsxSubj');
ROInames={'rPMd','lPMd','rM1','SMA','rCN','rPut','rThal','lThal','lPut','lCN'};

h=figure; pli=1; %set(gcf, 'Position', get(0, 'ScreenSize'));
for si=1:2 %per High Activator participant
    for ploti=1:4 % each panel shows a Cortical ROI
        subplot(2,4,pli);
        %get individual trials for the weak and strong alpha power class per ROI Type (Motor Execution and TMS-responsive ROIs)
        TrialsxPowerClasspROIType = reshape(Alpha_TrialsxPowerClassxROITypexROIsxSubj(:,:,:,ploti,si),[],4);
        
        %compute metrics for bars
        Means_PowerClasspROIType = nanmean(TrialsxPowerClasspROIType);
        SEs_PowerClasspROIType = nanstd(TrialsxPowerClasspROIType)/sqrt(40); %40 trials per class
        %set x coordinates of bars in order to group ROIs on x-axis
        Xbar=[0.675 1.575 2.925 3.825];
        
        %plot bar
        Hbar = bar(Xbar,Means_PowerClasspROIType,'FaceColor','flat'); hold on
        Hbar.CData(1,:) = [0 0 0.5]; Hbar.CData(3,:) = [0 0 1]; %blue shades
        Hbar.CData(2,:) = [0.5 0 0]; Hbar.CData(4,:) = [1 0 0]; %red shades
        Hbar.BarWidth = 0.8;
        %add error bars
        HErrb = errorbar(Xbar, Means_PowerClasspROIType, nan(1,4), SEs_PowerClasspROIType, '.k');
        %show individual data points on top of errorbars
        for i=1:4
            y=TrialsxPowerClasspROIType(:,i);
            x_jitter= repmat(Xbar(i),40,1) + 0.2.*rand(length(y),1);
            scatter(repmat(Xbar(i),40,1) + 0.2.*rand(length(y),1),y,6,repmat(0.6,1,3)); hold on;
        end
        %set axis properties
        set(gca,'XTick',Xbar,'fontsize',10);
        set(gca,'XTickLabel',repmat({'ME','TMS'},1,2));
        set(gca, 'XLim', [0 4.5]);
        set(HErrb, 'marker', 'none')
        title(ROInames{1,ploti},'fontsize',10);
        %the most upper right plot automatically gets yticks only at 0,5,10,15, adjust to label all even numbers (like other plots)
        if si==1 && ploti==1, ylim(gca,[-18 14]); yticks(gca,-18:2:14); end
        pli=pli+1;
    end
end
saveas(h,'Barplot_fMRIrespperCorticalROI.fig');