function [F_PD_x,F_PD_y,F_PM_x,F_PM_y,F1_PP_x,F1_PP_y,F2_PP_x,F2_PP_y] = getPhalanxForces(alpha, beta, gamma, F_3x,F_3y,F_4x,F_4y,F_5x,F_5y,F_6x,F_6y)
%getPhalanxForces dreht die externen Kraefte auf die Fingerglieder vom WS in das jew. KS
%   Damit können die Kräfte auf die einzelnen Glieder sinnvoller visualisiert
%   werden. 

%Drehmatrix Inertial nach KS1
A_10 = [cos(alpha) sin(alpha) 0; -sin(alpha) cos(alpha) 0; 0 0 1];

%Drehmatrix Inertial nach KS2
A_21 = [cos(beta) sin(beta) 0; -sin(beta) cos(beta) 0; 0 0 1];
A_20 = A_21*A_10;
%Drehmatrix Inertial nach KS3

A_32 = [cos(gamma) sin(gamma) 0; -sin(gamma) cos(gamma) 0; 0 0 1];
A_30 = A_32*A_21*A_10;

F_PD = [F_6x; F_6y; 0];
F_PM = [F_5x; F_5y; 0];
F1_PP = [F_4x; F_4y; 0];
F2_PP = [F_3x; F_3y; 0];

F_PD_3 = A_30 * F_PD;
F_PM_2 = A_20 * F_PM;
F1_PP_1 = A_10 * F1_PP;
F2_PP_1 = A_10 * F2_PP;

F_PD_x = F_PD_3(1);
F_PD_y = F_PD_3(2);
F_PM_x = F_PM_2(1);
F_PM_y = F_PM_2(2);
F1_PP_x = F1_PP_1(1);
F1_PP_y = F1_PP_1(2);
F2_PP_x = F2_PP_1(1);
F2_PP_y = F2_PP_1(2);
end

