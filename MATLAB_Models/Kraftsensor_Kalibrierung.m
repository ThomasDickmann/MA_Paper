%Kalibrierung und Test Kraftsensoren 
clc

%% Nicht verbauter Zustand
%Sensor A: Schrift oben/vorne, keine farbl. Markierung
a_w=[0;1.167;2.335;3.502;4.022;4.667;5.837;6.867;7.387;8.554;9.722;10.889;12.056];
a_adc=[685;955;1339;1675;1780;1999;2360;2570;2690;3050;3490;3894;4086];

%Sensor B ist blau markiert, Anschluss auf GND Seite der Schaltung
b_w=[0;1.167;2.234;3.483;4.022;4.649;5.807;6.965;7.387;8.554;9.712;10.232;11.399;12.567;13.076];
b_adc=[680;950;1299;1600;1730;1955;2260;2550;2670;2950;3220;3440;3735;3995;4085];

figure
subplot(1,2,1)
% Ausgleichsgrade: Polynom 1. Grades:
ya = polyfit(a_adc,a_w,1)
%Plotte Punkte sowie Ausgleichsgrade
plot(a_adc,polyval(ya,a_adc),'Color','#00d400','DisplayName', 'lin. Regression')
hold on 
plot(a_adc,a_w,'*','MarkerEdgeColor','#0000FF','DisplayName', 'Messpunkte') 
grid on
ylabel('Kraft [N]')
xlabel('Outputwert ADC')
title('Sensor A, nicht montiert')
axis([500 4500 0 14])
legend
subplot(1,2,2)
%Ausgleichsgrade: Polynom 1. Grades:
yb = polyfit(b_adc,b_w,1)
%Plotte Punkte sowie Ausgleichsgrade
plot(b_adc,polyval(yb,b_adc),'Color','#00d400','DisplayName', 'lin. Regression')
hold on 
plot(b_adc,b_w,'*','MarkerEdgeColor','#0000FF','DisplayName', 'Messpunkte') 
grid on
ylabel('Kraft [N]')
xlabel('Outputwert ADC')
title('Sensor B, nicht montiert')
axis([500 4500 0 14])
legend

%Auswertung der Reressionen 

%Berechnung der Residuen
fehler_A = a_w - polyval(ya,a_adc);

%Berechnung des Standardfehlers
SER_A = sqrt(sum(fehler_A.^2)/(length(a_w)-2))

%Berechnung der Residuen
fehler_B = b_w - polyval(yb,b_adc);

%Berechnung des Standardfehlers
SER_B = sqrt(sum(fehler_B.^2)/(length(b_w)-2))



%Kalibrierung auf Basis von drei Werten nach 5 Sekunden

%Sensor A
cal_f=[0;4.013;9.820];
val_a=[690;1856;3488];

kal_a = polyfit(val_a,cal_f,1)

%Sensor B 
val_b=[679;1750;3349];
kal_b = polyfit(val_b,cal_f,1)

