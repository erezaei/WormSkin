clc;clear;close all
dpy=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/dpy-5/Analysis-dpy5-20181008/txt-files');
N2=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/N2-AUG2018/Analysis-N2-20181008/txt-files');
rol=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/rol-6/Analysis-rol6-20181008/txt-files');
X=xlsread('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/N2-AUG2018/Analysis-N2-20181008/Length_1.xlsx');
zFactor=3;
for Strain=1:3
    clear Locs indd
    if Strain==1
        raw_data=dpy;
        Genotype=raw_data(end-22:end-20);
    elseif Strain==2
        raw_data=N2;
        Genotype=raw_data(end-20:end-19);
    else
        raw_data=rol;
        Genotype=raw_data(end-22:end-20);
    end
    Files=dir([raw_data,'/*.txt']);
    n_Files=length(dir(fullfile(raw_data,'*.txt')));
    
    for ij=1:n_Files
        clear An Fu Fur Lengh_Fu
        FilNam=Files(ij).name(1:end-4);
        Wor=Files(ij).name(5:6);
        Worm_n =sscanf(Wor,'%d-');
        Loc=Files(ij).name(end-18:end-17);
        Location=str2double(Loc);
        Data_Loc=fullfile(raw_data,Files(ij).name);
        DAtaa = dlmread(Data_Loc,'',1,0);
        
        % ========================= Analysis ======================================
        Data=flipud(DAtaa);
        
        for i=1:length(Data(:,1))
            NN=1;
            Y=Data(i,:);
            N=smooth(Y);
            TF1 = islocalmin(N, 'MinProminence',6);
            ind = find(TF1==1);
            if isempty(ind)
                disp('No Furrow recognized')
            else
                Xtarget = X(ind);
                
                L_Xtarg=length(Xtarget);
                for ll=1:L_Xtarg-1
                    if ll==1
                        Xtarget = X(ind);
                        %    Ytarget = Y(ind);
                    else
                        Xtarget = X(ind+1);
                        %    Ytarget = Y(ind+1);
                    end
                    %ind_mid=round((ind(L_Xtarg-ll+1)-ind(L_Xtarg-ll))/2)+ind(L_Xtarg-ll);
                    An(i,NN)=Xtarget(L_Xtarg-ll+1)-Xtarget(L_Xtarg-ll);
                    NN=NN+1;
                end
            end
        end
        B = reshape(An,[],1);
        New_Vect=B(B <3.5);
        New_Vec_Data=New_Vect(0.2<New_Vect);
        Mean_Data=mean(New_Vec_Data);
        stdDev = std(New_Vec_Data);
        outliers = abs(New_Vec_Data-Mean_Data) > (zFactor * stdDev);
        ind = find(~outliers);
        Vector_Data_CutOff=New_Vec_Data(ind);
        Stf_mean(ij,Strain)=mean(Vector_Data_CutOff);
        Loca(ij,Strain)=Location;
        Number_of_files(Strain)=n_Files;
    end
    Strain_An_mean=Stf_mean(:,Strain);
    Strain_Loc=Loca(:,Strain);
    Mean_Da=mean(Strain_An_mean);
    stdD = std(Strain_An_mean);
    outliers = abs(Strain_An_mean-Mean_Da) > (zFactor * stdD);
    indd = find(~outliers);
    Vector_An_mean=Strain_An_mean(indd);
    Locs=Strain_Loc(indd);
    ress(Strain,:)=[mean(Vector_An_mean), std(Vector_An_mean), std(Vector_An_mean)/sqrt(length(Vector_An_mean)), n_Files, length(Vector_An_mean)];
    An_mean(1:length(Vector_An_mean),2*Strain-1:2*Strain)=[Vector_An_mean, Locs];

end
An_mean(An_mean == 0) = NaN;
[p_dpy,h_dpy,stats_dpy] = ranksum(An_mean(:,1),An_mean(:,3))
[p_rol,h_rol,stats_rol] = ranksum(An_mean(:,5),An_mean(:,3))
T = array2table(ress,'VariableNames',{'mean_Annuli_w_um','std','SEM', 'Number_images','N_img_after'},'RowNames',{'dpy' 'N2' 'rol'})
[p__loc_dpy,tbl_loc_dpy,stats_loc_dpy] = kruskalwallis(An_mean(:,1),num2str(An_mean(:,2)),'off')
[p__loc_N2,tbl_loc_N2,stats_loc_N2] = kruskalwallis(An_mean(:,3),num2str(An_mean(:,4)),'off')
[p__loc_rol,tbl_loc_rol,stats_loc_rol] = kruskalwallis(An_mean(:,5),num2str(An_mean(:,6)),'off')

TTT = array2table(An_mean,'VariableNames',{'dpy', 'dpy_Loc', 'N2', 'N2_Loc', 'rol','rol_Loc'})
writetable(TTT,'AnnuliWidth.csv')