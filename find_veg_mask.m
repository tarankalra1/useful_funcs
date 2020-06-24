clear all ; close all ; clc ;
load('veg_vert_poly_reedy.mat','polyout')
load('C:\Users\tkalra\Desktop\barnegatbay\easygrid\bathy_generator\Dinner_and_Reedy_Creek\dc_rc_veg.mat');

r1=rc_veg(:,1); r2=rc_veg(:,2);

format long 

url='../bbleh_reedy_grd.nc'     ; 

grid_size_coarse=134*390        ; 
lon_rho=ncread(url, 'lon_rho')  ;
lat_rho=ncread(url, 'lat_rho')  ; 
h      =ncread(url,  'h')       ;
veg_mask=lon_rho*0.0; 

veg_mask_1d=reshape(veg_mask,[grid_size_coarse 1]); 
lon_rho_1d=reshape(lon_rho,[grid_size_coarse 1]);
lat_rho_1d=reshape(lat_rho,[grid_size_coarse 1]); 

xv=lon_rho_1d;
yv=lat_rho_1d; 


for i=1:length(polyout)
    
    xx=polyout(i).Vertices(1:end,1);
    yy=polyout(i).Vertices(1:end,2);
    
    in = inpolygon(xv,yv,xx,yy);
    veg_mask_1d(in)=1 ;
end 
veg_mask_2d=reshape(veg_mask_1d,134,390);
% 
% lon_rho=ncread(url,'lon_rho');
% lat_rho=ncread(url,'lat_rho'); 
% %  
%  
figure(1)
plot(xv,yv,'g+')
hold on 
plot(xx,yy,'r+');
hold on
plot(xv(in), yv(in),'.r')

figure(2)
pcolorjw(lon_rho, lat_rho, veg_mask_2d) 

figure(3)
pcolorjw(lon_rho, lat_rho, h)

figure(4)
plot(r1, r2)
%plot(xv(~in),yv(~in),'.b')

%figure(1)
%plot(lon_rho_1d, lat_rho_1d, 'bp')                                          % Plot All Points
%hold on
%plot(xx, yy, '-r')                                          % Plot Polygon
%plot(xcoord, ycoord, 'gp')                                  % Overplot ‘inon’ Points
%hold off
%plot(polyout)
%hold on
%plot(xx,yy,'r+')