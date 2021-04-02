%Berechung der Kinematik als statisch bestimmtes Fachwerk, Lagerkraefte aus Aktorkraft und Lage der Staebe bestimmen 
clear all 
clc 
%Im Vorfeld sind bereits die Positionen der einzelnen Knoten im Weltsystem
%basierend auf den Messungen der Encoder berechnet worden (Skript
%"Konfiguration Kinematik")

%Die Funktion "getAngle" bestimmt basieren auf den Koordinatenwerten der
%Knoten die Richtung der Stabvektoren und ihren Winkel relativ zur
%x-Achse des Weltsystems

%Gleichungssystem mit 22 unbekannten (6*2 Lagerkraftkomponenten, 10
%Stabkraefte) und 22 Gleichungen aus Knoten-Kraeftegleichgewichten
%Schreiben als Ax=b, loesen nach Vektor der Unbekannten

%Symbolische Schreibweise, verarbeiten des GLS

%Stabkraefte und Winkel
syms S_1 S_2 S_3 S_4 S_6 S_7 S_8 S_10 S_11 S_12
syms phi_1 phi_2 phi_3 phi_4 phi_6 phi_7 phi_8 phi_10 phi_11 phi_12

%Lagerkraefte
syms L_1_x L_1_y L_2_x L_2_y L_3_x L_3_y L_4_x L_4_y L_5_x L_5_y L_6_x L_6_y

%Aktorkraft 
syms F_ext_x F_ext_y

%% Symbolisches Gleichungssystem aufstellen

%Gelenk A
eqn1 = L_2_x + S_4*cos(phi_4) == 0; 
eqn2 = L_2_y + S_4*sin(phi_4) == 0; 

%Gelenk B
eqn3 = L_1_x + S_1*cos(phi_1) == 0; 
eqn4 = L_1_y + S_1*sin(phi_1) == 0; 

%Gelenk C
eqn5 = F_ext_x + S_2*cos(phi_2) - S_1*cos(phi_1) == 0; 
eqn6 = F_ext_y + S_2*sin(phi_2) - S_1*sin(phi_1) == 0; 

%Gelenk D
eqn7 = - S_3*cos(phi_3) - S_2*cos(phi_2) + S_7*cos(phi_7) == 0; 
eqn8 = - S_3*sin(phi_3) - S_2*sin(phi_2) + S_7*sin(phi_7) == 0;

%Gelenk E
eqn9 = S_3*cos(phi_3) + S_6*cos(phi_6) - S_4*cos(phi_4) == 0; 
eqn10 = S_3*sin(phi_3) + S_6*sin(phi_6) - S_4*sin(phi_4) == 0; 

%Gelenk F
eqn11 = L_3_x - S_6*cos(phi_6) == 0;
eqn12 = L_3_y - S_6*sin(phi_6) == 0;

%Gelenk G
eqn13 = L_4_x + S_8*cos(phi_8) == 0;
eqn14 = L_4_y + S_8*sin(phi_8) == 0;

%Gelenk H
eqn15 = -S_7*cos(phi_7) - S_8*cos(phi_8) + S_10*cos(phi_10) == 0; 
eqn16 = -S_7*sin(phi_7) - S_8*sin(phi_8) + S_10*sin(phi_10) == 0; 

%Gelenk I
eqn17 = -S_10*cos(phi_10) - S_11*cos(phi_11) + S_12*cos(phi_12) == 0;
eqn18 = -S_10*sin(phi_10) - S_11*sin(phi_11) + S_12*sin(phi_12) == 0;

%Gelenk K
eqn19 = L_5_x + S_11*cos(phi_11) == 0;
eqn20 = L_5_y + S_11*sin(phi_11) == 0;

%Gelenk L
eqn21 = L_6_x - S_12*cos(phi_12) == 0;
eqn22 = L_6_y - S_12*sin(phi_12) == 0;

%% Loesung des symb. Gleichungssystems in Matrixschreibweise

%Ableiten der Matrix aus symb. Gleichungen
[A,B] = equationsToMatrix([eqn1, eqn2, eqn3, eqn4, eqn5, eqn6, eqn7, eqn8, eqn9, eqn10, eqn11, eqn12, eqn13, eqn14, eqn15, eqn16, eqn17, eqn18, eqn19, eqn20, eqn21, eqn22], [L_1_x, L_1_y, L_2_x, L_2_y, L_3_x, L_3_y, L_4_x, L_4_y, L_5_x, L_5_y, L_6_x, L_6_y, S_1, S_2, S_3, S_4, S_6, S_7, S_8, S_10, S_11, S_12])

%Loesungsvektor bestimmen 
X = linsolve(A,B)

%in symbolischer Loesung die gemessenen/berechneten Groessen ersetzen
