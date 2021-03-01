function [] = plotBR(alpha,beta,gamma)
%plotBR plottet den Bewegungsraum des Zeigefingers basierend auf
%uebergebenen Winkelintervallen
%   Die Position der Gelenke und der Fingerspitze wird nach jedem
%   Winkelinkrement geplottet, anschließend wird der Winkel inkrementell
%   verstellt. Die Verhältnisse sind vorgegeben 

global ld
global lm
global lp

%Korrektur: Relativwinkel und Richtung 
alpha=-(pi/180)*alpha;
beta=alpha-(pi/180)*beta;
gamma=beta-(pi/180)*gamma;

r_mcp = [0;0];

xpip=lp*cos(alpha);
ypip=lp*sin(alpha);

xdip=xpip+lm*cos(beta);
ydip=ypip+lm*sin(beta);

xtip=xdip+ld*cos(gamma);
ytip=ydip+ld*sin(gamma);

X = [xpip, xdip, xtip];
Y = [ypip, ydip, ytip];

%plotten Handruecken
%plot([-60, 0],[0,0],'k-','LineWidth',1.5)
%plotten Punkte
%plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',4)
%plot(xpip,ypip,'ro','MarkerFaceColor','r','MarkerSize',4)
%plot(xdip,ydip,'go','MarkerFaceColor','g','MarkerSize',4)
plot(xtip,ytip,'go','MarkerFaceColor','g','MarkerSize',4)
%plotten Phalangen
%plot([0,xpip],[0,ypip],'r','LineWidth',1.5)
%plot([xpip, xdip],[ypip, ydip],'g','LineWidth',1.5)
%plot([xdip, xtip],[ydip, ytip],'b','LineWidth',1.5)
%title('Bewegungsraum Zeigefinger')
xlabel('mm')
ylabel('mm')
%legend('Handrücken','MCP','PIP','DIP','Fingerspitze')
%axis equal
grid on
end

