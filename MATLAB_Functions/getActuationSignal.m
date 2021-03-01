function [delta_s] = getActuationSignal(phi)
%getActuationSignal berechnet aus einer vorgegebenen Winkelstellung phi_1 in Gelenk B die
%notwendige Aktorstellung delta_s
%   Beinhaltet die Kinematischen Größen der Aktorik als globale Variablen
global l_Akt
global d_b
global l_s
global alpha_const
global theta

alpha = pi - theta - phi + alpha_const
alpha_deg = (alpha/pi)*180

l=sqrt(l_s^2+d_b^2- 2*l_s*d_b*cos(alpha))

delta_s = l - l_Akt
end