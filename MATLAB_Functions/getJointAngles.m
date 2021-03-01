function [phi_MCP, phi_PIP, phi_DIP] = getJointAnglesDeg(PIP,DIP,FS)
%getJointAngles berechnet die Fingergelenkwinkel aus den bestimmten
%Gelenkpositionen
%   Muss nach getKinConfig ausgefuehrt werden! 

%Winkel proximales Glied im Weltsystem
phi_prox_w=getAngle(0,0,PIP(1),PIP(2));
phi_MCP=phi_prox_w*(180/pi);

%Winkel mediales Glied in Weltsystem 
phi_med_w=getAngle(PIP(1),PIP(2),DIP(1),DIP(2));
%Winkel PIP Gelenk zwischen PP und PM
phi_PIP=phi_med_w*(180/pi)-phi_MCP;

%Winkel distales Glied
phi_dist_w=getAngle(DIP(1),DIP(2),FS(1),FS(2));
%Winkel DIP Gelenk zwischen PM und PD
phi_DIP=phi_dist_w*(180/pi)-phi_PIP-phi_MCP;

end

