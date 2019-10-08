function [x, P] = kalmanFilterEV3(phi_r, phi_l, phi_gyro, ...
    phi_r_alt, phi_l_alt, phi_gyro_alt, x, P)

%% Parameter
alpha = [0.1, 0.1, 0.1, 0.1];       % Odometry Fehler (beliebig gewählt)

H = [0 0 1]; % Beobachtungsmatrix
R = 0.01; 

%% Schätze Position

% Schätze Position
x_ = kinematischesModell(x, phi_r, phi_r_alt, phi_l, phi_l_alt);

% Berechne Deltas für Fehlerabschätzung
dx = x_ - x;

delta_r1 = atan2(dx(2),dx(1)) - x(3);
delta_t = sqrt(dx(1)^2 + dx(2)^2);
delta_r2 = dx(3) - delta_r1;

U = diag([alpha(1)*delta_r1 + alpha(2)*delta_t,...
          alpha(3)*delta_t + alpha(4)*(delta_r1+delta_r2),...
          alpha(1)*delta_r2 + alpha(2)*delta_t]);

Fx = [1, 0, -delta_t * sin(x(3) + delta_r1);...
      0, 1, delta_t * cos(x(3) + delta_r1); ...
      0, 0, 1];
Fu = [-delta_t * sin(x(3) + delta_r1), cos(x(3) + delta_r1), 0; ...
      delta_t * cos(x(3) + delta_r1), sin(x(3) + delta_r1), 0;...
      1 0 1]; 

P_ = Fx*P*Fx' + Fu*U*Fu';

S = H*P_*H' + R;
K = P_*H'*S^(-1);

% Winkel
z = x(3) + ( ((2*pi/360) * phi_gyro) - ((2*pi/360) * phi_gyro_alt) );

y = z - H*x_;

% Aktualisiere Pose und Varianz
x = x_ + K*y;
P = P_ - K*S*K';
end