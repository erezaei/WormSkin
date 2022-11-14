%The Wilcoxon rank sum test is a nonparametric test for two populations when samples are independent.
% The result h = 1 indicates a rejection of the null hypothesis  of equal medians, and h = 0 indicates a failure to reject the null hypothesis at the 5% significance level.
clc;clear;close all
dpy=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/2022/Genipin_dataFile');
%N2=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT');
%rol=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT');
%GN=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/2021-AFM-Bruker/GN1029/Data_Files_GN1029_20211216');
zFactor = 3; % or whatever you want (for removing outliers data)
for Strain=1
    clear Locs indd outliers 
    if Strain==1
        raw_data=dpy;
        Genotype=raw_data(end-6:end-4);
    elseif Strain==2
        raw_data=N2;
        Genotype=raw_data(end-5:end-4);
        
    elseif Strain==3
        raw_data=GN;
        Genotype=raw_data(end-14:end-13);
    else
        raw_data=rol;
        Genotype=raw_data(end-6:end-4);
    end
    Files=dir([raw_data,'/*.txt']);
    n_Files=length(dir(fullfile(raw_data,'*.txt')));
    %     X=xlsread('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/N2-AUG2018/Analysis-N2-20181008/Length_1.xlsx');
    clear Vector_stiff_mean
    NN=1;MM=1;
    Exper = {}
    for ij=1:n_Files
        clear An Fu Fur Lengh_Fu DMT St St_An  New_Vect_Data  Vector_Data_CutOff
        FilNam=Files(ij).name(1:end-4);
        Wor=Files(ij).name(11:12);
        Worm_n =sscanf(Wor,'%d-');
        
        Loc=Files(ij).name(end-21:end-20);
        Location=Loc;%str2double(Loc);
        StartPoint=2537;
        if Strain==3
        StartPoint=2493;
        end
        
        
        Data_Loc=fullfile(raw_data,Files(ij).name);
        DAtaa = dlmread(Data_Loc,'',StartPoint,0);
        Data=flipud(DAtaa);
        B = reshape(Data,[],1);
        New_Vect=B(B <10);
        New_Vec_Data=New_Vect(0.1<New_Vect);
        Mean_Data=mean(New_Vec_Data);
        stdDev = std(New_Vec_Data);
        outliers = abs(New_Vec_Data-Mean_Data) > (zFactor * stdDev);
        ind = find(~outliers);
        Vector_Data_CutOff=New_Vec_Data(ind);
        Stf_mean(ij,Strain)=mean(Vector_Data_CutOff);
        Loca(ij,Strain)=1;%Location;
        Exper(ij,:) = {Location};
        Number_of_files(Strain)=n_Files;
    end
    Strain_stiff_mean=Stf_mean(1:n_Files,Strain);
    Strain_Loc=Loca(:,Strain);
    Mean_Da=mean(Strain_stiff_mean);
    stdD = std(Strain_stiff_mean);
    outliers = abs(Strain_stiff_mean-Mean_Da) > (zFactor * stdD);
    indd = find(~outliers);
    Vector_stiff_mean=Strain_stiff_mean(indd);
    Locs=Strain_Loc(indd);
    ress(Strain,:)=[mean(Vector_stiff_mean), std(Vector_stiff_mean), std(Vector_stiff_mean)/sqrt(length(Vector_stiff_mean)), n_Files, length(Vector_stiff_mean)];
    %Stiff_mean(1:length(Vector_stiff_mean),Strain)=Vector_stiff_mean;
    Stiff_mean(1:length(Vector_stiff_mean),2*Strain-1:2*Strain)=[Vector_stiff_mean, Locs];

end
Stiff_mean(Stiff_mean == 0) = NaN;
field1 = 'f1';  value1 = Stf_mean;
field2 = 'f2';  value2 = Exper;

s = struct('test',Exper,'Stiff',Stf_mean)
%[p_dpy,h_dpy,stats_dpy] = ranksum(Stiff_mean(:,1),Stiff_mean(:,2))
%[p_rol,h_rol,stats_rol] = ranksum(Stiff_mean(:,3),Stiff_mean(:,2))
%T = array2table(ress,'VariableNames',{'Mean_MPa','std','SEM', 'Number_images','N_img_after'},'RowNames',{'dpy' 'N2' 'GN' 'rol'})
%writetable(T,'Mean_Stif.csv','Delimiter',',','QuoteStrings',true)
%TTT = array2table(Stf_mean,Exper)
%writetable(TTT,'Cuticle_Stif2022.csv')