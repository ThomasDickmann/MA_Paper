function [phi] = getActuationAngle(delta_s)
%getActuationAngle berechnet die Winkelstellung phi_1 in Gelenk B aus gewählter
%Aktorstellung delta_s
%   Beinhaltet die Kinematischen Größen der Aktorik als globale Variablen
global l_Akt
global d_b
global l_s
global alpha_const
global theta

l = delta_s + l_Akt;

alpha = acos((1/(2*l_s*d_b))*(l_s^2+d_b^2-l^2));
alpha_deg = (alpha/pi)*180

phi= pi - alpha + alpha_const - theta;
phi_deg = (phi/pi)*180
end

