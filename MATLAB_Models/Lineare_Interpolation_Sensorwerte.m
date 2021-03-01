%Lineare Interpolation der Sensorwerte 
clc

%Lineare Interpolationsformel: y=y1*((y2-y1)/(x2-x1))*(x-x1);

%Sensordaten Gelenk B + Interpolierter unterer Grenzwert
yB = [-5;0;5;10;15;20;25;30;35;40;45;47.5;50;55;60;65;70;75;80;85;90;95;100;105;110;115;120;125;130];
xB = [1385;1453;1521;1575;1624;1682;1739;1790;1850;1916;1980;2100;2132;2200;2264;2323;2380;2440;2501;2559;2607;2657;2712;2771;2816;2877;2933;2975;3017];

%Beispiel: Eingelesener ADC Wert
x=1520;

%Hochzählen des Index, bis Position im Array erreicht
i=2;
%Begrenzen auf Messintervall
if x > xB(length(xB))   %Obere Schranke
    y = yB(length(yB))
elseif x<xB(1)          %Untere Schranke
     y = yB(1)
else                    %Hochzählen in Messreihe
    while (x > xB(i))
    i=i+1;
    end 
    %Ausgabe des ermittelten Index
    i
    %Lineare Interpolation zwischen den bekannten Wertepaaren 
    y=yB(i-1)+((yB(i)-yB(i-1))/(xB(i)-xB(i-1)))*(x-xB(i-1))
    
end