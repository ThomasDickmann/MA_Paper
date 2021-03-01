%Auswertung CSV Datei von SD Karte
clc

%% Parametrierung des Modells (aus Input_Output_Skript)

% Parameter für kinematisches Modell
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

% Konstante Groeßen der Aktorkinematik (s. Skizze Aktor)
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

% Parameter für dynamisches Modell

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

%% Einlesen der Sensordaten und Kalibrierung
%Rohe Sensordaten von SD Karte einlesen
%Einlesen der Werte aus CSV-Datei von SD Karte per import Data, coloum vector

%Kalibrierdaten Poti B, oben und unten linear erweitert
yB = [-5;0;5;10;15;20;25;30;35;40;45;47.5;50;55;60;65;70;75;80;85;90;95;100;105;110;115;120;125;130;135;140]; %Gradskala Potis B
xB = [1385;1453;1521;1575;1624;1682;1739;1790;1850;1916;1980;2100;2132;2200;2264;2323;2380;2440;2501;2559;2607;2657;2712;2771;2816;2877;2933;2975;3017;3067;3117];
%Kalibrierung Poti A, oben und unten linear erweitert
yA = [-45;-40;-35;-32.5;-30;-25;-20;-15;-10;-5;0;5;10;15;20;25;30;35;40;45;50;55;60;65];
xA = [1830;1897;1964;2088;2120;2184;2238;2299;2359;2410;2471;2508;2565;2618;2670;2736;2795;2853;2903;2970;3034;3095;3156;3217];
%Kalibrierung Poti K, oben und unten linear erweitert
yK = [5;10;15;20;25;30;35;40;45;50;55;60;62.5;65;70;75;80;85];
xK = [1390;1443;1496;1529;1594;1634;1689;1743;1811;1874;1930;1998;2136;2175;2242;2295;2367;2439];


%Öffnen einer Figure für Plot -> Nacheinander Loopen für verschiedene Plots
%Positionen MCP(0,0), PIP, DIP, FS über Bewegungsverlauf 
%Subplot 3x3
%Oben: Jeweils Gelenkwinkel MCP PIP DIP
%Unten: Jeweils Gelenkmomente MMCP MPIP MDIP

%Einlesen aller Messdaten in Arrays
W_MCP = zeros(length(Zeit_ms),1);
W_DIP = zeros(length(Zeit_ms),1);
W_PIP = zeros(length(Zeit_ms),1);

M_MCP = zeros(length(Zeit_ms),1);
M_DIP = zeros(length(Zeit_ms),1);
M_PIP = zeros(length(Zeit_ms),1);

P_FS = zeros(length(Zeit_ms),2);

%% Loopen über alle Wertetupel und plotten des Ergebnisses 
%Übergeben der Werte Schrittweise an CSV Interpretation 

for i=1:1:length(Zeit_ms)

    %Berechnen der Winkel auf Basis der Messwerte
    phid_B = calcAngleInterpol(angleB(i), xB, yB);
    phid_A = calcAngleInterpol(angleA(i), xA, yA);
    phid_K = calcAngleInterpol(angleK(i), xK, yK);

    %Umrechnen der Werte in Radiant
    phi_B = (pi/180) * phid_B;
    phi_A = (pi/180) * phid_A;
    phi_K = (pi/180) * phid_K;

    %Bestimmen der Kraftwerte aus CSV-File (Kalibrierung eingebaut)
    force_F = 0.0033*forceB(i) - 2.2402;    %Sensor B
    force_B = 0.0036*forceA(i) - 2.0806;    %Sensor A

    % Auswertung der Sensordaten über Interpretationsfunktion
    [FS_r, PIP_r,DIP_r, phid_MCP, phid_PIP, phid_DIP, T_MCP, T_PIP, T_DIP] = CSV_Interpretation(phi_B, phi_A, phi_K, force_F, force_B);

      
    %Ablegen der berechneten Daten in Arrays
    W_MCP(i) = phid_MCP; 
    W_DIP(i) = phid_PIP; 
    W_PIP(i) = phid_DIP; 
    
    M_MCP(i) = T_MCP;
    M_PIP(i) = T_PIP; 
    M_DIP(i) = T_DIP;
    
    P_FS(i,1) = FS_r(1);
    P_FS(i,2) = FS_r(2);
    
    plot(FS_r(1),FS_r(2),'ro','MarkerFaceColor','r','MarkerSize',4)
    hold on 
end

plot(100,100,'ro','MarkerFaceColor','r','MarkerSize',4)

ylabel('Abstand zu MCP Gelenk [mm]')
xlabel('Abstand zu MCP Gelenk [mm]')
title('Vergleich der Bewegungsräume')
pFS = plot(FS_r(1),FS_r(2),'ro','MarkerFaceColor','r','MarkerSize',5,'DisplayName', 'Exoskelett BR')
legend([p1 p2 pFS],{'Aktiver BR','Funktioneller BR', 'Exoskelett BR'})

%%

%Achsenskalierung:
ang_min = -50;
ang_max = 13;
tor_min = -0.1;
tor_max = 0.16;

figure
%Gelenkwinkel MCP
subplot(2, 3, 1);
plot(Zeit_ms/1000, W_MCP,'Color','#0000FF');
grid on
ylabel('Winkel [deg]')
xlabel('Zeit [s]')
title('Winkeltrajektorie MCP')
axis([0 22 ang_min ang_max])
xline(7.481,'--r');
hold on 
%Gelenkwinkel PIP
subplot(2, 3, 2);
plot(Zeit_ms/1000, W_PIP,'Color','#00d400');
grid on
ylabel('Winkel [deg]')
xlabel('Zeit [s]')
title('Winkeltrajektorie PIP')
axis([0 22 ang_min ang_max])
hold on
%Gelenkwinkel DIP
subplot(2, 3, 3);
plot(Zeit_ms/1000, W_DIP,'Color','#A2142F');
grid on
ylabel('Winkel [deg]')
xlabel('Zeit [s]')
title('Winkeltrajektorie DIP')
axis([0 22 ang_min ang_max])
hold on


%Gelenkmoment MCP 
subplot(2, 3, 4);
plot(Zeit_ms/1000, M_MCP,'Color','#0000FF');
grid on
ylabel('Gelenkmoment [Nm]')
xlabel('Zeit [s]')
title('Momenttrajektorie MCP')
axis([0 22 tor_min tor_max])
hold on
%Gelenkmoment PIP
subplot(2, 3, 5);
plot(Zeit_ms/1000, M_PIP,'Color','#00d400');
grid on
ylabel('Gelenkmoment [Nm]')
xlabel('Zeit [s]')
title('Momenttrajektorie PIP')
axis([0 22 tor_min tor_max])
hold on
%Gelenkmoment DIP 
subplot(2, 3, 6);
plot(Zeit_ms/1000, M_DIP,'Color','#A2142F');
grid on
ylabel('Gelenkmoment [Nm]')
xlabel('Zeit [s]')
title('Momenttrajektorie DIP')
axis([0 22 tor_min tor_max])
hold on


h=gcf;
set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
print(gcf, '-dpdf', 'test3.pdf');