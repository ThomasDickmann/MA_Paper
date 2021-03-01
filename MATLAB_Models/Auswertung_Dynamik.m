%Minimalkoordinaten alpha, beta, gamma: Gelenkwinkel MCP, PIP, DIP siehe Skizze

clear all
clc 

%Aktuell keine Gravitationskraefte beruecksichtigt! (TODO: m_i*g in neg. y-Richtung ext. Kraftvektor, oder weglassen)
%Kreuzprodukt im Drallterm aus NE Gleichungen entfernt, da immer =0

%Laengen zu Schwerpunkten jeweils halbe Phalanxlaenge
syms l_C1 l_C2 l_C3

%Vektor der Minimalkoordinaten
syms alpha beta gamma

%Drehmatrix Inertial nach KS1
A_1I=[cos(alpha) sin(alpha) 0; -sin(alpha) cos(alpha) 0; 0 0 1];
%Drehmatrix Inertial nach KS2
A_21=[cos(beta) sin(beta) 0; -sin(beta) cos(beta) 0; 0 0 1];
A_2I=A_21*A_1I;
%Drehmatrix Inertial nach KS3
A_32=[cos(gamma) sin(gamma) 0; -sin(gamma) cos(gamma) 0; 0 0 1];
A_3I=A_32*A_21*A_1I;

%Vektor der Minimalgeschwindigkeiten 
syms alpha_dot beta_dot gamma_dot

%Vektor der Minimalbeschleunigungen
syms alpha_ddot beta_ddot gamma_ddot

%Traegheitstensoren Fingerglieder (Koerper 1,2,3)
%Angegeben im Koerpersystem bezogen auf Koordinatenursprung im Koerper-Ursprungsgelenk
syms A B C D E F

theta_1 = [A 0 0; 0 B 0; 0 0 B];
theta_2 = [C 0 0; 0 D 0; 0 0 D];
theta_3 = [E 0 0; 0 F 0; 0 0 F];

%Eintragen der Werte[kg*mm^2]
% A = 0.512;
% B = 6.304; 
% C = 0.112; 
% D = 0.727;
% E = 0.041;
% F = 0.322;

%Massen der Fingerglieder 
syms m1 m2 m3

%Eintragen der Werte [kg]
g=9.81;
% m1 =
% m2 = 
% m3 =

%Aeußere Kraefte und Momente in Inertialsystem (Zu jedem Zeitschritt
%aktualisieren, Uebernahme der Werte aus Kinematikskript)
syms M_1 M_2 M_3 %In allen Systemen gleich (jeweils um z-Achse, Annahme Momenten in negativer Richtung!)
syms F_11x F_11y F_12x F_12y 
syms F_2x F_2y 
syms F_3x F_3y

%Ortsvektoren der Kraftangriffspunkte dargestellt in Koerpersystemen
%(Konstant, einmalig aus Geometrie des Modells bestimmen)
syms P_11x P_11y P_12x P_12y 
syms P_2x P_2y 
syms P_3x P_3y

r_P11=[P_11x; P_11y;0];
r_P12=[P_12x; P_12y;0];
r_P2 =[P_2x; P_2y;0];
r_P3 =[P_3x; P_3y;0];

%Drehen der externen Kraefte in Koerpersysteme
F_1_11x = F_11x*cos(alpha) + F_11y*sin(alpha);
F_1_11y = F_11y*cos(alpha) - F_11x*sin(alpha);

F_1_12x = F_12x*cos(alpha) + F_12y*sin(alpha);
F_1_12y = F_12y*cos(alpha) - F_12x*sin(alpha);

F_2_2x =F_2x*cos(alpha + beta) + F_2y*sin(alpha + beta); %Angepasst von cos(alpha)+cos(beta) auf cos(alpha+beta)
F_2_2y =F_2y*cos(alpha + beta) - F_2x*sin(alpha + beta);

F_3_3x = F_3x*cos(alpha + beta + gamma) + F_3y*sin(alpha + beta + gamma);
F_3_3y = F_3y*cos(alpha + beta + gamma) - F_3x*sin(alpha + beta + gamma);
 
%% Koerper 1: Proximales Fingerglied

%Intertialsystem im MCP Gelenk mit x-Achse parallel zu Handruecken
%Position im Inertialsystem mit Abstand l_C1 in KS_1
r_I_C1=[l_C1*cos(alpha);l_C1*sin(alpha);0]

%Geschwindigkeit im Inertialsystem mit Abstand l_C1 in KS_1
v_I_C1=[-l_C1*sin(alpha)*alpha_dot; l_C1*cos(alpha)*alpha_dot;0]

%Beschleunigung im Inertialsystem mit Abstand l_C1 in KS_1
a_I_C1=[-l_C1*sin(alpha)*alpha_ddot - l_C1*cos(alpha)*alpha_dot^2; l_C1*cos(alpha)*alpha_ddot - l_C1*sin(alpha)*alpha_dot^2; 0]

%Jacobimatrix der Translation Koerper 1 (Inertialsytem)
J_I_T1 = jacobian(v_I_C1,[alpha_dot, beta_dot, gamma_dot])
J_I_T1_trans = transpose(J_I_T1);

%Externe Kraefte auf Koerper 1 in Intertialsystem 
F_I_ext1 = [F_11x; F_11y; 0] + [F_12x; F_12y; 0] + [0;-g*m1;0]

%Absolute Winkelgeschwindigkeit und Winkelbeschleunigung Koerper 1 in Koerpersystem 1
%(Alle z-Achsen der Körper sind parallel)
omega_1_1 = [0; 0; alpha_dot];

omega_1_1_dot = [0; 0; alpha_ddot];

%Jacobimatrix der Rotation Koerper 1 (Koerpersystem)
J_1_R1 = jacobian(omega_1_1, [alpha_dot, beta_dot, gamma_dot])
J_1_R1_trans = transpose(J_1_R1);

%Berechnung Drall Koerper 1
L_1_1 = theta_1 * omega_1_1;

%Zeitableitung Drall Koeper 1
L_1_1_dot = [0; 0; B*alpha_ddot];

%Drallaenderung Koerper 1
cross(omega_1_1,L_1_1); %ans = 0, Bestaetigung dass Term in späteren NE Gleichungen konsequent weggelassen werden kann 

%Externe Momente: Fingermomente 
M_1_F = [0; 0; -M_1] + [0; 0; M_2];

%Momente durch externe Kraefte: Schwerpunktoffset Kompensation
r_P11 = [P_11x; P_11y; 0]; 
r_P12 = [P_12x; P_12y; 0];

F_1_11 = [F_1_11x; F_1_11y; 0];
F_1_12 = [F_1_12x; F_1_12y; 0];
M_1_Komp = cross(r_P11,F_1_11) + cross(r_P12, F_1_12)

%Externe Momente gesamt
M_1_ext = M_1_F + M_1_Komp;

%Terme der Newton-Euler-Gleichungen fuer Koerper 1 (Drallaenderung ist Null)
%NE_1 =(transpose(J_I_T1))*(m1 * a_I_C1 - F_I_ext1) + (transpose(J_1_R1))*(L_1_1_dot - M_1_ext)
%Vereinfachung auf quasistatischen Fall 
NE_1 = J_I_T1_trans*(F_I_ext1) + J_1_R1_trans*(M_1_ext);

%% Koerper 2: Mediales Fingerglied

%Intertialsystem im MCP Gelenk mit x-Achse parallel zu Handruecken
%Position Schwerpunkt C2 im Inertialsystem 
r_I_C2=[2*l_C1*cos(alpha);2*l_C1*sin(alpha);0] + [l_C2*cos(alpha+beta); l_C2*sin(alpha+beta); 0];

%Geschwindigkeit im Inertialsystem mit Abstand l_C1 in KS_1
v_I_C2=[-l_C2*sin(alpha + beta)*(alpha_dot + beta_dot) - 2*l_C1*sin(alpha)*alpha_dot;  2*l_C1*cos(alpha)*alpha_dot + l_C2*cos(alpha + beta)*(alpha_dot + beta_dot); 0];

%Beschleunigung im Inertialsystem mit Abstand l_C1 in KS_1
a_I_C2=[-2*l_C1*cos(alpha)*alpha_dot^2 - 2*l_C1*sin(alpha)*alpha_ddot - l_C2*cos(alpha + beta)*(alpha_dot + beta_dot)^2 - l_C2*sin(alpha + beta)*(alpha_ddot + beta_ddot); 2*l_C1*cos(alpha)*alpha_ddot - 2*l_C1*sin(alpha)*alpha_dot^2 - l_C2*sin(alpha + beta)*(alpha_dot + beta_dot)^2 + l_C2*cos(alpha + beta)*(alpha_ddot + beta_ddot); 0];

%Jacobimatrix der Translation Koerper 2 (Inertialsytem)
J_I_T2 = jacobian(v_I_C2,[alpha_dot, beta_dot, gamma_dot]);
J_I_T2_trans = transpose(J_I_T2);

%Externe Kraefte auf Schwerpunkt Koerper 2 in Intertialsystem 
F_I_ext2 = [F_2x; F_2y; 0] + [0;-g*m2;0]

%Absolute Winkelgeschwindigkeit und Winkelbeschleunigung Koerper 2 in Koerpersystem 2
%(Alle z-Achsen der Körper sind parallel)
omega_2_2 = A_21*[0; 0; alpha_dot] + [0; 0; beta_dot];

omega_2_2_dot = [0; 0; alpha_ddot + beta_ddot];

%Jacobimatrix der Rotation Koerper 2 (Koerpersystem)
J_2_R2 = jacobian(omega_2_2, [alpha_dot, beta_dot, gamma_dot]);
J_2_R2_trans = transpose(J_2_R2);

%Berechnung Drall Koerper 2
L_2_2 = theta_2 * omega_2_2;

%Zeitableitung Drall Koeper 2
L_2_2_dot = [0; 0; D*(alpha_ddot + beta_ddot)];

%Drallaenderung Koerper 2
cross(omega_2_2,L_2_2); %Null

%Externe Momente: Fingermomente 
M_2_F = [0; 0; -M_2] + [0; 0; M_3];

%Momente Schwerpunktoffset Kompensation
F_2_2=[F_2_2x;F_2_2y;0];
M_2_Komp = cross(r_P2,F_2_2)

%Externe Momente gesamt
M_2_ext = M_2_F + M_2_Komp;

%Terme der Newton-Euler-Gleichungen fuer Koerper 1
%NE_2 =(transpose(J_I_T2))*(m2 * a_I_C2 - F_I_ext2) + (transpose(J_2_R2))*(L_2_2_dot - M_2_ext);
%Vereinfachung Quasistatischer Fall 
NE_2 =J_I_T2_trans*(F_I_ext2) + J_2_R2_trans*(M_2_ext);

%% Koerper 3: Distales Fingerglied

%Intertialsystem im MCP Gelenk mit x-Achse parallel zu Handruecken
%Position Schwerpunkt C2 im Inertialsystem 
r_I_C3=[2*l_C1*cos(alpha);2*l_C1*sin(alpha);0] + [2*l_C2*cos(alpha+beta); 2*l_C2*sin(alpha+beta); 0] + [l_C3*cos(alpha+beta+gamma); l_C3*sin(alpha+beta+gamma); 0];

%Geschwindigkeit im Inertialsystem mit Abstand l_C1 in KS_1
v_I_C3=[- 2*l_C2*sin(alpha + beta)*(alpha_dot + beta_dot) - l_C3*sin(alpha + beta + gamma)*(alpha_dot + beta_dot + gamma_dot) - 2*l_C1*sin(alpha)*alpha_dot; l_C3*cos(alpha + beta + gamma)*(alpha_dot + beta_dot + gamma_dot) + 2*l_C1*cos(alpha)*alpha_dot + 2*l_C2*cos(alpha + beta)*(alpha_dot + beta_dot); 0]; 

%Beschleunigung im Inertialsystem mit Abstand l_C1 in KS_1
a_I_C3=[- 2*l_C1*cos(alpha)*alpha_dot^2 - 2*l_C1*sin(alpha)*alpha_ddot - 2*l_C2*cos(alpha + beta)*(alpha_dot + beta_dot)^2 - l_C3*cos(alpha + beta + gamma)*(alpha_dot + beta_dot + gamma_dot)^2 - 2*l_C2*sin(alpha + beta)*(alpha_ddot + beta_ddot) - l_C3*sin(alpha + beta + gamma)*(alpha_ddot + beta_ddot + gamma_ddot); 2*l_C1*cos(alpha)*alpha_ddot - 2*l_C1*sin(alpha)*alpha_dot^2 - 2*l_C2*sin(alpha + beta)*(alpha_dot + beta_dot)^2 + 2*l_C2*cos(alpha + beta)*(alpha_ddot + beta_ddot) + l_C3*cos(alpha + beta + gamma)*(alpha_ddot + beta_ddot + gamma_ddot) - l_C3*sin(alpha + beta + gamma)*(alpha_dot + beta_dot + gamma_dot)^2; 0];
 
%Jacobimatrix der Translation Koerper 2 (Inertialsytem)
J_I_T3 = jacobian(v_I_C3,[alpha_dot, beta_dot, gamma_dot]);
J_I_T3_trans = transpose(J_I_T3);

%Externe Kraefte auf Schwerpunkt Koerper 3 in Intertialsystem 
F_I_ext3 = [F_3x; F_3y; 0] + [0;-g*m3;0]

%Absolute Winkelgeschwindigkeit und Winkelbeschleunigung Koerper 3 in Koerpersystem 3
%(Alle z-Achsen der Körper sind parallel)
omega_3_3 =[0; 0; alpha_dot] + [0; 0; beta_dot] + [0; 0; gamma_dot];

omega_3_3_dot = [0; 0; alpha_ddot + beta_ddot + gamma_ddot];

%Jacobimatrix der Rotation Koerper 3 (Koerpersystem)
J_3_R3 = jacobian(omega_3_3, [alpha_dot, beta_dot, gamma_dot]);
J_3_R3_trans = transpose(J_3_R3);

%Berechnung Drall Koerper 3
L_3_3 = theta_3 * omega_3_3;

%Zeitableitung Drall Koeper 3
L_3_3_dot = [0; 0; F*(alpha_ddot + beta_ddot + gamma_ddot)];

%Drallaenderung Koerper 3
cross(omega_3_3,L_3_3); %Null

%Externe Momente: Fingermomente 
M_3_F = [0; 0; -M_3];

%Momente Schwerpunktoffset Kompensation
F_3_3=[F_3_3x;F_3_3y;0];
M_3_Komp = cross(r_P3,F_3_3)

%Externe Momente gesamt
M_3_ext = M_3_F + M_3_Komp;

%Terme der Newton-Euler-Gleichungen fuer Koerper 3
%NE_3 =(transpose(J_I_T3))*(m3 * a_I_C3 - F_I_ext3) + (transpose(J_3_R3))*(L_3_3_dot - M_3_ext)

%Vereinfachung Quasistatischer Fall 
NE_3 =J_I_T3_trans*(F_I_ext3) + J_3_R3_trans*(M_3_ext);

%% Newton Euler Gleichungen fuer Gesamtsystem: Summe ueber alle Koerper bilden

NE_ges = NE_1 + NE_2 + NE_3

%Loesen der Gleichung nach den Fingergelenkmomenten M1,M2,M3 ACHTUNG:
%HARDCODED COPY DER NE_ges OBEN! BEI ÄNDERUNGEN IN SKRIPT OBEN IMMER NEU KOPIEREN!

NE_ges_1 = (l_C2*cos(alpha + beta) + 2*l_C1*cos(alpha))*(F_2y - (981*m2)/100) - F_2x*(l_C2*sin(alpha + beta) + 2*l_C1*sin(alpha)) - M_1 + P_3x*(F_3y*cos(alpha + beta + gamma) - F_3x*sin(alpha + beta + gamma)) - P_3y*(F_3x*cos(alpha + beta + gamma) + F_3y*sin(alpha + beta + gamma)) + P_2x*(F_2y*cos(alpha + beta) - F_2x*sin(alpha + beta)) - P_2y*(F_2x*cos(alpha + beta) + F_2y*sin(alpha + beta)) + (F_3y - (981*m3)/100)*(2*l_C2*cos(alpha + beta) + 2*l_C1*cos(alpha) + l_C3*cos(alpha + beta + gamma)) - F_3x*(2*l_C2*sin(alpha + beta) + 2*l_C1*sin(alpha) + l_C3*sin(alpha + beta + gamma)) + P_11x*(F_11y*cos(alpha) - F_11x*sin(alpha)) - P_11y*(F_11x*cos(alpha) + F_11y*sin(alpha)) + P_12x*(F_12y*cos(alpha) - F_12x*sin(alpha)) - P_12y*(F_12x*cos(alpha) + F_12y*sin(alpha)) + l_C1*cos(alpha)*(F_11y + F_12y - (981*m1)/100) - l_C1*sin(alpha)*(F_11x + F_12x)
NE_ges_2 = (2*l_C2*cos(alpha + beta) + l_C3*cos(alpha + beta + gamma))*(F_3y - (981*m3)/100) - F_3x*(2*l_C2*sin(alpha + beta) + l_C3*sin(alpha + beta + gamma)) - M_2 + P_3x*(F_3y*cos(alpha + beta + gamma) - F_3x*sin(alpha + beta + gamma)) - P_3y*(F_3x*cos(alpha + beta + gamma) + F_3y*sin(alpha + beta + gamma)) + P_2x*(F_2y*cos(alpha + beta) - F_2x*sin(alpha + beta)) - P_2y*(F_2x*cos(alpha + beta) + F_2y*sin(alpha + beta)) - F_2x*l_C2*sin(alpha + beta) + l_C2*cos(alpha + beta)*(F_2y - (981*m2)/100)
NE_ges_3 = P_3x*(F_3y*cos(alpha + beta + gamma) - F_3x*sin(alpha + beta + gamma)) - M_3 - P_3y*(F_3x*cos(alpha + beta + gamma) + F_3y*sin(alpha + beta + gamma)) - F_3x*l_C3*sin(alpha + beta + gamma) + l_C3*cos(alpha + beta + gamma)*(F_3y - (981*m3)/100)
 

%Aufbau eines Gleichungssystems in Matrixform
eqn1 = NE_ges_1 == 0;
eqn2 = NE_ges_2 == 0;
eqn3 = NE_ges_3 == 0;

%Symbolisches Loesen des Gleichungssystems 

[A,B] = equationsToMatrix([eqn1, eqn2, eqn3],[M_1, M_2, M_3])

%Bestimmen des Loesungsvektors fuer die Momente M1, M2 und M3 in
%Abhaengigkeit der bekannten Groeßen
X_M = linsolve(A,B)

%Pruefen der Loesung durch Ersetzen mit bekannten Groeßen in Skript
%Testskript_Interpretation_Fingermomente


