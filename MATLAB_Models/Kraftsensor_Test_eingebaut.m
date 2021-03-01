%Sensortest eingebauter Zustand
clc

%Gewichte Zugbelastung [g] - Sensor A
w_z=[438;734;1030];
f_A=w_z.*(9.81/1000);
adc_A = [1730;2590;3320];
    
%Gewichte Druckbelastung [g] - Sensor B 
w_d=[306;575;865];
f_B=w_d.*(9.81/1000);
adc_B = [1535;2450;3170];

%Dreipunktkalibrierung: 

kal_A = polyfit(adc_A,f_A,1)
kal_B = polyfit(adc_B,f_B,1)

figure
subplot(1,2,1)
%Plotte Punkte sowie Ausgleichsgrade
plot(adc_A,polyval(kal_A,adc_A),'Color','#00d400','DisplayName', 'Kalibriergerade')
hold on 
plot(adc_A,f_A,'*','MarkerEdgeColor','#0000FF','DisplayName', 'Messpunkte') 
grid on
ylabel('Kraft [N]')
xlabel('Outputwert ADC')
title('Sensor A, montiert')
axis([1500 3500 2.5 10.5])
legend
subplot(1,2,2)
%Plotte Punkte sowie Ausgleichsgrade
plot(adc_B,polyval(kal_B,adc_B),'Color','#00d400','DisplayName', 'Kalibriergerade')
hold on 
plot(adc_B,f_B,'*','MarkerEdgeColor','#0000FF','DisplayName', 'Messpunkte') 
grid on
ylabel('Kraft [N]')
xlabel('Outputwert ADC')
title('Sensor B, montiert')
axis([1500 3500 2.5 10.5])
legend