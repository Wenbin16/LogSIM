function plot_spatio_temporal_slip(X,figurename)

load matdir/simdata
t=simdata.tpost;
A=X.A;
n=length(A);

A1=A(1+(n-3)/2:(n-3));A2=A(end);
for i=1:(n-3)/2
    pslip(:,i)=A1(i).*log(1+t./A2);% p:prediction
end
coslip=A(1:(n-3)/2);

simslip=simdata.slip;
[m n num]=size(simslip);
coslip=reshape(coslip,n,m)';

inslip=simdata.slip1;
incoslip=simdata.coslip;
invslip=zeros(m,n,num);
%% plot input slip
load matdir/slipcolor

figure;
ax1=subaxis(3,12,1,'SpacingVert',0.005,'SpacingHorizontal',0.002,'MR',0.1);
imagesc(incoslip);
colormap(ax1,flipud(hot));caxis([0 10])
text(1,1.5,'coseismic slip','FontSize',10);
yt={'12';'28';'42'};
set(gca,'xticklabel',[]);
set(gca,'ytick',3:3:9);
set(gca,'yticklabel',yt);
ylabel('Along-Dip [km]','fontsize',10);

for k=2:size(invslip,3)+1
temp=reshape(inslip(k-1,:),n,m);
invslip(:,:,k-1)=temp'; 
ax11=subaxis(3,12,k,'SpacingVert',0.005,'SpacingHorizontal',0.002,'MR',0.1);
imagesc(invslip(:,:,k-1));colormap(ax11,slipcolor);caxis([0 2])
hold on;contour(incoslip,4,'linecolor','k');hold off;
text(1,1.5,[num2str(t(k-1)),' days'],'FontSize',10);

if k>24
xlabel('Along-Strike [km]','fontsize',10); 
xt={'12';'28';'42'};
set(gca,'xtick',3:3:9);
set(gca,'xticklabel',xt);
else
set(gca,'xticklabel',[]);
end
if k==1 || k==13 || k==15
ylabel('Along-Dip [km]','fontsize',10);
yt={'12';'28';'42'};
set(gca,'ytick',3:3:9);
set(gca,'yticklabel',yt);
else
set(gca,'yticklabel',[]);
end
end

%%plot output slip
ax2=subaxis(3,12,13,'SpacingVert',0.005,'SpacingHorizontal',0.002,'MR',0.1);
imagesc(coslip);
colormap(ax2,flipud(hot));caxis([0 10])
text(1,1.5,'coseismic slip','FontSize',10);
yt={'12';'28';'42'};
set(gca,'xticklabel',[]);
set(gca,'ytick',3:3:9);
set(gca,'yticklabel',yt);
ylabel('Along-Dip [km]','fontsize',10);

for k=2:size(invslip,3)+1
temp=reshape(pslip(k-1,:),n,m);
invslip(:,:,k-1)=temp'; 
ax11=subaxis(3,12,k+12,'SpacingVert',0.005,'SpacingHorizontal',0.002,'MR',0.1);
imagesc(invslip(:,:,k-1));colormap(ax11,slipcolor);caxis([0 2])
hold on;contour(coslip,4,'linecolor','k');hold off;
text(1,1.5,[num2str(t(k-1)),' days'],'FontSize',10);

set(gca,'xticklabel',[]);

set(gca,'yticklabel',[]);
end

%%plot diffslip between sim and pre slip
ax3=subaxis(3,12,24+1,'SpacingVert',0.005,'SpacingHorizontal',0.002,'MR',0.1);
imagesc(simdata.coslip-coslip);
colormap(ax3,parula);caxis([-5 5])
Rstd=std2(simdata.coslip-coslip)*100;
text(1,3,['RMS: ',num2str(Rstd,3),'cm'],'FONTSIZE',8)
text(1,1.5,'coseismic','FontSize',10);

xt={'12';'28';'42'};
yt={'12';'28';'42'};
set(gca,'xtick',3:3:9);
set(gca,'xticklabel',xt);
set(gca,'ytick',3:3:9);
set(gca,'yticklabel',yt);
ylabel('Along-Dip [km]','fontsize',10);

for k=2:size(invslip,3)+1
Diff(:,:,k-1)=simslip(:,:,k-1)-invslip(:,:,k-1);
ax3=subaxis(3,12,k+24,'SpacingVert',0.005,'SpacingHorizontal',0.002,'MR',0.1);
imagesc(Diff(:,:,k-1));colormap(ax3,parula);caxis([-5 5])
text(1,1.5,[num2str(t(k-1)),' days'],'FontSize',10);
xt={'12';'28';'42'};
set(gca,'xtick',3:3:9);
set(gca,'xticklabel',xt);
if k==6
xlabel('Along-Strike [km]','fontsize',10); 
end
if k>1
set(gca,'yticklabel',[]);
end

RSTASNstd(k-1)=std2(Diff(:,:,k-1))*100;
text(1,3,['RMS: ',num2str(RSTASNstd(k-1),2),' cm'],'FONTSIZE',8)
end
set(gcf,'color','w');
set(gcf,'Position',[1600 450 1600 450]);
h=colorbar(ax1,'east');
title(h,'m','fontsize',10);
set(h,'position',[0.84 0.64 0.01 0.2])
h=colorbar(ax11,'east');
title(h,'m','fontsize',10);
set(h,'position',[0.84 0.36 0.01 0.2])
h=colorbar(ax3,'east');
title(h,'m','fontsize',10);
set(h,'position',[0.84 0.08 0.01 0.2])

% h=colorbar(ax1,'east');
% title(h,'m','fontsize',10);
% set(h,'position',[0.84 0.72 0.01 0.15])
% h=colorbar(ax11,'east');
% title(h,'m','fontsize',10);
% set(h,'position',[0.84 0.52 0.01 0.15])
% h=colorbar(ax3,'east');
% title(h,'m','fontsize',10);
% set(h,'position',[0.84 0.32 0.01 0.15])
% h=colorbar(ax4,'east');
% title(h,'m','fontsize',10);
% set(h,'position',[0.84 0.12 0.01 0.15])
set(gcf,'PaperPositionMode','auto');
print('-depsc','-r300',['figure/',figurename,'.eps']);
print('-djpeg','-r300',['figure/',figurename,'.jpg']);
%% plot diffhistograms between sim and pre slip
% subaxis(3,12,36+1,'SpacingVert',0.08,'SpacingHorizontal',0.002,'MR',0.1);
% temp=Diff(:,:,1)*100;
% histogram(temp(:),10,'Normalization','probability');
% text(-4.5,0.9,'coseismic slip','FontSize',10);
% ylabel('Frequency','fontsize',10);
% ylim([0 1])
% xlim([-5 5])
% xt={'-3';'0';'-3'};
% set(gca,'xtick',-3:3:3);
% set(gca,'xticklabel',xt);
% 
% for k=2:size(invslip,3)+1
% temp=Diff(:,:,k-1)*100;
% subaxis(3,12,k+36,'SpacingVert',0.08,'SpacingHorizontal',0.002,'MR',0.1);
% histogram(temp(:),10,'Normalization','probability');
% text(-4.5,0.9,[num2str(t(k-1)),'d'],'FontSize',10);
% 
% ylim([0 1])
% xlim([-5 5])
% if k==6
% xlabel('Residuals [cm]','fontsize',10); 
% end
% if k>1
% set(gca,'yticklabel',[]);
% end
% xt={'-3';'0';'-3'};
% set(gca,'xtick',-3:3:3);
% set(gca,'xticklabel',xt);
% end
% %%
% set(gcf,'PaperPositionMode','auto');
% print('-depsc','-r300',['figure/',figurename,'.eps']);
% print('-djpeg','-r300',['figure/',figurename,'.jpg']);
end