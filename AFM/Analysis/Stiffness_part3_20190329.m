clc;clear;close all
global Dat Dat_H FilNam
dpy=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/dpy-5/Analysis-dpy5-20181008/Mechanics-dpy-20190208/dpy-DMT');
%dpy=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6OE/rolOE-Analysis/Mechanics-rolOE-20190728/rolOE-DMT/rolOE_DMT_Filtered');
N2=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT');
rol=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT');
%
dpy_H=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/dpy-5/Analysis-dpy5-20181008/txt-files');%uigetdir;
%dpy_H=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6OE/rolOE-Analysis/Mechanics-rolOE-20190728/rolOE-DMT/rolOE_DMT_Filtered');
N2_H=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/N2-AUG2018/Analysis-N2-20181008/txt-files');%uigetdir;
rol_H=('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/rol-6/Analysis-rol6-20181008/txt-files');%uigetdir;
for Strain=1:1
    if Strain==1
        raw_data=dpy;
        raw_data_H=dpy_H;
        Genotype=raw_data(end-6:end-4);
    elseif Strain==2
        raw_data=N2;
        raw_data_H=N2_H;
        Genotype=raw_data(end-5:end-4);
    else
        raw_data=rol;
        raw_data_H=rol_H;
        Genotype=raw_data(end-6:end-4);
    end
    Files=dir([raw_data,'/*.txt']);
    n_Files=length(dir(fullfile(raw_data,'*.txt')));
    Stiff_15=[];Stiff_40=[];Stiff_60=[];Stiff_85=[];
    An_15=[];An_40=[];An_60=[];An_85=[];
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
        Data_LocH=fullfile(raw_data_H,Files(mm).name);
        Dataa_H = dlmread(Data_LocH,'',1,0);
        Dat_H=flipud(Dataa_H);
        %
        if  Location==15 && ismember(var(New_Vec_Dat),VAR_15_CutOff)
            [Ann, Stiff]=Ann2Stiff(Dat,Dat_H,FilNam);
            Stiff_15=[Stiff_15; Stiff];
            An_15=[An_15; Ann];
        elseif Location==40 && ismember(var(New_Vec_Dat),VAR_40_CutOff)
            [Ann, Stiff]=Ann2Stiff(Dat,Dat_H,FilNam);
            Stiff_40=[Stiff_40; Stiff];
            An_40=[An_40; Ann];
        elseif Location==60 && ismember(var(New_Vec_Dat),VAR_60_CutOff)
            [Ann, Stiff]=Ann2Stiff(Dat,Dat_H,FilNam);
            Stiff_60=[Stiff_60; Stiff];
            An_60=[An_60; Ann];
        elseif Location==85 && ismember(var(New_Vec_Dat),VAR_85_CutOff)
            [Ann, Stiff]=Ann2Stiff(Dat,Dat_H,FilNam);
            Stiff_85=[Stiff_85; Stiff];
            An_85=[An_85; Ann];
        end
    end
    fname = sprintf('Stiff_15_%d.csv',Strain);
    csvwrite(fname,Stiff_15)
    fname = sprintf('Stiff_40_%d.csv',Strain);
    csvwrite(fname,Stiff_40)
    fname = sprintf('Stiff_60_%d.csv',Strain);
    csvwrite(fname,Stiff_60)
    fname = sprintf('Stiff_85_%d.csv',Strain);
    csvwrite(fname,Stiff_85)
    
    fname = sprintf('An_15_%d.csv',Strain);
    csvwrite(fname,An_15)
    fname = sprintf('An_40_%d.csv',Strain);
    csvwrite(fname,An_40)
    fname = sprintf('An_60_%d.csv',Strain);
    csvwrite(fname,An_60)
    fname = sprintf('An_85_%d.csv',Strain);
    csvwrite(fname,An_85)
    
    % figure
    subplot(1,4,1)
    scatter(Stiff_15,An_15,'*');hold on
    set(gca,'FontSize',24)
    xlabel('DMT Stiffness (MPa)','FontSize',24);ylabel('Annuli Width (\mum)','FontSize',24)
    title('15%')
    axis([0 2 0 4])
    lgd=legend({'CB61 \it dpy-5(e61)','N2 (wild-type)','MT2709 \it rol-6(e187n1270)'},'FontSize',18);
    subplot(1,4,2)
    plot(Stiff_40,An_40,'*');hold on
    set(gca,'FontSize',24)
    xlabel('DMT Stiffness (MPa)','FontSize',24);%ylabel('Annuli Width (\mum)','FontSize',24)
    title('40%')
    axis([0 2 0 4])
    subplot(1,4,3)
    plot(Stiff_60,An_60,'*');hold on
    set(gca,'FontSize',24)
    xlabel('DMT Stiffness (MPa)','FontSize',24);%ylabel('Annuli Width (\mum)','FontSize',24)
    title('60%')
    axis([0 2 0 4])
    subplot(1,4,4)
    plot(Stiff_85,An_85,'*');hold on
    set(gca,'FontSize',24)
    xlabel('DMT Stiffness (MPa)','FontSize',24);%ylabel('Annuli Width (\mum)','FontSize',24)
    title('85%')
    axis([0 2 0 4])
    Annu_all=[An_15; An_40; An_60; An_85];
    Stif_all=[Stiff_15; Stiff_40; Stiff_60; Stiff_85];
    [mean(Annu_all) std(Annu_all) mean(Stif_all) std(Stif_all)]
end