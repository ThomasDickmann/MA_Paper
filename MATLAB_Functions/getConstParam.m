function [l_G2, l_G3, l_G4, l_G5, l_G6, psi_3, psi_4, psi_5, psi_6] = getConstParam(d)
%getConstParam berechnet die durch den Finger vorgegeben kinematischen
%Parameter bei mittiger Montage der PD und PM Attachments
%   Input: Abstand MCP - erstes PP Att. Gelenk

global l_PP
global l_PM
global l_PD
global h_AP
global h_PD
global h_PM
global h_PP
global l_9

l_G2 = sqrt((h_AP + h_PP)^2+(l_PP - d - l_9)^2);
l_G3 = sqrt((h_AP + h_PP)^2+(d)^2);
l_G4 = sqrt((h_AP + h_PM)^2+(0.5*l_PM)^2);
l_G5 = l_G4; %Bei mittiger Montage gleich
l_G6 = sqrt((h_AP + h_PD)^2+(0.5*l_PD)^2);

psi_6 = acos((l_PD/2)/l_G6);
%psi_6_deg =(psi_6/pi)*180

psi_5 = acos((l_PM/2)/l_G4);
%psi_5_deg =(psi_5/pi)*180

psi_4 = acos(d/l_G3);
%psi_4_deg =(psi_4/pi)*180

psi_3 = acos((l_PP - d - l_9)/l_G2);
%psi_3_deg =(psi_3/pi)*180
end

