function LOS=forwardlos(data_lon,data_lat,fault_lon,fault_lat,depth,strike,dip,L,W,rake,slip,colos)
%%
%%

ENU=zeros(3,length(data_lon));
n=length(slip);
for i=1:n
    lon=data_lon-fault_lon(i);
    lat=data_lat-fault_lat(i);
    [uE,uN,uZ]=okada85(lon,lat,depth(i),strike,dip,L,W,rake,slip(i),0);
    ENU(1,:)=ENU(1,:)+uE;ENU(2,:)=ENU(2,:)+uN;ENU(3,:)=ENU(3,:)+uZ;
end
LOS=sum(ENU.*colos);

end
