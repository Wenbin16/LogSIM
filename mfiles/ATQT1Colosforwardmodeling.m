function simlos=ATQT1Colosforwardmodeling(t,coslip,slip,int_pairs,rake1,rake2)
%t is the combined time
%t1 is the AT time
%t2 is the AT1 time
%slip is the simulated spatio-temporal slip
%nwidth is the row number 
%nline is the collumn number

load matdir/faultgeos
paches=faultgeos.fault1;
n=length(paches);

depth=paches(:,3);
strike=paches(1,4);%strike angle of fault
dip=paches(1,5);%dip angle of fault
L=paches(1,6)/1000;%paches' length
W=paches(1,7)/1000;%paches' width

%% FOR AT
load matdir/AT1Coqt.mat 
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

data_lon=AT1Coqt.cnt(1,:);
data_lat=AT1Coqt.cnt(2,:);
c_los=AT1Coqt.los;

index=[];
for i=1:size(int_pairs,1)
indexint1(i,2)=[index,find(t==int_pairs(i,2))];
end

parfor k=1:size(int_pairs,1)   
    dslip=slip(indexint1(k,2),:);
    simlos1=forwardlos(data_lon,data_lat,fault_lon,fault_lat,depth,strike,dip,L,W,rake1,coslip,c_los);
    simlos2=forwardlos(data_lon,data_lat,fault_lon,fault_lat,depth,strike,dip,L,W,rake2,dslip,c_los);
    simlos(k,:)=simlos1+simlos2;
end
simlos(isnan(simlos(:)))=0;

end