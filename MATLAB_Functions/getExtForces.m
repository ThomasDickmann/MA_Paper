function [F_1x,F_1y,F_2x,F_2y,F_3x,F_3y,F_4x,F_4y,F_5x,F_5y,F_6x,F_6y] = getExtForces(F_ext_x, F_ext_y)
%getExtForces berechnet die externen Kraefte auf den Finger aus einer
%gegebenen Aktorkraft
%   Die Stabkraefte sind in ihrem Vorzeichen gemaeﬂ der Skizze gerichtet.

%Kaft S1 ist nicht gleich der Reaktionskraft in Simscape Modell! Reaktion
%in Simscape setzt sich zusammen aus der Reaktion auf Antriebsmoment (bzw.
%F_ext_x/F_ext_y, sowie ZUSAETZLICH der Stabkraft S1, die auf das Gelenk
%wirkt!

global phi_1 
global phi_2 
global phi_3 
global phi_4 
global phi_6 
global phi_7
global phi_8
global phi_10
global phi_11 
global phi_12

F_1x=-(cos(phi_1)*(F_ext_y*cos(phi_2) - F_ext_x*sin(phi_2)))/sin(phi_1 - phi_2);
F_1y=-(sin(phi_1)*(F_ext_y*cos(phi_2) - F_ext_x*sin(phi_2)))/sin(phi_1 - phi_2);
%F_1=sqrt(F_1_x^2 + F_1_y^2);
%S_1=-(F_ext_y*cos(phi_2) - F_ext_x*sin(phi_2))/(cos(phi_1)*sin(phi_2) - cos(phi_2)*sin(phi_1));

F_2x=(sin(phi_2 - phi_7)*sin(phi_3 - phi_6)*cos(phi_4)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_4 - phi_6));
F_2y=(sin(phi_2 - phi_7)*sin(phi_3 - phi_6)*sin(phi_4)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_4 - phi_6));
%F_2=sqrt(F_2_x^2 + F_2_y^2);
%S_4=(-(sin(phi_2 - phi_7)*sin(phi_3 - phi_6)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_4 - phi_6)))

F_3x=-(sin(phi_3 - phi_4)*sin(phi_2 - phi_7)*cos(phi_6)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_4 - phi_6));
F_3y=-(sin(phi_3 - phi_4)*sin(phi_2 - phi_7)*sin(phi_6)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_4 - phi_6));
%F_3=sqrt(F_3_x^2 + F_3_y^2);
%S_6=-(sin(phi_3 - phi_4)*sin(phi_2 - phi_7)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_4 - phi_6))

F_4x=-(sin(phi_2 - phi_3)*sin(phi_7 - phi_10)*cos(phi_8)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_8 - phi_10));
F_4y=-(sin(phi_2 - phi_3)*sin(phi_7 - phi_10)*sin(phi_8)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_8 - phi_10));
%F_4=sqrt(F_4_x^2 + F_4_y^2);
%S_8=((sin(phi_2 - phi_3)*sin(phi_7 - phi_10)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_8 - phi_10)))
 
F_5x=(sin(phi_2 - phi_3)*sin(phi_7 - phi_8)*sin(phi_10 - phi_12)*cos(phi_11)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_8 - phi_10)*sin(phi_11 - phi_12));
F_5y=(sin(phi_2 - phi_3)*sin(phi_7 - phi_8)*sin(phi_10 - phi_12)*sin(phi_11)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_8 - phi_10)*sin(phi_11 - phi_12));
%F_5=sqrt(F_5_x^2 + F_5_y^2);
%S_11=(-(sin(phi_2 - phi_3)*sin(phi_7 - phi_8)*sin(phi_10 - phi_12)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_8 - phi_10)*sin(phi_11 - phi_12)))

F_6x=-(sin(phi_2 - phi_3)*sin(phi_7 - phi_8)*sin(phi_10 - phi_11)*cos(phi_12)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_8 - phi_10)*sin(phi_11 - phi_12));
F_6y=-(sin(phi_2 - phi_3)*sin(phi_7 - phi_8)*sin(phi_10 - phi_11)*sin(phi_12)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_8 - phi_10)*sin(phi_11 - phi_12));
%F_6=sqrt(F_6_x^2 + F_6_y^2);
%S_12=-(sin(phi_2 - phi_3)*sin(phi_7 - phi_8)*sin(phi_10 - phi_11)*(F_ext_y*cos(phi_1) - F_ext_x*sin(phi_1)))/(sin(phi_1 - phi_2)*sin(phi_3 - phi_7)*sin(phi_8 - phi_10)*sin(phi_11 - phi_12))

end

