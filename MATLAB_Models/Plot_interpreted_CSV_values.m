%%Plotten der aufgenommenen .mat Variablen aus Auswertungsskript_CSV
clc

%Achsenskalierung:
ang_min = -50;
ang_max = 10;
tor_min = -0.04;
tor_max = 0.13;

%Variable Vertical Line
vline_val = 7.01;
vline_val_2 = 10.9;


figure
%Gelenkwinkel MCP
subplot(2, 3, 1);
plot(Zeit_ms/1000, W_MCP,'Color','#0000FF');
grid on
ylabel('Winkel [deg]')
xlabel('Zeit [s]')
title('Winkeltrajektorie MCP')
axis([0 22 ang_min ang_max])
xline(vline_val,'--k');
xline(vline_val_2,'--k');
hold on 
%Gelenkwinkel PIP
subplot(2, 3, 2);
plot(Zeit_ms/1000, W_PIP,'Color','#00d400');
grid on
ylabel('Winkel [deg]')
xlabel('Zeit [s]')
title('Winkeltrajektorie PIP')
axis([0 22 ang_min ang_max])
xline(vline_val,'--k');
xline(vline_val_2,'--k');
hold on
%Gelenkwinkel DIP
subplot(2, 3, 3);
plot(Zeit_ms/1000, W_DIP,'Color','#A2142F');
grid on
ylabel('Winkel [deg]')
xlabel('Zeit [s]')
title('Winkeltrajektorie DIP')
axis([0 22 ang_min ang_max])
xline(vline_val,'--k');
xline(vline_val_2,'--k');
hold on



%Gelenkmoment MCP 
subplot(2, 3, 4);
plot(Zeit_ms/1000, M_MCP,'Color','#0000FF');
grid on
ylabel('Gelenkmoment [Nm]')
xlabel('Zeit [s]')
title('Momenttrajektorie MCP')
axis([0 22 tor_min tor_max])
xline(vline_val,'--k');
xline(vline_val_2,'--k');
hold on
%Gelenkmoment PIP
subplot(2, 3, 5);
plot(Zeit_ms/1000, M_PIP,'Color','#00d400');
grid on
ylabel('Gelenkmoment [Nm]')
xlabel('Zeit [s]')
title('Momenttrajektorie PIP')
axis([0 22 tor_min tor_max])
xline(vline_val,'--k');
xline(vline_val_2,'--k');
hold on
%Gelenkmoment DIP 
subplot(2, 3, 6);
plot(Zeit_ms/1000, M_DIP,'Color','#A2142F');
grid on
ylabel('Gelenkmoment [Nm]')
xlabel('Zeit [s]')
title('Momenttrajektorie DIP')
axis([0 22 tor_min tor_max])
xline(vline_val,'--k');
xline(vline_val_2,'--k');
hold on

%%Speichern des Plots als PDF mit automatischer Skalierung in Landscape

h=gcf;
set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
print(gcf, '-dpdf', 'test3.pdf');
