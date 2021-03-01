function [FS_r, PIP_r, DIP_r, phid_MCP, phid_PIP, phid_DIP, T_MCP, T_PIP, T_DIP] = CSV_Interpretation(phi_B, phi_A, phi_K, force_F, force_B)
%CSV_Interpretation berechnet aus Basis der Messdaten im CSV-File die Diagnosedaten 
%   Inputs: Winkel in RAD, Kräfte in Newton    
%   Auszugebende Informationen für Plots etc.: 
%   Position FS
%   Gelenkwinkel MCP, PIP, DIP in Degree
%   Momente M_MCP, M_PIP, M_DIP in Nmm

%   Input_Output muss einmal durchgelaufen sein, um den globalen Variablen
%   Werte zuzuweisen! (Inkl. getConstParam.m)

%Globale Variablen aus Parametierungs Input_Output_Skript -> Prüfen!
global l_1 
global l_2 
global l_3 
global l_4 
global l_5 
global l_6 
global l_7
global l_8
global l_9
global l_10
global l_11
global l_12 

global l_PP
global l_PM
global l_PD

global h_PD
global h_PM
global h_PP
global h_AP

global l_G2
global l_G3
global l_G4
global l_G5
global l_G6
global psi_3
global psi_4
global psi_5
global psi_6

global MCP
global A
global B

global akt_x
global akt_y
global theta
global l_s
global alpha_const
global l_Akt
global d_b

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

global m1
global m2
global m3

%% Ab Hier: Auswertung nach Einlesen der Sensorwerte für Position und Kraft

%Encoderwinkel - Werden durch Array aus Messdaten bereitgestellt

%Sensorwert für momentane Aktorkraft
F_Aktor = force_F - force_B; %Herausrechnen eventueller Vorspannkräfte - TODO: Prüfen!


%% Lageberechnung nach Sensorinput [Check]
%Positionen der verbleibenden Gelenke und der Fingerspitze durch Auswertung
%der Encoderwinkel
global C
global E
global D
global F
global G
global H
global J
global K
global L
global PIP
global DIP
global FS
[C,E,D,F,G,H,J,K,L,PIP,DIP,FS] = getKinConfig(phi_A, phi_B, phi_K); %Auf Reihenfolge der uebergebenen Winkel achten!

%Plotten der Kinematiklage TODO: Nur zum Testen, sonst rauswerten
%Je nach gewünschtem Outcome in Script. Ohne Plot: Aufrufen von custom Plot command
%in Loop in .m Skript nach jedem Funktionsdurchlauf 
%plotKinConfig(A,B,C,D,E,F,G,H,J,K,L,MCP,PIP,DIP,FS)

%% Ausgabe der Fingergliedwinkel in deg aus berechneter Kinematikkonfiguration [Check]
[alpha_d, beta_d, gamma_d] = getJointAnglesDeg(PIP,DIP,FS);
%phi_MCP_d
%phi_PIP_d
%phi_DIP_d

% Berechnen der Fingerwinkel in rad fuer Auswertung der Dynamik 
[alpha, beta, gamma] = getJointAnglesRad(PIP,DIP,FS);

%% Berechnung der Stabwinkel aus Gelenkpositionen 
%Berechnen der Stabwinkel aus Koordinaten
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
phi_1=getAngle(B(1),B(2),C(1),C(2));
phi_2=getAngle(C(1),C(2),D(1),D(2));
phi_3=getAngle(E(1),E(2),D(1),D(2));
phi_4=getAngle(A(1),A(2),E(1),E(2));
phi_6=getAngle(E(1),E(2),F(1),F(2));
phi_7=getAngle(D(1),D(2),H(1),H(2));
phi_8=getAngle(G(1),G(2),H(1),H(2));
phi_10=getAngle(H(1),H(2),J(1),J(2));
phi_11=getAngle(K(1),K(2),J(1),J(2));
phi_12=getAngle(J(1),J(2),L(1),L(2));

%% Funktion: Berechnen der externen Kräfte auf Finger aus Stabwinkeln und Kraeftegleichgewichten [Check]
%Uebergabe von Kraftmesswert und aktuellem Schwingenwinkel
[F_ext_x,F_ext_y]=getActuationForce(F_Aktor, phi_B);

%[Modell mit Simscape validiert ab Antriebsmoment M_B]. Kontaktkraefte in KS der Phalangen und
%Fingergelenksmomente stimmen mit physikalischem Modell überein  

%Berechnung der Lagerreaktionen Kinematikgelenken in WS (Simplify Loesungen aus linsolve[A,B]in Kraftfluss_Kinematik.m)
[F_1x,F_1y,F_2x,F_2y,F_3x,F_3y,F_4x,F_4y,F_5x,F_5y,F_6x,F_6y] = getExtForces(F_ext_x, F_ext_y);

%Drehen der Kraefte in jew. eigenes Koerpersystem zur Visualisierung 
[F_PD_x,F_PD_y,F_PM_x,F_PM_y,F1_PP_x,F1_PP_y,F2_PP_x,F2_PP_y]=getPhalanxForces(alpha,beta,gamma,F_3x,F_3y,F_4x,F_4y,F_5x,F_5y,F_6x,F_6y);
%Drehmatrizen aus NE Skript (Rotationsmatrizen für alle Koeper)

%% Dynamisches Modell des Fingers, quasistatischer Zustand

%Berechnen der Fingermomente aus Gelenkwinkeln und externen Kraeften auf
%Fingerglieder 

%Testweise überschreiben von Kraeften und Winkeln zum Absichern der
%Funktion [Check]

[M_MCP, M_PIP, M_DIP] = getJointTorques(alpha,beta,gamma,F_3x,F_3y,F_4x,F_4y,F_5x,F_5y,F_6x,F_6y);
    
FS_r = [FS(1),FS(2)];
PIP_r = [PIP(1),PIP(2)];
DIP_r = [DIP(1),DIP(2)];
phid_MCP = alpha_d;
phid_PIP = beta_d;
phid_DIP = gamma_d;
T_MCP = M_MCP;
T_PIP = M_PIP;
T_DIP = M_DIP;
end

