function [x_] = kinematischesModell(x, phi_r,phi_r_alt, phi_l, phi_l_alt)
%KINEMATISCHESMODELL Schätzt die Position des EV3 mit Differential Antrieb

%% Modell des Differential Drives
L = 0.06;           % Halber Achsabstand in Meter
D = 0.052;          % Rad Durchmesser in Meter

A = eye(3);


dphi_r = phi_r - phi_r_alt;
dphi_l = phi_l - phi_l_alt;

l_r = (2*pi/360) * double(dphi_r) * (D/2);
l_l = (2*pi/360) * double(dphi_l) * (D/2);

ds = (l_r + l_l) / 2;
dphi = (l_l - l_r) / (2*L);

% Berechung der geschätzte Pose
x_ = A*x + [cos(x(3)) 0; sin(x(3)) 0; 0 1] * [ds; dphi];
end

