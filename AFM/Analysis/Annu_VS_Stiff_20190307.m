clc;clear;close all
%% Loading Stiffness and Annuli width for each of dpy-5 rol-6 and N2 genotypes from their DMT floder
% dpy15=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/dpy-5/Analysis-dpy5-20181008/Mechanics-dpy-20190208/dpy-DMT/Stif_Annu15_dpy.mat');
% N215=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT/Stif_Annu15_N2.mat');
% rol15=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT/Stif_Annu15_rol.mat');
dpy15=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/dpy-5/Analysis-dpy5-20181008/Mechanics-dpy-20190208/dpy-DMT/DMT_filtered/Stif_Annu15_dpyN.mat');
N215=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT/N2_DMT_Filtered/Stif_Annu15_N2.mat');
rol15=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT/rol_DMT_filtered/Stif_Annu15_rol.mat');
N22=struct2cell(N215);Stif_Annu15_N2=cell2mat(N22);
rol6=struct2cell(rol15);Stif_Annu15_rol=cell2mat(rol6);
dpy5=struct2cell(dpy15);Stif_Annu15_dpy=cell2mat(dpy5);
%%%%%%%%%%
% dpy40=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/dpy-5/Analysis-dpy5-20181008/Mechanics-dpy-20190208/dpy-DMT/Stif_Annu40_dpy.mat');
% N240=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT/Stif_Annu40_N2.mat');
% rol40=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT/Stif_Annu40_rol.mat');
dpy40=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/dpy-5/Analysis-dpy5-20181008/Mechanics-dpy-20190208/dpy-DMT/DMT_filtered/Stif_Annu40_dpyN.mat');
N240=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT/N2_DMT_Filtered/Stif_Annu40_N2.mat');
rol40=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT/rol_DMT_filtered/Stif_Annu40_rol.mat');
N22=struct2cell(N240);Stif_Annu40_N2=cell2mat(N22);
rol6=struct2cell(rol40);Stif_Annu40_rol=cell2mat(rol6);
dpy5=struct2cell(dpy40);Stif_Annu40_dpy=cell2mat(dpy5);
%%%%%%%%%%
% dpy60=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/dpy-5/Analysis-dpy5-20181008/Mechanics-dpy-20190208/dpy-DMT/Stif_Annu60_dpy.mat');
% N260=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT/Stif_Annu60_N2.mat');
% rol60=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT/Stif_Annu60_rol.mat');
dpy60=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/dpy-5/Analysis-dpy5-20181008/Mechanics-dpy-20190208/dpy-DMT/DMT_filtered/Stif_Annu60_dpyN.mat');
N260=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT/N2_DMT_Filtered/Stif_Annu60_N2.mat');
rol60=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT/rol_DMT_filtered/Stif_Annu60_rol.mat');
N22=struct2cell(N260);Stif_Annu60_N2=cell2mat(N22);
rol6=struct2cell(rol60);Stif_Annu60_rol=cell2mat(rol6);
dpy5=struct2cell(dpy60);Stif_Annu60_dpy=cell2mat(dpy5);
%%%%%%%%%%
% dpy85=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/dpy-5/Analysis-dpy5-20181008/Mechanics-dpy-20190208/dpy-DMT/Stif_Annu85_dpy.mat');
% N285=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT/Stif_Annu85_N2.mat');
% rol85=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT/Stif_Annu85_rol.mat');
dpy85=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/dpy-5/Analysis-dpy5-20181008/Mechanics-dpy-20190208/dpy-DMT/DMT_filtered/Stif_Annu85_dpyN.mat');
N285=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/N2-AUG2018/Analysis-N2-20181008/Mechanics-N2-20190208/N2-DMT/N2_DMT_Filtered/Stif_Annu85_N2.mat');
rol85=load('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/rol-6/Analysis-rol6-20181008/Mechanics-rol-20190208/rol-DMT/rol_DMT_filtered/Stif_Annu85_rol.mat');
N22=struct2cell(N285);Stif_Annu85_N2=cell2mat(N22);
rol6=struct2cell(rol85);Stif_Annu85_rol=cell2mat(rol6);
dpy5=struct2cell(dpy85);Stif_Annu85_dpy=cell2mat(dpy5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FIG=subplot(2,2,1);
plot(Stif_Annu15_N2(:,2),Stif_Annu15_N2(:,1),'r.');hold on
plot(Stif_Annu15_dpy(:,2),Stif_Annu15_dpy(:,1),'b.');hold on
plot(Stif_Annu15_rol(:,2),Stif_Annu15_rol(:,1),'k.');hold off
xlabel('DMT Stiffness (MPa)','FontSize',14);ylabel('Annuli Width (\mum)','FontSize',14)
title('\fontsize{14} {\color{magenta} Filtered 15%}')
axis([0 2 0 4])
lgd=legend('N2 \it (wild-type)','CB61 \it dpy-5(e61)','MT2709 \it rol-6(e187n1270)');
%%%%%%%%%%%
subplot(2,2,2);
plot(Stif_Annu40_N2(:,2),Stif_Annu40_N2(:,1),'r.');hold on
plot(Stif_Annu40_dpy(:,2),Stif_Annu40_dpy(:,1),'b.');hold on
plot(Stif_Annu40_rol(:,2),Stif_Annu40_rol(:,1),'k.');hold off
xlabel('DMT Stiffness (MPa)','FontSize',14);ylabel('Annuli Width (\mum)','FontSize',14)
title('\fontsize{14} {\color{magenta}  Filtered 40%}')
axis([0 2 0 4])

%%%%%%%%%%%
subplot(2,2,3);
plot(Stif_Annu60_N2(:,2),Stif_Annu60_N2(:,1),'r.');hold on
plot(Stif_Annu60_dpy(:,2),Stif_Annu60_dpy(:,1),'b.');hold on
plot(Stif_Annu60_rol(:,2),Stif_Annu60_rol(:,1),'k.');hold off
xlabel('DMT Stiffness (MPa)','FontSize',14);ylabel('Annuli Width (\mum)','FontSize',14)
title('\fontsize{14} {\color{magenta}  Filtered 60%}')
axis([0 2 0 4])

%%%%%%%%%%%
subplot(2,2,4);
plot(Stif_Annu85_N2(:,2),Stif_Annu85_N2(:,1),'r.');hold on
plot(Stif_Annu85_dpy(:,2),Stif_Annu85_dpy(:,1),'b.');hold on
plot(Stif_Annu85_rol(:,2),Stif_Annu85_rol(:,1),'k.');hold off
xlabel('DMT Stiffness (MPa)','FontSize',14);ylabel('Annuli Width (\mum)','FontSize',14)
title('\fontsize{14} {\color{magenta}  Filtered 85%}')
axis([0 2 0 4])

%lgd=legend('N2 \it (wild-type)','CB61 \it dpy-5(e61)','MT2709 \it rol-6(e187n1270)');
set(gca,'FontSize',10)
suptitle('\fontsize{14} {\color{magenta} Cuticle stiffness at different body locations}')
% saveas(FIG,'Stif_Anu15.tiff');
%saveas(FIG,'Filtered_Stif_Anu.tiff');
