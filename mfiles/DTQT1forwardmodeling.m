%FORWARD MODELING WITH sim-TP-slip
function simlos=DTQT1forwardmodeling(t,slip,int_pairs,rake)
%t is the combined time
%t1 is the DT time
%t2 is the DT1 time
%slip is the simulated spatio-temporal slip
%nwidth is the row number 
%nline is the collumn number

load matdir/faultgeos
paches=faultgeos.fault1;
n=length(paches);

% rake=atand(TS_TW_fnnls_D_Slip(2,:)./TS_TW_fnnls_S_Slip(2,:));
% rake(isnan(rake))=0;
depth=paches(:,3);
strike=paches(1,4);%strike angle of fault
dip=paches(1,5);%dip angle of fault
L=paches(1,6)/1000;%paches' length
W=paches(1,7)/1000;%paches' width

%% FOR AT
load matdir/DT1qt.mat 
minlon=min(paches(:,1));
maxlon=max(paches(:,1));
minlat=min(paches(:,2));
maxlat=max(paches(:,2));
midlon=(maxlon-minlon)/2+minlon;
midlat=(maxlat-minlat)/2+minlat;

corner_lon=midlon-50*1000/90*8.3333333e-04;
corner_lat=midlat+50*1000/90*8.3333333e-04;

res_lon=8.3333333e-04*200/90;
res_lat=8.3333333e-04*200/90;

fault_lon=(paches(:,1)-corner_lon)./res_lon.*0.2;
fault_lat=(paches(:,2)-corner_lat)./res_lat.*0.2;

data_lon=DT1qt.cnt(1,:);
data_lat=DT1qt.cnt(2,:);
c_los=DT1qt.los;

index=[];
for i=1:size(int_pairs,1)
indexint1(i,1)=[index,find(t==int_pairs(i,1))];
indexint1(i,2)=[index,find(t==int_pairs(i,2))];
end

parfor k=1:size(int_pairs,1)  
    dslip=slip(indexint1(k,2),:)-slip(indexint1(k,1),:);
    simlos(k,:)=forwardlos(data_lon,data_lat,fault_lon,fault_lat,depth,strike,dip,L,W,rake,dslip,c_los);
end
simlos(isnan(simlos(:)))=0;
end