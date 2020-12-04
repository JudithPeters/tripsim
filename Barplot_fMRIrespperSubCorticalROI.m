function Barplot_fMRIrespperSubCorticalROI
%-----------------------------------------
%% creates Figure 4 of Peters et al., 2019
% Figures show the TMS-induced BOLD changes in SUBcortical ROIs for Trials with Weak versus Strong pre-TMS alpha power
% color legend: Bars representing Motor Execution and TMS-responsive ROIs are shown in dark and light shades, respectively.
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

h=figure; set(gcf, 'Position', get(0, 'ScreenSize'));
for si=1:2 %per High Activator participant
    subplot(2,1,si); Means_ROIxPowerClasspROIType=[]; SEs_ROIxPowerClasspROIType=[]; Yscatter=[];
    %get and processs trial data for each of the 6 subcortical ROIs
    for ROIi=5:10
        %get individual trials for the weak and strong alpha power class per ROI Type (Motor Execution and TMS-responsive ROIs)
        TrialsxPowerClasspROIType = reshape(Alpha_TrialsxPowerClassxROITypexROIsxSubj(:,:,:,ROIi,si),[],4);
        
        %compute metrics for bars
        Means_ROIxPowerClasspROIType = [Means_ROIxPowerClasspROIType nanmean(TrialsxPowerClasspROIType)];
        SEs_ROIxPowerClasspROIType = [SEs_ROIxPowerClasspROIType nanstd(TrialsxPowerClasspROIType)/sqrt(40)]; %40 trials per class
    end
    %set x coordinates of bars in order to group ROIs on x-axis
    Xbar=[]; for i=1:6, Xbar=[Xbar [0.675 1.575 2.925 3.825]+(i-1)*5]; end
    
    %plot bar
    Hbar = bar(Xbar,Means_ROIxPowerClasspROIType,'FaceColor','flat'); hold on
    Hbar.CData(1:4:21,:) = repmat([0 0 0.5],6,1); Hbar.CData(3:4:23,:) = repmat([0 0 1],6,1); %blue shades
    Hbar.CData(2:4:22,:) = repmat([0.5 0 0],6,1); Hbar.CData(4:4:24,:) = repmat([1 0 0],6,1); %red shades
    Hbar.BarWidth = 0.8;
    %add error bars
    HErrb = errorbar(Xbar, Means_ROIxPowerClasspROIType, nan(1,24),SEs_ROIxPowerClasspROIType, '.k');
    %show individual data points on top of errorbars
    bari=1;
    for ROIi=5:10
        y=reshape(Alpha_TrialsxPowerClassxROITypexROIsxSubj(:,:,:,ROIi,si),[],4);
        for i=1:4
            scatter(repmat(Xbar(bari),40,1) + 0.2.*rand(40,1),y(:,i),6,repmat(0.6,1,3)); hold on;
            bari= bari+1;
        end
    end
    %set axis properties
    set(gca,'XTick',2:5:28,'fontsize',8);
    set(gca,'XTickLabel',strcat(strcat({'              '},ROInames(5:10)),'\newlineME                 TMS'));
    set(gca, 'XLim', [0 29.5]);
    set(gca,'YTick',-10:1:10);
    set(HErrb, 'marker', 'none')
end
saveas(h,'Barplot_fMRIrespperSubCorticalROI.fig');