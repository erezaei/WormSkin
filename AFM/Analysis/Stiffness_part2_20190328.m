clc;clear;close all
dpy=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/dpy-5/Analysis-dpy5-20181008/Mechanics-dpy-20190208/dpy-DMT');
%dpy=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6OE/rolOE-Analysis/Mechanics-rolOE-20190728/rolOE-DMT/rolOE_DMT_Filtered');
N2=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT');
rol=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT');
%
for Strain=1:3
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
    Loc_15=[];Loc_40=[];Loc_60=[];Loc_85=[];
    n_15=1;n_40=1;n_60=1;n_85=1;
    clear VAR_15 VAR_40 VAR_60 VAR_85 VAR_15_CutOff VAR_40_CutOff VAR_60_CutOff...
        VAR_85_CutOff New_Vect New_Vec_Data New_Vec New_Vec_Dat Vector_Data
    for mm=1:n_Files
        FilNam=Files(mm).name(1:end-4);
        Wor=Files(mm).name(5:6);
        Worm_n =sscanf(Wor,'%d-');
        StartPoint=2427;
%         if Strain==1
%             StartPoint=67;
%         end
        Data_Loc=fullfile(raw_data,Files(mm).name);
        DAtaa = dlmread(Data_Loc,'',StartPoint,0);
        Dat=flipud(DAtaa);
        Loc=Files(mm).name(end-18:end-17);
        Location=str2double(Loc);
        Vector_Data=Dat(:);
        a= Vector_Data >  11;
        b= Vector_Data <  0.01;
        Outliers_num1=numel(a(a>0));
        Outliers_num2=numel(b(b>0));
        Outliers_num=Outliers_num1+Outliers_num2;
        New_Vect=Vector_Data(Vector_Data <10);
        New_Vec_Data=New_Vect(0.01<New_Vect);
        
        if Outliers_num < 0.1* length(Vector_Data)
            if  Location==15
                VAR_15(n_15)=var(New_Vec_Data);
                n_15=n_15+1;
            elseif Location==40
                VAR_40(n_40)=var(New_Vec_Data);
                n_40=n_40+1;
            elseif Location==60
                VAR_60(n_60)=var(New_Vec_Data);
                n_60=n_60+1;
            else
                VAR_85(n_85)=var(New_Vec_Data);
                n_85=n_85+1;
            end
        end
    end
    std_15 = std(VAR_15);std_40 = std(VAR_40);std_60 = std(VAR_60);std_85 = std(VAR_85);
    mean_15 = mean(VAR_15); mean_40 = mean(VAR_40);mean_60 = mean(VAR_60);mean_85 = mean(VAR_85);
    zFactor = 3; % or whatever you want.
    outlie_15 = abs(VAR_15-mean_15) > (zFactor * std_15);
    VAR_15_CutOff=VAR_15(find(~outlie_15));
    
    outlie_40 = abs(VAR_40-mean_40) > (zFactor * std_40);
    VAR_40_CutOff=VAR_40(find(~outlie_40));
    
    outlie_60 = abs(VAR_60-mean_60) > (zFactor * std_60);
    VAR_60_CutOff=VAR_60(find(~outlie_60));
    
    outlie_85 = abs(VAR_85-mean_85) > (zFactor * std_85);
    VAR_85_CutOff=VAR_85(find(~outlie_85));
    for mm=1:n_Files
        FilNam=Files(mm).name(1:end-4);
        Wor=Files(mm).name(5:6);
        Worm_n =sscanf(Wor,'%d-');
        Data_Loc=fullfile(raw_data,Files(mm).name);
        DAtaa = dlmread(Data_Loc,'',2427,0);
        Dat=flipud(DAtaa);
        Loc=Files(mm).name(end-18:end-17);
        Location=str2double(Loc);
        Vector_Dat=Dat(:);
        New_Vec=Vector_Dat(Vector_Dat <10);
        New_Vec_Dat=New_Vec(0.01<New_Vec);
        %
        if  Location==15 && ismember(var(New_Vec_Dat),VAR_15_CutOff)
            Loc_15=[Loc_15; New_Vec_Dat];
        elseif Location==40 && ismember(var(New_Vec_Dat),VAR_40_CutOff)
            Loc_40=[Loc_40; New_Vec_Dat];
        elseif Location==60 && ismember(var(New_Vec_Dat),VAR_60_CutOff)
            Loc_60=[Loc_60; New_Vec_Dat];
        elseif Location==85 && ismember(var(New_Vec_Dat),VAR_85_CutOff)
            Loc_85=[Loc_85; New_Vec_Dat];
        end
    end
    std_15 = std(Loc_15);std_40 = std(Loc_40);std_60 = std(Loc_60);std_85 = std(Loc_85);
    mean_15 = mean(Loc_15); mean_40 = mean(Loc_40);mean_60 = mean(Loc_60);mean_85 = mean(Loc_85);
    zFactor = 3; % or whatever you want.
    outlie_15 = abs(Loc_15-mean_15) > (zFactor * std_15);
    Loc_15_CutOff=Loc_15(find(~outlie_15));
    
    outlie_40 = abs(Loc_40-mean_40) > (zFactor * std_40);
    Loc_40_CutOff=Loc_40(find(~outlie_40));
    
    outlie_60 = abs(Loc_60-mean_60) > (zFactor * std_60);
    Loc_60_CutOff=Loc_60(find(~outlie_60));
    
    outlie_85 = abs(Loc_85-mean_85) > (zFactor * std_85);
    Loc_85_CutOff=Loc_85(find(~outlie_85));
    
    
    figure
    subplot(1,4,1)
    x=logspace(-1,1,40);
    histogram(Loc_15_CutOff,x); % create the plot
    set(gca,'xscale','log')
    set(gca,'FontSize',18)
    xlabel('DMT (MPa)','FontSize',24);ylabel('Number of pixels','FontSize',24)
    title([sprintf('   %s15',Genotype), '% mean',num2str(mean(Loc_15_CutOff),'%4.2f'),'\pm',num2str(std(Loc_15_CutOff),'%4.2f')])
    subplot(1,4,2)
    x=logspace(-1,1,40);
    histogram(Loc_40_CutOff,x); % create the plot
    set(gca,'xscale','log')
    set(gca,'FontSize',18)
    xlabel('DMT (MPa)','FontSize',24);ylabel('Number of pixels','FontSize',24)
    title([sprintf(' .  %s40',Genotype), '% mean',num2str(mean(Loc_40_CutOff),'%4.2f'),'\pm',num2str(std(Loc_40_CutOff),'%4.2f')])
    subplot(1,4,3)
    x=logspace(-1,1,40);
    histogram(Loc_60_CutOff,x); % create the plot
    set(gca,'xscale','log')
    set(gca,'FontSize',18)
    xlabel('DMT (MPa)','FontSize',24);ylabel('Number of pixels','FontSize',24)
    title([sprintf(' .  %s60',Genotype), '% mean',num2str(mean(Loc_60_CutOff),'%4.2f'),'\pm',num2str(std(Loc_60_CutOff),'%4.2f')])
    subplot(1,4,4)
    x=logspace(-1,1,40);
    histogram(Loc_85_CutOff,x); % create the plot
    set(gca,'xscale','log')
    set(gca,'FontSize',18)
    xlabel('DMT (MPa)','FontSize',24);ylabel('Number of pixels','FontSize',24)
    title([sprintf('   %s85',Genotype), '% mean',num2str(mean(Loc_85_CutOff),'%4.2f'),'\pm',num2str(std(Loc_85_CutOff),'%4.2f')])
end