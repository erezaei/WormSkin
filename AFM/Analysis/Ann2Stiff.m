function  [Ann, Stiff]=Ann2Stiff(Dat,Dat_H,FilNam)

X=xlsread('/Users/erezaei/Desktop/SU-Research/AFM_Bruker/Previous/dpy-5/Analysis-dpy5-20181008/Length_1.xlsx');
%% Height image; values of XData and YData in imshow needs to be set manually
% hFigH =figure;
% %subplot(3,1,1)
% heatMapH = imresize(Dat_H,[250 1000]);
% imshow(heatMapH, [],'XData',[0 10], 'YData', [0 2.5]);
% axis on;
% colormap (hot(256));
% colorbar;
% set(gca,'FontSize',24)
% title(['Worm '  num2str( FilNam )])
% xlabel('\mum','FontSize',24);ylabel('\mum','FontSize',24)
% set(hFigH, 'Position', [900 50 900 900])
% set(gcf,'Units','normal');%set(gca,'Position',[0.5 0.4 .84 0.88])
%%%%%%%%%
%subplot(3,1,2)
% heatMap = imresize(Dat,[250 1000]);
% imshow(heatMap, [],'XData',[0 10], 'YData', [0 2.5]);
% axis on;
% colormap (hot(256));
% handleToColorBar=colorbar;
% title(handleToColorBar, 'MPa');
% set(gca,'FontSize',24)
% title('DMT Modulus')
% xlabel('\mum','FontSize',24);ylabel('\mum','FontSize',24)
% %set(hFig, 'Position', [900 50 900 900])
% set(gcf,'Units','normal');%set(gca,'Position',[0.5 0.4 .84 0.88])

%% Ploting each single scan line; calculating the annuli width on each line
NN=1;
for i=1:length(Dat_H(:,1))
    clear d
    Y=Dat_H(i,:);%Mii=min(YD);
%     Y=YD-Mii;
%     YYD=Dat(i,:);Minn=min(YYD);
%     YY=YYD-Minn;
  %  plot(X,Y,'Linewidth',1.5)
%         hold on
%         plot(X,YY/max(YY),'Linewidth',1.5)
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
            Ann(NN,1)=Xtarget(L_Xtarg-ll+1)-Xtarget(L_Xtarg-ll);
            Stiff(NN,1)=mean(Dat(i,(ind(L_Xtarg-ll)+2):(ind(L_Xtarg-ll+1)-2)));
        
            NN=NN+1;
        end
    end
end