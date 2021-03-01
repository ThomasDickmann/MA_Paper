function [] = plotKinConfig(A,B,C,D,E,F,G,H,J,K,L,MCP,PIP,DIP,FS)
%plotKinConfig plottet die aktuelle Kinematiklage 
%   Muss nach getKinConfig ausgefuehrt werden!

figure
plot([A(1),B(1),C(1),D(1),E(1),A(1)], [A(2),B(2),C(2),D(2),E(2),A(2)], 'b-')
set(gca, 'xdir','reverse')
axis equal
grid on
hold on

plot([A(1),MCP(1),F(1),E(1)], [A(2),MCP(2),F(2),E(2)], 'b-')
plot([F(1),G(1),H(1),D(1)], [F(2),G(2),H(2),D(2)], 'b-')
plot([G(1),PIP(1),K(1),J(1),H(1)], [G(2),PIP(2),K(2),J(2),H(2)], 'b-')
plot([K(1), DIP(1),L(1),J(1)], [K(2), DIP(2),L(2),J(2)], 'b-')
plot([FS(1), L(1)], [FS(2), L(2)], 'b-')
plot([FS(1),DIP(1),PIP(1),MCP(1), -40], [FS(2),DIP(2),PIP(2),MCP(2),0], '-','Color', 'green','LineWidth',2)

ms = 6;

p1=plot(MCP(1),MCP(2),'o', 'MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],'MarkerSize',ms);
p2=plot(PIP(1),PIP(2),'o','MarkerEdgeColor',	[0 1 0],'MarkerFaceColor',	[0 1 0],'MarkerSize',ms);
p3=plot(DIP(1),DIP(2),'o','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',ms);
p4=plot(FS(1),FS(2),'o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',ms);

p5=plot(A(1),A(2),'s','MarkerEdgeColor',[0.4660 0.6740 0.1880],'MarkerFaceColor',[0.4660 0.6740 0.1880],'MarkerSize',ms);
p6=plot(B(1),B(2),'s','MarkerEdgeColor',[0.3010 0.7450 0.9330],'MarkerFaceColor',[0.3010 0.7450 0.9330],'MarkerSize',ms);
p7=plot(K(1),K(2),'s','MarkerEdgeColor',[0.6350 0.0780 0.1840],'MarkerFaceColor',[0.6350 0.0780 0.1840],'MarkerSize',ms);
hold off

legend([p1 p2 p3 p4 p5 p6 p7],{'MCP','PIP','DIP','FS','A', 'B', 'K'})
xlabel('mm')
ylabel('mm')
end


