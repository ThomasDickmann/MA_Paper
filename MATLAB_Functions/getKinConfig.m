function [C,E,D,F,G,H,J,K,L,PIP,DIP,FS] = getKinConfig(phi_A, phi_B, phi_K)
%getKinConfig berechnet die Lage alle Gelenke der Kinematik aus drei
%gemessenen Encoderwinkeln
%   Eingeteilt in die einzelnen Gelenkvielecke der Kinematik

global l_PM
global l_PD
global MCP
global B 
global A 
global l_1
global l_2
global l_3
global l_4
global l_6
global l_7
global l_8
global l_9
global l_10
global l_11
global l_12

global l_G2
global l_G3
global l_G4
%global l_G5
global l_G6

global psi_3
global psi_4
global psi_5
global psi_6

%% Gelenkfuenfeck 1
C_x=B(1)+l_1*cos(phi_B);
C_y=B(2)+l_1*sin(phi_B);
C=[C_x;C_y];

E_x=A(1)+l_4*cos(phi_A);
E_y=A(2)+l_4*sin(phi_A);
E=[E_x;E_y];

%Zweischlag E-D-C
[D_x,D_y]=getPoint(C(1),C(2),l_2,E(1),E(2),l_3); 
D=[D_x;D_y];

%% Gelenkviereck 2
%Zweischlag E-F-MCP
[F_x,F_y]=getPoint(E(1),E(2),l_6,MCP(1),MCP(2),l_G2);
F=[F_x;F_y];

%% Gelenkfuenfeck 3
%Bestimmen Lagewinkel l_G2 in Weltsystem
phi_l_G2=getAngle(MCP(1),MCP(2),F(1),F(2));
G_x=F_x+cos(phi_l_G2-psi_3)*l_9;
G_y=F_y+sin(phi_l_G2-psi_3)*l_9;
G=[G_x;G_y];

%Zweischlag G-H-D
[H_x,H_y]=getPoint(D(1),D(2),l_7,G(1),G(2),l_8);
H=[H_x;H_y];

%% Gelenkfuenfeck 4
PIP_x=G_x+cos(phi_l_G2-psi_3-psi_4)*l_G3;
PIP_y=G_y+sin(phi_l_G2-psi_3-psi_4)*l_G3;
PIP=[PIP_x;PIP_y];

%Bestimmung Abstand PIP-J aus Messung Encoderwinkel phi_K fuer Zweischlag PIP-J-H
%Winkel gamma zwischen l_G4 und l_11
gamma=pi-phi_K+psi_5;
gamma_d = gamma * (180/pi);
%Strecke l zwischen PIP und J ueber Kosinussatz
l_KS=sqrt(l_G4^2+l_11^2-2*l_G4*l_11*cos(gamma));

%Zweischlag PIP-J-H mit virtueller Laenge l_KS 
[J_x,J_y]=getPoint(H(1),H(2),l_10,PIP(1),PIP(2),l_KS);
J=[J_x;J_y];

%------ Fallunterscheidung notwendig! Lage kann umschlagen! -------------
%Zweischlag PIP-K-J
%Bedingung: Winkel gamma zwischen l_G4 und l_11
if gamma_d<180
    [K_x,K_y]=getPoint(J(1),J(2),l_11,PIP(1),PIP(2),l_G4);
    K=[K_x;K_y];
else
    [K_x,K_y]=getPoint(PIP(1),PIP(2),l_G4,J(1),J(2),l_11);
    K=[K_x;K_y];
end
%% Gelenkviereck 5
phi_t=getAngle(PIP(1),PIP(2),K(1),K(2))-psi_5;
DIP_x=PIP(1)+l_PM*cos(phi_t);
DIP_y=PIP(2)+l_PM*sin(phi_t);
DIP=[DIP_x;DIP_y];

%Zweischlag DIP-L-J
[L_x,L_y]=getPoint(J(1),J(2),l_12,DIP(1),DIP(2),l_G6);
L=[L_x;L_y];

%Position der Fingerspitze
phi_t=getAngle(DIP(1),DIP(2),L(1),L(2))-psi_6;
FS_x=DIP(1)+l_PD*cos(phi_t);
FS_y=DIP(2)+l_PD*sin(phi_t);
FS=[FS_x;FS_y];


end

