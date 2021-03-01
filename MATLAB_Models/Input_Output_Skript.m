clc
%Skript zur Auswertung der Positionen und Kraefte des Exoskelettsystems

%% Parameter für kinematisches Modell
%Gliedlaengen Kinematik (s.Skizze)
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

l_1= 45;
l_2= 35;
l_3= 31;
l_4= 22;
l_5= 15;
l_6= 25;
l_7= 38;
l_8= 34;
l_9= 10;
l_10=38;
l_11=23;
l_12=28;

%Parameter der Finger (aus Scan der Hand oder abgemessen)
%Laengen der Fingerglieder
global l_PP
global l_PM
global l_PD
l_PP =45;
l_PM=25;
l_PD=22.5;

%Abstand Verbindungsstecke zwischen Fingergelenken zu Oberseite der Fingerglieder
global h_PD
global h_PM
global h_PP
h_PD = 7; 
h_PM = 7;
h_PP = 8;

%Abstand Oberseite der Finger zu Gelenken der Phalanxmodule
global h_AP
h_AP = 5.5;

%Konstante, durch Finger definierte kin. Groeßen aus geg. Parametern berechnen 
%Uebergeben von Abstand d von MCP Phalanxmodul (s.Skizze)
global l_G2
global l_G3
global l_G4
global l_G5
global l_G6
global psi_3
global psi_4
global psi_5
global psi_6

[l_G2,l_G3,l_G4,l_G5,l_G6,psi_3,psi_4,psi_5,psi_6] = getConstParam(12);

%Weltsystem in MCP, x-Achse nach links gerichtet
global MCP
MCP=[0;0];

%Position Gelenk A: Messen notwendig, Position relativ zu MCP muss bestimmt
%werden. Hier Werte aus mechanischem Finger gegeben, real aus Foto/Scan
%bestimmen
global A
A = [-2.952;16.7417];

%Abstand l_G1 und Winkel psi_2 aus Positionen A und MCP berechnen 
l_G1 = sqrt((0-A(1))^2+(0-A(2))^2);
psi_2 = acos((-A(1))/l_G1); 
%psi_2_deg =(psi_2/pi)*180

%Konstruktiv definierter Winkel X-Achse zu Strecke AB (in math. pos. Sinn)
psi_1 = ((180-35)/360)*2*pi;

%Position Gelenk B berechnen
global B
B=[A(1)+l_5*cos(psi_1);A(2)+l_5*sin(psi_1)];

%% Konstante Groeßen der Aktorkinematik (s. Skizze Aktor)
%Parametrisch durch Aktorlagerposition relativ zu Gelenk B definiert)
global akt_x
global akt_y
global theta
global l_s
global alpha_const
global l_Akt
global d_b

l_Akt = 102 + 37.3; %Bezeichnet die Länge von Aktorverbund in minimal ausgefahrener Länge (Aktorlänge plus Länge Kraftsensorverbund)
akt_x = -160.761; %Aktorgelenkmountposition hinten relativ zu Gelenk B
akt_y = -9.845; %Aktorgelenkmountposition hinten relativ zu Gelenk B 
theta = (pi/180)*35; %Winkel zwischen kurzer und langer Schwinge in l_1
l_s = 20; %Laenge der kurzen Schwinge in l_1
d_b = sqrt((0-akt_x)^2+(0-akt_y)^2); %Abstand B und Aktoraufhaengung

%Konstanter Winkel zwischen x-Achse und Verbindungsgraden Gelenk B und Aktoraufhaengung
alpha_const = pi + getAngle(0,0,akt_x,akt_y);

%% Parameter für dynamisches Modell

%Laengen bis zu den jeweiligen Schwerpunkten der Finger (s. Skizze) -->
%Später in Paramterteil definieren!
global l_C1
global l_C2
global l_C3
l_C1 = l_PP/2;
l_C2 = l_PM/2;
l_C3 = l_PD/2;


%Versatz zwischen jeweiligem Koerperschwerpunkt und den Angriffspunkten der
%Stabkraefte
global P_11x 
global P_11y 
global P_12x 
global P_12y 
global P_2x 
global P_2y 
global P_3x 
global P_3y 
P_11x = 0.5;
P_11y = h_PP + h_AP; 
P_12x = 10.5;
P_12y = h_PP + h_AP; 

P_2x = 0;
P_2y = h_PM + h_AP; 

P_3x = 0;
P_3y = h_PD + h_AP; 

%Traegheiten der einzelnen Fingerglieder (Werte aus vereinfachtem CAD Modell)

%Massen der einzelnen Fingerglieder
global m1
global m2
global m3
m1= 0.0; 
m2= 0.0;
m3= 0.0;

%% Ab hier: Auswertung nach Einlesen der Sensorwerte für Position und Kraft

%Encoderwinkel - Werden durch Array aus Messdaten bereitgestellt
phi_B=(130/360)*2*pi; %Winkel an Antriebsglied 
% phi_B kann bei idealem Tracking der Positionsregelung mit getActuationAngle berechnet werden, 
%sodass kein Encoder nötig ist. Mit Encoderwinkel und Kraftmessungswert
%können jedoch stets genaue Wertepaare von Winkel und Kraft berechnet
%werden. 
phi_A=(52.21/360)*2*pi; %zweiter Winkel an Handruecken
phi_K=(80/360)*2*pi; %Winkel an Verbindung med. bez. auf x-Achse med.

%Sensorwert für momentane Aktorkraft
F_Aktor = 10;

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

%Plotten der Kinematiklage
plotKinConfig(A,B,C,D,E,F,G,H,J,K,L,MCP,PIP,DIP,FS)

%% Ausgabe der Fingergliedwinkel in deg aus berechneter Kinematikkonfiguration [Check]
[alpha_d, beta_d, gamma_d] = getJointAnglesDeg(PIP,DIP,FS)
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

%Plotten der einzelnen Phalanxkraefte in Koerpersystemen
%figure
%forces=[F_PD_x,F_PD_y,F_PM_x,F_PM_y,F1_PP_x,F1_PP_y,F2_PP_x,F2_PP_y];
%bar(forces)
%TODO: Prüfen der Werte mit KS in Simscape, X-Achse der Grafik beschriften 

%% Dynamisches Modell des Fingers, quasistatischer Zustand

%Berechnen der Fingermomente aus Gelenkwinkeln und externen Kraeften auf
%Fingerglieder 

%Testweise überschreiben von Kraeften und Winkeln zum Absichern der
%Funktion [Check]

[M_MCP, M_PIP, M_DIP] = getJointTorques(alpha,beta,gamma,F_3x,F_3y,F_4x,F_4y,F_5x,F_5y,F_6x,F_6y)