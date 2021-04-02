%Range of Motion Zeigefinger - Plot
clc 

disp('plotting')

global ld
global lm
global lp
ld=22.5;
lm=25;
lp=45;

%Korrektur: Relativwinkel und Richtung 
alpha_BR=0;
beta_BR=0;
gamma_BR=0;

r_mcp = [0;0];

xpip=lp*cos(alpha_BR);
ypip=lp*sin(alpha_BR);

xdip=xpip+lm*cos(beta_BR);
ydip=ypip+lm*sin(beta_BR);

xtip=xdip+ld*cos(gamma_BR);
ytip=ydip+ld*sin(gamma_BR);

X = [xpip, xdip, xtip];
Y = [ypip, ydip, ytip];

figure 
hold on

%plotten Handruecken
%plot([-60, 0],[0,0],'k-','LineWidth',1.5)
%plotten Punkte
%plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',5)
%plot(xpip,ypip,'ro','MarkerFaceColor','r','MarkerSize',5)
%plot(xdip,ydip,'go','MarkerFaceColor','g','MarkerSize',5)
%plot(xtip,ytip,'bo','MarkerFaceColor','b','MarkerSize',5)
%plotten Phalangen
%plot([0,xpip],[0,ypip],'r','LineWidth',1.5)
%plot([xpip, xdip],[ypip, ydip],'g','LineWidth',1.5)
%plot([xdip, xtip],[ydip, ytip],'b','LineWidth',1.5)
%Plotten aktiver Bewegungsraum
hold on
for i = -14:0.5:86.5
   %plotBR(i,-7,0.6666*-7) -> Keine Hyperextension der Gelenke für BR Ermittlung annehmen 
   plotBR(i,0,0) 
end

for j = 0:1:102.5
plotBR(86.5,j,0.6666*j)
end 

for k = 86.5:-1:-14
    plotBR(k,102.5,0.6666*102.5)
end

for m = 102.5:-1:0
    plotBR(-14,m,0.6666*m)
end

%Plotten funktionaler Bewegungsraum

for l = 23.5:0.5:62.5
   plotBR_alternative(l,23,0.6666*23) 
end

for h = 23:1:86
plotBR_alternative(62.5,h,0.6666*h)
end 

for p = 62.5:-1:23.5
    plotBR_alternative(p,86,0.6666*86)
end

for q = 86:-1:23
    plotBR_alternative(23.5,q,0.6666*q)
end

hold off
ylabel('Abstand zu MCP Gelenk [mm]')
xlabel('Abstand zu MCP Gelenk [mm]')
%lgd = legend;
%lgd.NumColumns = 2;

title('Aktiver und funktionaler Bewegungsraum')

disp('done')
