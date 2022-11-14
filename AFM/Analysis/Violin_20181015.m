clc;clear;close all
BL=xlsread('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/dpy-5/Analysis-dpy5-20181008/BodyLength.xlsx');
    
dir_data=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/dpy-5/Analysis-dpy5-20181008/txt-files');%uigetdir;
Files=dir([dir_data,'/*.mat']);
n_Files=length(dir(fullfile(dir_data,'*.mat')));
p15=0;p40=0;p60=0;p85=0;
r15=0;r40=0;r60=0;r85=0;
m15=0;m40=0;m60=0;m85=0;
for ij=1:n_Files
    
    FilNam=Files(ij).name;
    FilA1=Files(ij).name(1:2);
    FilA2=Files(ij).name(end-18:end-17);
    
    Wor=Files(ij).name(8:9);
    Worm_n =sscanf(Wor,'%d-');
    BodyLeng=1;%BL(Worm_n);
    
    Data_Loc=fullfile(dir_data,Files(ij).name);
    Fillas=load(Data_Loc);
    if FilA1=='An'
        if FilA2=='15'
            q15=length(Fillas.An);
            An15(p15+1:p15+q15)=[Fillas.An/BodyLeng];
            p15= length(An15);
        elseif FilA2=='40'
            q40=length(Fillas.An);
            An40(p40+1:p40+q40)=[Fillas.An/BodyLeng];
            p40= length(An40);
        elseif FilA2=='60'
            q60=length(Fillas.An);
            An60(p60+1:p60+q60)=[Fillas.An/BodyLeng];
            p60= length(An60);
        elseif FilA2=='85'
            q85=length(Fillas.An);
            An85(p85+1:p85+q85)=[Fillas.An/BodyLeng];
            p85= length(An85);
        end
    elseif FilA1=='Fu'
        if FilA2=='15'
            q15=length(Fillas.Fu);
            Fu15(r15+1:r15+q15)=[Fillas.Fu];
            r15= length(Fu15);
        elseif FilA2=='40'
            q40=length(Fillas.Fu);
            Fu40(r40+1:r40+q40)=[Fillas.Fu];
            r40= length(Fu40);
        elseif FilA2=='60'
            q60=length(Fillas.Fu);
            Fu60(r60+1:r60+q60)=[Fillas.Fu];
            r60= length(Fu60);
        elseif FilA2=='85'
            q85=length(Fillas.Fu);
            Fu85(r85+1:r85+q85)=[Fillas.Fu];
            r85= length(Fu85);
        end
            elseif FilA1=='AF'
        if FilA2=='15'
            q15=length(Fillas.AF);
            AF15(m15+1:m15+q15)=[Fillas.AF];
            m15= length(AF15);
        elseif FilA2=='40'
            q40=length(Fillas.AF);
            AF40(m40+1:m40+q40)=[Fillas.AF];
            m40= length(AF40);
        elseif FilA2=='60'
            q60=length(Fillas.AF);
            AF60(m60+1:m60+q60)=[Fillas.AF];
            m60= length(AF60);
        elseif FilA2=='85'
            q85=length(Fillas.AF);
            AF85(m85+1:m85+q85)=[Fillas.AF];
            m85= length(AF85);
        end
    end
end
%% Plots
YY{:,1}=An15;YY{:,2}=An40;YY{:,3}=An60;YY{:,4}=An85;
violin(YY,'facecolor',[1 1 0;0 1 0.1;1 0 0;0 0 1],...
    'edgecolor','none','bw',.11,'mc','k','medc','r-.')
title('\fontsize{25} {\color{magenta} CB61 dpy-5(e61)}')
ylabel('Annuli width (\mum)','FontSize',25)
xlabel('Normalized worm length (%)','FontSize',25)
percentages = { '15'; '40'; '60'; '85'};
ylim([-.1 4])
set(gca,'xtick',1:10,'xticklabel',percentages,'Fontsize',25)
saveas(gcf,'An-dpy5.tif');
figure
XX{:,1}=Fu15;XX{:,2}=Fu40;XX{:,3}=Fu60;XX{:,4}=Fu85;
violin(XX,'facecolor',[1 1 0;0 1 0.1;1 0 0;0 0 1],...
    'edgecolor','none','bw',6,'mc','k','medc','r-.')
title('\fontsize{25} {\color{magenta} CB61 dpy-5(e61)}')
ylabel('Furrow depth (nm)','FontSize',25)
xlabel('Normalized worm length (%)','FontSize',25)
percentages = { '15'; '40'; '60'; '85'};
ylim([-10 300])
set(gca,'xtick',1:10,'xticklabel',percentages,'Fontsize',25)
saveas(gcf,'Fu-dpy5.tif');
%%%% dimensionless 
figure
YY{:,1}=An15/BodyLeng;YY{:,2}=An40/BodyLeng;YY{:,3}=An60/BodyLeng;YY{:,4}=An85/BodyLeng;
violin(YY,'facecolor',[1 1 0;0 1 0.1;1 0 0;0 0 1],...
    'edgecolor','none','bw',.00015,'mc','k','medc','r-.')
title('\fontsize{25} {\color{magenta} CB61 dpy-5(e61)}')
ylabel('Dimensionless annuli width','FontSize',25)
xlabel('Normalized worm length (%)','FontSize',25)
percentages = { '15'; '40'; '60'; '85'};
ylim([-.0001 .004])
set(gca,'xtick',1:10,'xticklabel',percentages,'Fontsize',25)
saveas(gcf,'An-dpy5n.tif');
figure
XX{:,1}=Fu15/BodyLeng/1000;XX{:,2}=Fu40/BodyLeng/1000;XX{:,3}=Fu60/BodyLeng/1000;XX{:,4}=Fu85/BodyLeng/1000;
violin(XX,'facecolor',[1 1 0;0 1 0.1;1 0 0;0 0 1],...
    'edgecolor','none','bw',0.000006,'mc','k','medc','r-.')
title('\fontsize{25} {\color{magenta} CB61 dpy-5(e61)}')
ylabel('Dimensionless furrow depth','FontSize',25)
xlabel('Normalized worm length (%)','FontSize',25)
percentages = { '15'; '40'; '60'; '85'};
ylim([-.00001 .0003])
set(gca,'xtick',1:10,'xticklabel',percentages,'Fontsize',25)
saveas(gcf,'Fu-dpy5n.tif');
%%%% Annuli Vs. Furrows 
figure
YY{:,1}=AF15;YY{:,2}=AF40;YY{:,3}=AF60;YY{:,4}=AF85;
violin(YY,'facecolor',[1 1 0;0 1 0.1;1 0 0;0 0 1],...
    'edgecolor','none','bw',2,'mc','k','medc','r-.')
title('\fontsize{25} {\color{magenta} CB61 dpy-5(e61)}')
ylabel('Annnuli to Furrows Ratio','FontSize',25)
xlabel('Normalized worm length (%)','FontSize',25)
percentages = { '15'; '40'; '60'; '85'};
ylim([0 100])
set(gca,'xtick',1:10,'xticklabel',percentages,'Fontsize',25)
saveas(gcf,'AFdpy5.tif');
% Results=[mean(An15) mean(An40) mean(An60) mean(An85);std(An15) std(An40)...
%     std(An60) std(An85);mean(An15/BodyLeng) mean(An40/BodyLeng) ...
%     mean(An60/BodyLeng) mean(An85/BodyLeng);std(An15/BodyLeng) std(An40/BodyLeng)...
%     std(An60/BodyLeng) std(An85/BodyLeng) ]
%close all
Results=[ An40 An60 ];
Mean_Res=mean(Results)
Std_Res=std(Results)