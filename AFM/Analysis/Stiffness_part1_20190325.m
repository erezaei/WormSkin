clc;clear;close all
dpy=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/dpy-5/Analysis-dpy5-20181008/Mechanics-dpy-20190208/dpy-DMT');
%dpy=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6OE/rolOE-Analysis/Mechanics-rolOE-20190728/rolOE-DMT/rolOE_DMT_Filtered');
N2=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT');
rol=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT');
%
for Strain=1:1
    if Strain==1
        raw_data=dpy;
        Genotype=raw_data(end-6:end-4);
    elseif Strain==2
        raw_data=N2;
        Genotype=raw_data(end-5:end-4);
    else
        raw_data=rol;
        Genotype=raw_data(end-6:end-4);
    end
    Files=dir([raw_data,'/*.txt']);
    n_Files=length(dir(fullfile(raw_data,'*.txt')));
    %     X=xlsread('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/N2-AUG2018/Analysis-N2-20181008/Length_1.xlsx');
    clear Stiff_mean New_Vector_Data Vector_Data Vector_Data_CutOff
    NN=1;MM=1;
    for ij=1:n_Files
        clear An Fu Fur Lengh_Fu DMT St St_An 
        FilNam=Files(ij).name(1:end-4);
        Wor=Files(ij).name(5:6);
        Worm_n =sscanf(Wor,'%d-');
        
        Loc=Files(ij).name(end-18:end-17);
        Location=str2double(Loc);
       StartPoint=2427;
%        if Strain==1
%            StartPoint=67;
%        end
            Data_Loc=fullfile(raw_data,Files(ij).name);
            DAtaa = dlmread(Data_Loc,'',StartPoint,0);
           % if  Location==40 || Location==60 || Location==15 || Location==85
            Data=flipud(DAtaa);
            Mean_Data=mean(mean(Data));
            Stiff_mean(ij)=Mean_Data;
            Vector_Data((((ij-1)*16384)+1):(ij*16384))=Data(:);
            
       
        
    end
    New_Vector_Data=Vector_Data(Vector_Data<11);
    stdDev = std(New_Vector_Data); % Compute standard deviation
    meanValue = mean(New_Vector_Data); % Compute mean
    zFactor = 3; % or whatever you want.
    outliers = abs(New_Vector_Data-meanValue) > (zFactor * stdDev);
    ind = find(~outliers);
    Vector_Data_CutOff=New_Vector_Data(ind);
    STDD=std(Vector_Data_CutOff);
    SIZ=max(size(Vector_Data_CutOff));
    SEM=STDD/sqrt(SIZ);
    Genotype
    ress(Strain,:)=[mean(Vector_Data_CutOff),STDD, SEM, length(Vector_Data_CutOff)/1000000, n_Files]
    stiffdata{:,Strain}=Vector_Data_CutOff';
    %     semilogy(Stiff_mean,'linewidth',2); hold on
    %     %plot(Stiff_mean_CutOff,'linewidth',2); hold on
    %
    % h = histfit(Stiff_mean,10);
    x=logspace(-1,5,40); % create bin edges with logarithmic scale
    subplot(2,3,Strain)
    histogram(Stiff_mean,x); % create the plot
    set(gca,'xscale','log')
    title(Genotype) 
    set(gca,'FontSize',18)
    xlabel('DMT (MPa)','FontSize',24);ylabel('Number of images','FontSize',24)
    axis([.1 200000 0 35])
    subplot(2,3,Strain+3)
    x=logspace(-1,6,40);
    histogram(Vector_Data,x); % create the plot
    set(gca,'xscale','log')
    set(gca,'FontSize',18)
    xlabel('DMT (MPa)','FontSize',24);ylabel('Number of pixels','FontSize',24)
    axis([.1 200000 0 600000])
    for mm=1:n_Files
        Data_Loc=fullfile(raw_data,Files(mm).name);
        DAtaa = dlmread(Data_Loc,'',StartPoint,0);
        Data=flipud(DAtaa);
        Vector_Data=Data(:);
        a= Vector_Data >  max (Vector_Data_CutOff);
        Outliers_num=numel(a(a>0));
        FileNam=Files(mm).name(1:end-4);
        if Outliers_num < 0.2* length(Vector_Data)
            %% Height image; values of XData and YData in imshow needs to be set manually
            %             hFigH =figure;
            %             subplot(3,1,1)
            %             heatMapH = imresize(DataH,[250 1000]);
            %             imshow(heatMapH, [],'XData',[0 10], 'YData', [0 2.5]);
            %             axis on;
            %             colormap (hot(256));
            %             colorbar;
            %             set(gca,'FontSize',24)
            %             title(['Worm '  num2str( FilNam )])
            %             xlabel('\mum','FontSize',24);ylabel('\mum','FontSize',24)
            %             set(hFigH, 'Position', [900 50 900 900])
            %             set(gcf,'Units','normal');%set(gca,'Position',[0.5 0.4 .84 0.88])
            %             %%%%%%%%%
            %             subplot(3,1,2)
            %             heatMap = imresize(Data,[250 1000]);
            %             imshow(heatMap, [],'XData',[0 10], 'YData', [0 2.5]);
            %             axis on;
            %             colormap (hot(256));
            %             handleToColorBar=colorbar;
            %             title(handleToColorBar, 'MPa');
            %             set(gca,'FontSize',24)
            %             title('DMT Modulus')
            %             xlabel('\mum','FontSize',24);ylabel('\mum','FontSize',24)
            %             %set(hFig, 'Position', [900 50 900 900])
            %             set(gcf,'Units','normal');%set(gca,'Position',[0.5 0.4 .84 0.88])
            %             %% Ploting each single scan line; calculating the annuli width on each line
            %             NN=1;
            %             for i=1:length(DataH(:,1))
            %                 clear d
            %                 Y=DataH(i,:);
            %                 N=smooth(Y);
            %                 TF1 = islocalmin(N, 'MinProminence',6);
            %                 ind = find(TF1==1);
            %                 if isempty(ind)
            %                     disp('emptyy')
            %                 else
            %                     Xtarget = X(ind);
            %                     L_Xtarg=length(Xtarget);
            %                     for ll=1:L_Xtarg-1
            %                         if ll==1
            %                             Xtarget = X(ind);
            %                             Ytarget = Y(ind);
            %                         else
            %                             Xtarget = X(ind+1);
            %                             Ytarget = Y(ind+1);
            %                         end
            %                         An(NN,1)=Xtarget(L_Xtarg-ll+1)-Xtarget(L_Xtarg-ll);
            %                         Scanline_pixel=Data(i,(ind(L_Xtarg-ll)+2):(ind(L_Xtarg-ll+1)-2));
            %                         St(NN,1)=mean(Scanline_pixel);
            %                         Stiff_pixel((length(Stiff_pixel)+1):(length(Stiff_pixel)+length(Scanline_pixel)))=Scanline_pixel;
            %
            %                         Ana= An(NN,1);
            %                         Sta=St(NN,1);
            %                         St_An(NN,:)=[Ana Sta];
            %                         NN=NN+1;
            %                     end
            %                 end
            %             end
        end
        if Location=='15'
        end
        
    end
    
    
end
% set(gca,'FontSize',24)
% title('DMT Modulus')
% xlabel('Number of images','FontSize',24);ylabel('DMT (MPa)','FontSize',24)
% lgd=legend('dpy-5', 'N2', 'rol6','Orientation','horizontal');
% xlim([0 105])
%         if FilA2=='15'
%         if FilA2=='40'
%         if FilA2=='60'
%if FilA2=='85'
T = array2table(ress,'VariableNames',{'Mean_MPa','std','SEM','points_milion', 'Number_images'},'RowNames',{'dpy' 'N2' 'rol'})
writetable(T,'Mean_Stif.csv','Delimiter',',','QuoteStrings',true)

TT = array2table(stiffdata,'VariableNames',{'dpy','N2','rol'})
writetable(TT,'StiffDataPoint.csv','Delimiter',',','QuoteStrings',true)