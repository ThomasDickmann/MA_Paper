function [alpha, beta, gamma] = getJointAnglesRad(PIP,DIP,FS)
%getJointAngles berechnet die Fingergelenkwinkel aus den bestimmten
%Gelenkpositionen
%   Muss nach getKinConfig ausgefuehrt werden! 

%Winkel proximales Glied im Weltsystem
phi_prox_w = getAngle(0,0,PIP(1),PIP(2));
alpha = phi_prox_w;
%alpha_d = (phi_prox_w/pi)*180

%Winkel mediales Glied in Weltsystem 
phi_med_w = getAngle(PIP(1),PIP(2),DIP(1),DIP(2));
%Winkel PIP Gelenk zwischen PP und PM
beta = phi_med_w-alpha;
%beta_d = phi_med_w*(180/pi) - alpha_d

%Winkel distales Glied
phi_dist_w = getAngle(DIP(1),DIP(2),FS(1),FS(2));
%Winkel DIP Gelenk zwischen PM und PD
gamma = phi_dist_w - beta - alpha;
%gamma_d = phi_dist_w*(180/pi) - beta_d - alpha_d

end

