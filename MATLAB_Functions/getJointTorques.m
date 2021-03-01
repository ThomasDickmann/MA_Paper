function [M_MCP, M_PIP, M_DIP] = getJointTorques(alpha,beta,gamma,F3x,F3y,F4x,F4y,F5x,F5y,F6x,F6y)
%getJointTorques berechnet die Fingermomente für den Quasistatischen
%Zustand
%   Inhalt der Funktion sind die nach den drei Fingermomenten ausgewerteten
%   Newton-Euler Gleichungen fuer den Fall q_dot = q_ddot = 0 (Keine
%   Bewegung)

%Alle Laengen in mm gegeben, fuer Ausgabe der Momente in Nm muss
%umgerechnet werden 
global l_C1
global l_C2
global l_C3

global P_11x 
global P_11y 
global P_12x 
global P_12y 
global P_2x 
global P_2y 
global P_3x 
global P_3y 

%Massen in kg
global m1
global m2
global m3

%Namenskonvention wegen Benennungskollision bei F_3/F3 geaendert
F_11x = F3x;
F_11y = F3y;

F_12x = F4x;
F_12y = F4y;

F_2x = F5x;
F_2y = F5y;

F_3x = F6x;
F_3y = F6y;


%[Nmm]Berechnen der Gelenkmomente mit ausgew. NE-Gleichungen fuer statischen Zustand
M_MCP_Nmm = F_3y*l_C3*cos(alpha + beta + gamma) - F_3x*l_C3*sin(alpha + beta + gamma) - (981*l_C3*m3*cos(alpha + beta + gamma))/100 - F_2x*P_2y*cos(alpha + beta) + F_2y*P_2x*cos(alpha + beta) - F_2x*P_2x*sin(alpha + beta) - F_2y*P_2y*sin(alpha + beta) + F_2y*l_C2*cos(alpha + beta) + 2*F_3y*l_C2*cos(alpha + beta) - F_2x*l_C2*sin(alpha + beta) - 2*F_3x*l_C2*sin(alpha + beta) - F_11x*P_11y*cos(alpha) + F_11y*P_11x*cos(alpha) - F_12x*P_12y*cos(alpha) + F_12y*P_12x*cos(alpha) - (981*l_C2*m2*cos(alpha + beta))/100 - (981*l_C2*m3*cos(alpha + beta))/50 - F_11x*P_11x*sin(alpha) - F_11y*P_11y*sin(alpha) - F_12x*P_12x*sin(alpha) - F_12y*P_12y*sin(alpha) + 2*F_2y*l_C1*cos(alpha) + 2*F_3y*l_C1*cos(alpha) + F_11y*l_C1*cos(alpha) + F_12y*l_C1*cos(alpha) - F_3x*P_3y*cos(alpha + beta + gamma) + F_3y*P_3x*cos(alpha + beta + gamma) - 2*F_2x*l_C1*sin(alpha) - 2*F_3x*l_C1*sin(alpha) - F_11x*l_C1*sin(alpha) - F_12x*l_C1*sin(alpha) - F_3x*P_3x*sin(alpha + beta + gamma) - F_3y*P_3y*sin(alpha + beta + gamma) - (981*l_C1*m1*cos(alpha))/100 - (981*l_C1*m2*cos(alpha))/50 - (981*l_C1*m3*cos(alpha))/50;
M_PIP_Nmm = F_3y*l_C3*cos(alpha + beta + gamma) - F_3x*l_C3*sin(alpha + beta + gamma) - (981*l_C3*m3*cos(alpha + beta + gamma))/100 - F_2x*P_2y*cos(alpha + beta) + F_2y*P_2x*cos(alpha + beta) - F_2x*P_2x*sin(alpha + beta) - F_2y*P_2y*sin(alpha + beta) + F_2y*l_C2*cos(alpha + beta) + 2*F_3y*l_C2*cos(alpha + beta) - F_2x*l_C2*sin(alpha + beta) - 2*F_3x*l_C2*sin(alpha + beta) - (981*l_C2*m2*cos(alpha + beta))/100 - (981*l_C2*m3*cos(alpha + beta))/50 - F_3x*P_3y*cos(alpha + beta + gamma) + F_3y*P_3x*cos(alpha + beta + gamma) - F_3x*P_3x*sin(alpha + beta + gamma) - F_3y*P_3y*sin(alpha + beta + gamma);
M_DIP_Nmm = F_3y*l_C3*cos(alpha + beta + gamma) - F_3x*l_C3*sin(alpha + beta + gamma) - (981*l_C3*m3*cos(alpha + beta + gamma))/100 - F_3x*P_3y*cos(alpha + beta + gamma) + F_3y*P_3x*cos(alpha + beta + gamma) - F_3x*P_3x*sin(alpha + beta + gamma) - F_3y*P_3y*sin(alpha + beta + gamma);

%Umrechnen der Momente in Nm
M_MCP = M_MCP_Nmm/1000;
M_PIP = M_PIP_Nmm/1000;
M_DIP = M_DIP_Nmm/1000;

%TODO: Ersetzen der Trigonometrischen Ausdruecke durch const. Variablen fuer
%bessere numerische Effizienz (bei Auswertung direkt auf µC)
%M1 = F_3y*l_C3*cos(alpha + beta + gamma) - F_3x*l_C3*sin(alpha + beta + gamma) - (981*l_C3*m3*cos(alpha + beta + gamma))/100 - F_2x*P_2y*cos(alpha + beta) + F_2y*P_2x*cos(alpha + beta) - F_2x*P_2x*sin(alpha + beta) - F_2y*P_2y*sin(alpha + beta) + F_2y*l_C2*cos(alpha + beta) + 2*F_3y*l_C2*cos(alpha + beta) - F_2x*l_C2*sin(alpha + beta) - 2*F_3x*l_C2*sin(alpha + beta) - F_11x*P_11y*cos(alpha) + F_11y*P_11x*cos(alpha) - F_12x*P_12y*cos(alpha) + F_12y*P_12x*cos(alpha) - (981*l_C2*m2*cos(alpha + beta))/100 - (981*l_C2*m3*cos(alpha + beta))/50 - F_11x*P_11x*sin(alpha) - F_11y*P_11y*sin(alpha) - F_12x*P_12x*sin(alpha) - F_12y*P_12y*sin(alpha) + 2*F_2y*l_C1*cos(alpha) + 2*F_3y*l_C1*cos(alpha) + F_11y*l_C1*cos(alpha) + F_12y*l_C1*cos(alpha) - F_3x*P_3y*cos(alpha + beta + gamma) + F_3y*P_3x*cos(alpha + beta + gamma) - 2*F_2x*l_C1*sin(alpha) - 2*F_3x*l_C1*sin(alpha) - F_11x*l_C1*sin(alpha) - F_12x*l_C1*sin(alpha) - F_3x*P_3x*sin(alpha + beta + gamma) - F_3y*P_3y*sin(alpha + beta + gamma) - (981*l_C1*m1*cos(alpha))/100 - (981*l_C1*m2*cos(alpha))/50 - (981*l_C1*m3*cos(alpha))/50
%M2 = F_3y*l_C3*cos(alpha + beta + gamma) - F_3x*l_C3*sin(alpha + beta + gamma) - (981*l_C3*m3*cos(alpha + beta + gamma))/100 - F_2x*P_2y*cos(alpha + beta) + F_2y*P_2x*cos(alpha + beta) - F_2x*P_2x*sin(alpha + beta) - F_2y*P_2y*sin(alpha + beta) + F_2y*l_C2*cos(alpha + beta) + 2*F_3y*l_C2*cos(alpha + beta) - F_2x*l_C2*sin(alpha + beta) - 2*F_3x*l_C2*sin(alpha + beta) - (981*l_C2*m2*cos(alpha + beta))/100 - (981*l_C2*m3*cos(alpha + beta))/50 - F_3x*P_3y*cos(alpha + beta + gamma) + F_3y*P_3x*cos(alpha + beta + gamma) - F_3x*P_3x*sin(alpha + beta + gamma) - F_3y*P_3y*sin(alpha + beta + gamma)
%M3 = F_3y*l_C3*cos(alpha + beta + gamma) - F_3x*l_C3*sin(alpha + beta + gamma) - (981*l_C3*m3*cos(alpha + beta + gamma))/100 - F_3x*P_3y*cos(alpha + beta + gamma) + F_3y*P_3x*cos(alpha + beta + gamma) - F_3x*P_3x*sin(alpha + beta + gamma) - F_3y*P_3y*sin(alpha + beta + gamma)
 
end

