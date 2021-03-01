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
alpha_r=-(pi/180)*alpha;
beta_r=alpha_r-(pi/180)*beta;
gamma_r=beta_r-(pi/180)*gamma;

r_mcp = [0;0];

xpip=lp*cos(alpha_r);
ypip=lp*sin(alpha_r);

xdip=xpip+lm*cos(beta_r);
ydip=ypip+lm*sin(beta_r);

xtip=xdip+ld*cos(gamma_r);
ytip=ydip+ld*sin(gamma_r);

X = [xpip, xdip, xtip];
Y = [ypip, ydip, ytip];

%plotten Handruecken
%plot([-60, 0],[0,0],'k-','LineWidth',1.5)
%plotten Punkte
%plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',4)
%plot(xpip,ypip,'ro','MarkerFaceColor','r','MarkerSize',4)
%plot(xdip,ydip,'go','MarkerFaceColor','g','MarkerSize',4)
plot(xtip,ytip,'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
%plotten Phalangen
%plot([0,xpip],[0,ypip],'r','LineWidth',1.5)
%plot([xpip, xdip],[ypip, ydip],'g','LineWidth',1.5)
%plot([xdip, xtip],[ydip, ytip],'b','LineWidth',1.5)
%title('Bewegungsraum Zeigefinger')
%xlabel('mm')
%ylabel('mm')
%legend('Handrücken','MCP','PIP','DIP','Fingerspitze')
%axis equal
%grid on
end

