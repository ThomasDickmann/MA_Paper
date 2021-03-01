function [P_x,P_y] = getPoint(a_x,a_y,l_1,b_x,b_y,l_2)
%getPoint bestimmt die Position eines Gelenks im Weltsystem
%   Bei Wahl A_x < B_x im Weltsystem wird oberer Schnittpunkt ausgegeben. Konfiguration "+sqrt(...)" liefert
%   C oberhalb von A und B, "-sqrt(...)" liefert C unterhalb von A und B
%   Werden A und B in umgekehrter Reihenfolge übergeben liefert Funktion ebenfalls die untere Loesung fuer C 

A=b_x-a_x;
B=b_y-a_y;
C_A=(A^2 + B^2 + l_1^2 - l_2^2)/(2*l_1);
C_B=(A^2 + B^2 + l_2^2 - l_1^2)/-(2*l_2);

%Winkel zwischen x-Achse Weltsystem und Vektor BC = alpha
%Quadratische Gleichung mit zwei Lösungen, Wahl positive Lösung
phi_A=2*atan((B+sqrt(A^2+B^2-C_A^2))/(A+C_A));

%Angle between x-axis worldframe and vector AC = beta
%Quadratische Gleichung mit zwei Lösungen, Wahl positive Lösung
phi_B=2*atan((B+sqrt(A^2+B^2-C_B^2))/(A+C_B));

P_x=a_x+cos(phi_A)*l_1;
P_y=a_y+sin(phi_A)*l_1;
end


