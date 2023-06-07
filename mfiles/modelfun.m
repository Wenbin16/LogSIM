function modellos=modelfun(A,t,simdata)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% this function is used to model defo based on parameters A
%% a is the parameters vector
%% t is the n*1 time series epoch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% calculating ST slip
load ./matdir/simdata;
copairs=simdata.co;
int_pairs1=simdata.int1;
int_pairs2=simdata.int2;
% n=floor(length(A)/2);
% a=A(1:n);A1=A(n+1:end-1);A2=A(end);
n=length(A);
rake1=A(end-2);%rate for coslip
rake2=A(end-1);%rate for afterslip
coslip=A(1:(n-3)/2)';
A1=A(1+(n-3)/2:(n-3));A2=A(end);
for i=1:(n-3)/2
slip(:,i)=A1(i).*log(1+t./A2);
end

%%forward los deformation

modellos11=ATQT1Colosforwardmodeling(t,coslip,slip,copairs,rake1,rake2);
modellos12=ATQT1forwardmodeling(t,slip,int_pairs1,rake2);
modellos2=DTQT1forwardmodeling(t,slip,int_pairs2,rake2);

[m,n]=size(modellos11);
modellos11=reshape(modellos11',m*n,1);
[m,n]=size(modellos12);
modellos12=reshape(modellos12',m*n,1);
[m,n]=size(modellos2);
modellos2=reshape(modellos2',m*n,1);
modellos=[modellos11;modellos12;modellos2];
end
