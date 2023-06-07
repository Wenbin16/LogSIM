%%
function X=nlinfitsolver1(simdata,los)
t=simdata.tpost;

[num1 num2 num3]=size(simdata.slip);%number of the valid paches
num=num1*num2;

load X
A0=[X.A(1:num);X.A(1+num:2*num);X.A(end-2);X.A(end-1);X.A(end)];

%%coslip 
colim=60;%this value is set empirically
coslip=X.A(1:num);
covar=X.Xvar(1:num);
index1=find(covar>colim);
temp=X.A(1:num);
temp(index1)=1e10;
figure;imagesc(reshape(temp,num2,num1)');

%%afterslip
aftersliplim=1;%this value is set empirically
index2=find(X.Xvar(1+num:2*num)>aftersliplim);
temp=X.A(1+num:2*num);
temp(index2)=100;
figure;imagesc(reshape(temp,num2,num1)');

lb=[zeros(num,1)+0;zeros(num,1)+0;120;90;0];%low boundary
ub=[zeros(num,1)+20;zeros(num,1)+1;180;150;20];%up boundary

%constrain the patches with relative bigger cov.
ub(index1)=0;
ub(index2+num)=0;

options = optimoptions('lsqcurvefit','tolfun',1e-50,'MaxIter',1000)
tic
[X.A,X.resnorm,X.residual,X.exitflag,X.output,X.lambda,X.jacobian]=lsqcurvefit(@modelfun,A0,t,los,lb,ub,options);
toc

end

