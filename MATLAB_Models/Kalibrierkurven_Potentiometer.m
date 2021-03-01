%% Kalibrierkurven Lagesensoren erstellen 
clc

%Winkelpositionen Poti B
yB = [0;5;10;15;20;25;30;35;40;45;47.5;50;55;60;65;70;75;80;85;90;95;100;105;110;115;120;125]; %Gradskala Potis B
%ADC Werte an Winkelpositionen Poti B
xB = [1453;1521;1575;1624;1682;1739;1790;1850;1916;1980;2100;2132;2200;2264;2323;2380;2440;2501;2559;2607;2657;2712;2771;2816;2877;2933;2975];

%Skalierung der Werte für Annhäherung mit Polynomen höherer Ordnung
%[coeffs_B, S, mu] = polyfit(xB, yB, 8)
%fitted_yB = polyval(coeffs_B, xB, S, mu) %Gibt zurückskaliere Werte aus

%Fitten eines Polynoms erster Ordnung, Error Estimation als 2. Rückgabewert
pB = polyfit(xB,yB,1)

%Auswertung des gefitteten Polynoms an den Stellen xB
yB_fitted = polyval(pB,xB); %Gibt zurückskaliere Werte aus

%Plot der fitted Kurve
figure
subplot(3,1,1)
plot(xB, yB, '*','Color','#0000FF','DisplayName', 'Messpunkte');
hold on;
plot(xB, yB_fitted, 'Color','#00d400','DisplayName', 'lin. Regression');
hold on
ylabel('Winkel [Grad]')
xlabel('Outputwert ADC')
title('Positionssensor Gelenk B')
grid on;
legend

%Berechnung der Residuen
fehler_B = yB - polyval(pB,xB);

%Berechnung des Standardfehlers
fehler_quad_B = fehler_B.^2;
SER_B = sqrt(sum(fehler_quad_B)/(length(yB)-2))

%Plot der Residuen 
%plot(xB, fehler_B,'r+', 'MarkerSize', 3)
%grid on 
%% Polyfitting für Sensor Gelenk K

%xK = [0; 20; 45; 60; 90; 120; 135; 160; 180]
%yK = [349; 410; 471; 545; 640; 724; 766; 843; 907];

%Kalibrierung 12 bit, 5° Schritte
yK = [10;15;20;25;30;35;40;45;50;55;60;62.5;65;70;75;80];
xK = [1443;1496;1529;1594;1634;1689;1743;1811;1874;1930;1998;2136;2175;2242;2295;2367];

pK = polyfit(xK, yK, 1)

subplot(3,1,3)
plot(xK,yK,'*','Color','#0000FF','DisplayName', 'Messpunkte')
hold on 
plot(xK,polyval(pK,xK),'Color','#00d400','DisplayName', 'lin. Regression')
ylabel('Winkel [Grad]')
xlabel('Outputwert ADC')
title('Positionssensor Gelenk K')
grid on
legend

%Berechnung der Residuen
fehler_K = yK - polyval(pK,xK);

%Berechnung des Standardfehlers
fehler_quad_K = fehler_K.^2;
SER_K = sqrt(sum(fehler_quad_K)/(length(yK)-2))

%% Polyfitting für Sensor Gelenk A

%Wertepaare 10 bit 
%xA = [-60; -45; -20; 0; 20; 45; 60; 90]; %Grad
%yA = [279; 315; 383; 437; 534; 597; 643;713]; %ADC Wert

%Kalibrierung Gelenk A, 12 bit
yA = [-40;-35;-32.5;-30;-25;-20;-15;-10;-5;0;5;10;15;20;25;30;35;40;45;50;55];
xA = [1897;1964;2088;2120;2184;2238;2299;2359;2410;2471;2508;2565;2618;2670;2736;2795;2853;2903;2970;3034;3095];

pA = polyfit(xA, yA, 1)

%Berechnung der Residuen
fehler_A = yA - polyval(pA,xA);

%Berechnung des Standardfehlers
fehler_quad_A = fehler_A.^2;
SER_A = sqrt(sum(fehler_quad_A)/(length(yA)-2))

subplot(3,1,2)
plot(xA,yA,'*','Color','#0000FF','DisplayName', 'Messpunkte')
hold on 
plot(xA,polyval(pA,xA),'Color','#00d400','DisplayName', 'lin. Regression')
ylabel('Winkel [Grad]')
xlabel('Outputwert ADC')
title('Positionssensor Gelenk A')
grid on
legend
