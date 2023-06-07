%%
function X=nlfitsolver(simdata,los)

t=simdata.tpost;

[num1, num2, ~]=size(simdata.slip);%number of the valid paches
num=num1*num2;

%set search bounds for parameters
lb=[zeros(num,1)+0;zeros(num,1)+0;120;90;0];%low boundary
ub=[zeros(num,1)+20;zeros(num,1)+1;180;150;20];%up boundary
A0=lb+rand(num*2+3,1).*(ub-lb);%random initial values of parameters

options = optimoptions('lsqcurvefit','tolfun',1e-50,'MaxIter',1000);
tic
[X.A,X.resnorm,X.residual,X.exitflag,X.output,X.lambda,X.jacobian]=lsqcurvefit(@modelfun,A0,t,los,lb,ub,options);
toc
end


