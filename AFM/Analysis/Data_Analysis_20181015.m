clc;clear;close all
%% Reading Data fomr the files. X is set to be for 10 um scan. If the sacan size is different than 10um you need to adjust the 'X' file values.
%dir_data=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/dpy-5/Analysis-dpy5-20181008/txt-files');%uigetdir;
dir_data=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/N2-AUG2018/Analysis-N2-20181008/txt-files')
Files=dir([dir_data,'/*.txt']);
n_Files=length(dir(fullfile(dir_data,'*.txt')));
for ij=1:n_Files
    clear An Fu Fur Lengh_Fu
    FilNam=Files(ij).name(1:end-4);
    Wor=Files(ij).name(5:6);
    Worm_n =sscanf(Wor,'%d-');
    
    Data_Loc=fullfile(dir_data,Files(ij).name);
    DAtaa = dlmread(Data_Loc,'',1,0);
    % ========================= Analysis ======================================
    
    %save([dir_data,'\Sym1_',FilNam,'.mat'],'Sym_1')
    %DAtaa = dlmread('/Users/erezaei/Google Drive (erezaei@stanford.edu)/SU_Submission/SNI_Retreat_2018/Analy_180503/ac/acs-8/ac-08-87.txt','',1,0);
    X=xlsread('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/dpy-5/Analysis-dpy5-20181008/Length_1.xlsx');

    
    Data=flipud(DAtaa);
    if length(Data)~= 256;disp('Length Data is not 256??');end
    %% Height image; values of XData and YData in imshow needs to be set manually
    hFig =figure;
    subplot(2,1,1)
    heatMap = imresize(Data,[250 1000]);
    imshow(heatMap, [],'XData',[0 10], 'YData', [0 2.5]);
    axis on;
    colormap (hot(256));
    colorbar;
    set(gca,'FontSize',24)
    title('Height image')
    xlabel('\mum','FontSize',24);ylabel('\mum','FontSize',24)
    set(hFig, 'Position', [900 50 900 900])
    set(gcf,'Units','normal');%set(gca,'Position',[0.5 0.4 .84 0.88])
    %% Ploting each single scan line; calculating the annuli width on each line
    subplot(2,1,2)
    %figure
    NN=1;
    MM=2;
    for i=1:length(Data(:,1))
        clear d
        Y=Data(i,:);
        plot(X,Y,'Linewidth',1.5)
        hold on
        N=smooth(Y);
        TF1 = islocalmin(N, 'MinProminence',6);
        ind = find(TF1==1);
        if isempty(ind)
            disp('emptyy')
        else
            Xtarget = X(ind);
            
            L_Xtarg=length(Xtarget);
            for ll=1:L_Xtarg-1
                if ll==1
                    Xtarget = X(ind);
                    Ytarget = Y(ind);
                else
                    Xtarget = X(ind+1);
                    Ytarget = Y(ind+1);
                end
                %ann_w_03(i,ll)=Xtarget(L_Xtarg-ll+1)-Xtarget(L_Xtarg-ll);
                xx = [Xtarget(L_Xtarg-ll) Xtarget(L_Xtarg-ll+1)];
                yy = [Ytarget(L_Xtarg-ll) Ytarget(L_Xtarg-ll+1)];
                pl = line(xx,yy);
                n=round((ind(L_Xtarg-ll+1)-ind(L_Xtarg-ll))/2)+1;
                y = linspace(Ytarget(L_Xtarg-ll),Ytarget(L_Xtarg-ll+1),n);
                x = linspace(Xtarget(L_Xtarg-ll), Xtarget(L_Xtarg-ll+1),n);
                plot(x(round(n/2)),y(round(n/2)),'r*','markersize',8)
                
                ind_mid=round((ind(L_Xtarg-ll+1)-ind(L_Xtarg-ll))/2)+ind(L_Xtarg-ll);
                
                
                Furw = [x(round(n/2))*1000,y(round(n/2));X(ind_mid)*1000,Y(ind_mid)];
                d(ll) = pdist(Furw,'euclidean');
                if ll==1
                    Fur(L_Xtarg)=d(ll);
                elseif ll >1
                    Fur(L_Xtarg-ll+1)=(d(ll)+d(ll-1))/2;
                end
                Fur(1)=d(ll);
                
                An(NN,1)=Xtarget(L_Xtarg-ll+1)-Xtarget(L_Xtarg-ll);
                AF(NN,1)=An(NN,1)/d(ll)*1000;
                if AF(NN,1)>120
                    AF(NN,1)=nan;
                    disp([An(NN,1) d(ll)])
                end
                NN=NN+1;
                
            end
            Lengh_Fu(1)=0;
            Lengh_Fu(MM)=length(Fur);
            BB=sum(Lengh_Fu);
            AA=1+sum(Lengh_Fu(1:MM-1));
            Fu(AA:BB)=Fur';
            MM=MM+1;
            
            set(gca,'FontSize',24)
            xlabel('\mum','FontSize',24);ylabel('H (nm)','FontSize',24)
            save([dir_data,'/An_',FilNam,'.mat'],'An')
            save([dir_data,'/Fu_',FilNam,'.mat'],'Fu')
            save([dir_data,'/AF_',FilNam,'.mat'],'AF')
        end
    end
end