% proj15_5.m
echo on

% The Nose-Cone Integral

% Let's consider a paraboloid nose-cone

syms u v
x = u*cos(v);
y = u*sin(v);
z = u^2;
pause

% First we calculate the partial derivatives that are needed.

xu = diff(x,u);
xv = diff(x,v);
yu = diff(y,u);
yv = diff(y,v);
zu = diff(z,u);
zv = diff(z,v);
pause
%Then our 2-by-2 Jacobian determinants are given by

Jyz = det([yu, yv; zu, zv]);
Jzx = det([zu, zv; xu, xv]);
Jxy = det([xu, xv; yu, yv]);

% And the surface area element for S is

Sp = sqrt(simplify(Jyz^2 + Jzx^2 + Jxy^2))
 
Sp = u*sqrt(1 + 4*u^2);
pause
% Now cos(phi) = dx/ds in the xy-plane. Here, the radial coordinate u  
% plays the role of x and y is replaced with z, so cos(phi) = 
% du/sqrt(du^2 + dz^2) = 1/sqrt(1 + (dz/du)^2). Hence we define

cosphi = 1/sqrt(1 + zu^2); 
pause
%Consequently the integral of Eq. (1) in the introduction gives

R = (1/pi)*int(int(cosphi^3*Sp, u,0,1), v,0,2*pi);

double(R)

% We need only edit the initial definition of z = g(u) to calculate
% the air-resistance coefficient for another nose cone.

pause
% The Moebius strip

% As described in Problem 40 of the text, our Moebius strip with 
% width 2 and center-line of radius 4 is parametrized by

x = (u*cos(v/2) + 4)*cos(v);
y = (u*cos(v/2) + 4)*sin(v);
z =  u*sin(v/2);

% First we calculate the partial derivatives that are needed.

xu = diff(x,u);
xv = diff(x,v);
yu = diff(y,u);
yv = diff(y,v);
zu = diff(z,u);
zv = diff(z,v);
pause

%Then our 2-by-2 Jacobian determinants are given by

Jyz = det([yu, yv; zu, zv]);
Jzx = det([zu, zv; xu, xv]);
Jxy = det([xu, xv; yu, yv]);

%And the surface area element for S is

Sp = sqrt(simplify(Jyz^2 + Jzx^2 + Jxy^2))
pause

type dS

S = dblquad('dS',-1,1,0,2*pi)
pause

type xdS

xc = dblquad('xdS',-1,1,0,2*pi)/S
pause

type ydS

yc = dblquad('ydS',-1,1,0,2*pi)/S
pause

type zdS

zc = dblquad('zdS',-1,1,0,2*pi)/S

% And finally we plot the Moebius strip.

u = -1 : 1/4 : 1;
v = 0 : pi/16 : 2*pi;
[u,v] = meshgrid(u,v);
x = (u.*cos(1./2.*v)+4).*cos(v);
y = (u.*cos(1./2.*v)+4).*sin(v);
z = u.*sin(1./2.*v);
surf(x,y,z)
surf(x,y,z), axis equal
view(-5,15)
xlabel('x'),ylabel('y')