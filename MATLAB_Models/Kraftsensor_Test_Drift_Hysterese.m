%Kraftsensor Test 
%Daten aus Sensortest_A/B_Final 
%Kalibrierkurven angepasst: 3-Punkt Kurve aus Driftests

%% Testparameter 
%Array der Belastungssufen in den Tests
F_n= [0;4.013;6.916;9.820]
%Gewichte: 119+290, 119+290+296, 119+290+296+296 [g]

%Zeitachse
t_67=1:1:67;
t_62=1:1:62;

%% Sensor A

%Kalibrierkurve Sensor A aus Regression 
%F_A = 0.0035*ADC - 2.2221

%Kalibrierkurve 3-Punkt Sensor A aus Drifttest mit ADC Wert ca. 10s nach Lastwechsel 
%F_A = 0.0035*ADC - 2.4543

%Wahl der Kalibrierungskonstanten 
m_A = 0.0035;
b_A= - 2.4543;

%Drift

%Umrechnung der ADC-Werte in Kraftwerte
A_Drift_cont_F_sc = A_Drift_cont2 .* m_A + b_A
A_Drift_break_F_sc = A_Drift_break .* m_A + b_A

figure
subplot(2,2,1)
%Plot Vergleichskurve: Alle 20 Sekunden Lastwechsel 
plot([0,5,5,28,28,47,47,67,67],[F_n(1),F_n(1),F_n(2),F_n(2),F_n(3),F_n(3),F_n(4),F_n(4),F_n(4)],'Color','#00d400','DisplayName', 'Reale Kraft')
hold on
plot(t_62,A_Drift_cont_F_sc,'Color','#0000FF','DisplayName', 'Gemessen')
grid on
ylabel('Kraft [N]')
xlabel('Zeit [s]')
title('Sensor A: Kontinuierliche Belastung')
hold off
legend

subplot(2,2,3)
%Plot Vergleichskurve: Alle 10 Sekunden Lastwechsel
plot([0,6,6,16,16,25,25,37,37,46,46,57,57,66],[0,0,F_n(2),F_n(2),0,0,F_n(3),F_n(3),0,0,F_n(4),F_n(4),0,0],'Color','#00d400','DisplayName', 'Reale Kraft')
hold on
plot(t_67,A_Drift_break_F_sc,'Color','#0000FF','DisplayName', 'Gemessen')
grid on
ylabel('Kraft [N]')
xlabel('Zeit [s]')
title('Sensor A: Unterbrochene Belastung')
hold off
legend



%% Sensor B 

%Kalibrierkurve Sensor B aus Regression 
%F_B = 0.0038*ADC - 2.6068

%Kalibrierkurve 3-Punkt Sensor B aus Drifttest mit ca. 10s
%F_B = 0.0037*ADC - 2.4657

%Wahl der Kalibrierungskonstanten 
m_B = 0.0037;
b_B= - 2.4657;

%Drift 

%Umrechnung der ADC-Werte in Kraftwerte
B_Drift_cont_F_sc = B_Drift_cont .* m_B + b_B;
B_Drift_break_F_sc = B_Drift_break .*  m_B + b_B;

subplot(2,2,2)
%Plot Vergleichskurve: Alle 20 Sekunden Lastwechsel 
plot([0,6,6,26,26,46,46,66,66],[F_n(1),F_n(1),F_n(2),F_n(2),F_n(3),F_n(3),F_n(4),F_n(4),F_n(4)],'Color','#00d400','DisplayName', 'Reale Kraft')
hold on
plot(t_67,B_Drift_cont_F_sc,'Color','#0000FF','DisplayName', 'Gemessen')
grid on
ylabel('Kraft [N]')
xlabel('Zeit [s]')
title('Sensor B: Kontinuierliche Belastung')
legend
hold off

subplot(2,2,4)
%Plot Vergleichskurve: Alle 10 Sekunden Lastwechsel
plot([0,6,6,16,16,26,26,36,36,45,45,56,56,66],[0,0,F_n(2),F_n(2),0,0,F_n(3),F_n(3),0,0,F_n(4),F_n(4),0,0],'Color','#00d400','DisplayName', 'Reale Kraft')
hold on
plot(t_67,B_Drift_break_F_sc,'Color','#0000FF','DisplayName','Gemessen')
grid on
ylabel('Kraft [N]')
xlabel('Zeit [s]')
title('Sensor B: Unterbrochene Belastung')
legend
hold off



%% Hysteresetest 

%Umrechnung der ADC Werte in Kraftwerte
A_Hysteresis_F_sc = A_Hysteresis .* m_A + b_A;

figure
subplot(1,2,1)
%Plot Vergleichskurve: Alle 10 Sekunden Lastwechsel
plot([0,6,6,17,17,26,26,36,36,46,46,56,56,66],[0,0,F_n(2),F_n(2),F_n(3),F_n(3),F_n(4),F_n(4),F_n(3),F_n(3),F_n(2),F_n(2),0,0],'Color','#00d400','DisplayName', 'Reale Kraft')
hold on
plot(t_67,A_Hysteresis_F_sc,'Color','#0000FF','DisplayName', 'Gemessen')
grid on
ylabel('Kraft [N]')
xlabel('Zeit [s]')
title('Hysteresetest Sensor A')
hold off
axis([0 60 0 11])
legend

%Umrechnung der ADC Werte in Kraftwerte
B_Hysteresis_F_sc = B_Hysteresis .*  m_B + b_B;

subplot(1,2,2)
%Plot Vergleichskurve: Alle 10 Sekunden Lastwechsel
plot([0,6,6,16,16,27,27,36,36,46,46,56,56,66],[0,0,F_n(2),F_n(2),F_n(3),F_n(3),F_n(4),F_n(4),F_n(3),F_n(3),F_n(2),F_n(2),0,0],'Color','#00d400','DisplayName', 'Reale Kraft')
hold on
plot(t_67,B_Hysteresis_F_sc,'Color','#0000FF','DisplayName', 'Gemessen')
grid on
ylabel('Kraft [N]')
xlabel('Zeit [s]')
title('Hysteresetest Sensor B')
hold off
axis([0 60 0 11])
legend

%%
figure 
plot(1,1,'bo','MarkerFaceColor','b','MarkerSize',4,'DisplayName', 'Aktiver BR')
hold on
plot(3,3,'go','MarkerFaceColor','g','MarkerSize',4,'DisplayName', 'Funktionaler BR')
hold on


legend