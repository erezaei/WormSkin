% AFM data analysis by Ehsan Rezaei
% Updated May 18, 2022
%
clc;clear;close all

%dir_data=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/2022/AFM_DataFiles');
dir_data=('/Users/Ehsan/Documents/Analysis-AFM-June2022/AFM_DataFiles');
%[numbers, text, raw] = xlsread('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/2022/Ehsan_AFM_Meta.xlsx'); % be careful in which Folder saved.
%xlsStruct=table2struct( readtable('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/2022/Ehsan_AFM_Meta.xlsx'));
xlsStruct=table2struct( readtable('/Users/Ehsan/Documents/Analysis-AFM-June2022/Ehsan_AFM_Meta.xlsx'));
Id_cell={xlsStruct.ID};
Img_Grade=[xlsStruct.ImageGrade]';
WormStrain={xlsStruct.Strain};
WormNumber={xlsStruct.Worm_};
Location={xlsStruct.Location};



Files=dir([dir_data,'/*.txt']);
n_Files=length(dir(fullfile(dir_data,'*.txt')));
for ij=1:n_Files
    img_ID=Files(ij).name(1:6);
    if Img_Grade(ij) > 7
        fprintf('Image quality of %s is too low.\n',img_ID);
    else
        disp(img_ID)
        clear An Fu Fur Lengh_Fu Annuli_mean Annuli_std Annuli_count Furrow_mean Furrow_std Furrow_count MEAN STDD SIZ

        csv_File=fullfile(dir_data,Files(ij).name);
        Height = flipud(dlmread(csv_File,'',[2471 0 2534 255] ));
        DMT    = flipud(dlmread(csv_File,'',[2537 0 2600 255] ));
        % ========================= Analysis ======================================
        X=linspace(0,10,256)';

        %% Height image; values of XData and YData in imshow needs to be set manually
%         hFig =figure;
%         subplot(3,1,1)
%         heatMap = imresize(Height,[250 1000]);
%         imshow(heatMap, [],'XData',[0 10], 'YData', [0 2.5]);
%         axis on;
%         colormap (hot(256));
%         colorbar;
%         clim([-100 100])
%         set(gca,'FontSize',24)
%         title('Height image')
%         xlabel('\mum','FontSize',24);ylabel('\mum','FontSize',24)
%         set(hFig, 'Position', [900 50 900 900])
%         set(gcf,'Units','normal');%set(gca,'Position',[0.5 0.4 .84 0.88])
        %% Ploting each single scan line; calculating the annuli width on each line
%         subplot(3,1,2)
        %figure
        NN=1;
        MM=2;
        for i=1:length(Height(:,1))
            clear d
            Y=Height(i,:);
%             plot(X,Y,'Linewidth',1.5)
%             hold on
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
%                     pl = line(xx,yy);
                    n=round((ind(L_Xtarg-ll+1)-ind(L_Xtarg-ll))/2)+1;
                    y = linspace(Ytarget(L_Xtarg-ll),Ytarget(L_Xtarg-ll+1),n);
                    x = linspace(Xtarget(L_Xtarg-ll), Xtarget(L_Xtarg-ll+1),n);
%                     plot(x(round(n/2)),y(round(n/2)),'r*','markersize',8)

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
                    NN=NN+1;
                end
                Lengh_Fu(1)=0;
                Lengh_Fu(MM)=length(Fur);
                BB=sum(Lengh_Fu);
                AA=1+sum(Lengh_Fu(1:MM-1));
                Fu(AA:BB)=Fur';
                MM=MM+1;

%                 set(gca,'FontSize',24)
%                 xlabel('\mum','FontSize',24);ylabel('H (nm)','FontSize',24)

            end
        end
        %% DMT image
%         subplot(3,1,3)
%         heatMap = imresize(DMT,[250 1000]);
%         imshow(heatMap, [],'XData',[0 10], 'YData', [0 2.5]);
%         axis on;
%         colormap (hot(256));
%         colorbar;
%         set(gca,'FontSize',24)
%         title('DMT')
%         xlabel('\mum','FontSize',24);ylabel('\mum','FontSize',24)
%         %set(hFig, 'Position', [900 50 900 900])
        %set(gcf,'Units','normal');%set(gca,'Position',[0.5 0.4 .84 0.88])
        %% DMT Analysis
        %Vector_Data((((ij-1)*16384)+1):(ij*16384))=DMT(:);
        Vector_Data=DMT(:);
        New_Vect=Vector_Data(Vector_Data<10);
        New_Vec_Data=New_Vect(0.01<New_Vect);
        stdDev = std(New_Vec_Data); % Compute standard deviation
        meanValue = mean(New_Vec_Data); % Compute mean
        zFactor = 3; % or whatever you want.
        outliers = abs(New_Vec_Data-meanValue) > (zFactor * stdDev);
        ind = find(~outliers);
        Vector_Data_CutOff=New_Vec_Data(ind);

        %SEM=STDD/sqrt(SIZ);

        %% Obtaining Values as Results
        Annuli_mean=mean(An);
        Annuli_std =std(An);
        Annuli_count= length(An);
        Furrow_mean= mean(Fu);
        Furrow_std= std(Fu);
        Furrow_count= length(Fu);

        STDD=std(Vector_Data_CutOff);
        MEAN=mean(Vector_Data_CutOff);
        SIZ=max(size(Vector_Data_CutOff));
        %data_row=[Annuli_mean Annuli_std Annuli_count Furrow_mean Furrow_std Furrow_count...
        %   MEAN STDD SIZ];
        U={ img_ID Annuli_mean Annuli_std Annuli_count Furrow_mean Furrow_std Furrow_count MEAN STDD SIZ Img_Grade(ij) ...
            WormStrain(ij) WormNumber(ij) Location(ij)};
        t = cell2table(U, "VariableNames",{'ID','Annuli_mean','Annuli_std','Annuli_count',' Furrow_mean',' Furrow_std',' Furrow_count',' DMT_mean',...
            ' DMT_std',' DMT_data', 'Img Quality' 'WormStrain' 'Worm#' 'Location'});
        writetable(t,'Results.xlsx',"WriteMode","append","AutoFitWidth",false);
    end
end