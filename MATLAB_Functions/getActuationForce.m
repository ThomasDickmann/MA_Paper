function [F_ext_x, F_ext_y] = getActuationForce(F_Aktor, phi_1)
%getActuationForce berechnet die externe Kraft auf die Kinematik aus der
%Winkellage der Schwinge und der gemessenen Aktorkraft

global akt_x
global akt_y
global theta
global l_s
global l_1

%Winkel zwischen X-Achse und l_s [Check]
alpha_quer = pi - theta - phi_1;
%alpha_quer_d = (alpha_quer/pi)*180

%Position Verbindungspunkt Schwinge und Aktor [Check]
S_x = -l_s * cos(alpha_quer); 
S_y = l_s * sin(alpha_quer);

%Winkel des Kraftvektors [Check]
phi_F = getAngle(akt_x,akt_y,S_x,S_y);
phi_F_deg = (phi_F/pi)*180;

%Komponenten des Kraftvektors in Weltsystem
F_Akt_x = F_Aktor * cos(phi_F);
F_Akt_y = F_Aktor * sin(phi_F);

%Berechnen des Moments um Punkt B, pos. Richtung s. Skizze [Check]
%Hebelarme für Kraftanteile, pos. delta_x führt zu neg. Moment nach Skizze  
delta_x = -S_x;
delta_y = S_y;
M_B = (F_Akt_x * delta_y + F_Akt_y * delta_x);  %[Nmm]
M_B_Nm = M_B/1000;

%Berechnen der Kraft an Spitze von l_1 auf Kinematik
F_ext = M_B/l_1;

%Berechnen der Anteile in X- und Y- Richtung 
F_ext_y = -F_ext * cos(phi_1);
F_ext_x = F_ext * sin(phi_1);

end

