clear all ; close all ; clc ;
 % find regions of veg boundary 


% This code calculates the area of the contour map obtained from the agb
% ratio on the peak agb day 
 

%[x,y,z]=peaks; 


load('dc_rc_veg.mat')
%pcolorjw(x_ext,y_ext,agb_mask_ext)
%hold on
%contour(x,y,z)

%plot(rc_veg(:,1),rc_veg(:,2))

%x=x_ext; y=y_ext; z=agb_mask_ext; 
%  [C,h] = contour(x, y, z) ; 

 % POLYOUT 
xx=rc_veg(:,1);
yy=rc_veg(:,2);
pgon=polyshape(xx,yy);
polyout = holes(pgon)

plot(polyout)
veg_vert=polyout(1:end).Vertices;
save('veg_vert_poly_reedy.mat','polyout')
 
