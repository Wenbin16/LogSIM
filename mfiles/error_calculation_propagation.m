function error_calculation_propagation(X,fig)
%%confidence 95%
conf = nlparci(X.A,X.residual,'jacobian',X.jacobian);
%%convariation
N=full(X.jacobian'*X.jacobian);
Xcovariation= full(pinv(N)*var(X.residual));
%%
Xvar=diag(Xcovariation);
Xcovar=Xcovariation(end,1:end-1);
X.Xvar=Xvar;
X.Xcovar=Xcovar;
X.Xcovariation=Xcovariation;
X.conf=conf;

save(fig,'X') 

%%
load matdir/simdata
[m,n]=size(simdata.coslip);
imagesc(sqrt(reshape(Xvar(1+m*n:2*m*n),n,m))');
h=colorbar;
title(h,'m')
title('STDs of Amplitudes')
set(gcf,'color','w');
set(gcf,'Position',[700 600 700 600]);
set(gcf,'PaperPositionMode','auto');
print('-depsc',['figure/STD',fig,'.eps']);
print('-djpeg',['figure/STD',fig,'.jpg']);
%%
figure;
m=12;n=10;
imagesc(sqrt(reshape(Xvar(1:m*n),n,m))');
coslip=X.A(1:m*n)';
co_slip=reshape(coslip,n,m)';
h=colorbar;
hold on;
contour(co_slip,5,'linecolor','c');hold off;
title(h,'m')
title('STDs of Coseismic slip')
set(gcf,'color','w');
set(gcf,'Position',[700 600 700 600]);
set(gcf,'PaperPositionMode','auto');
print('-depsc',['figure/STDCo',fig,'.eps']);
print('-djpeg',['figure/STDCo',fig,'.jpg']);

end


