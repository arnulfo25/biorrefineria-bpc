%% ========================================================================
%  FIGURAS 8, 9, 10 - CONSORCIO MICROBIANO, HIDROGENO, RSM
%  ========================================================================

%% ---- FIGURA 4: Perfiles de produccion del consorcio (8 organismos) ----

t = linspace(0, 72, 500);

% 1. A. niger - Hidrolisis (Haldane)
Vmax = 8; Km = 10; Ki = 50;
C0 = 420;
C_t = zeros(size(t)); C_t(1) = C0;
dt = t(2) - t(1);
for i = 2:length(t)
    v = Vmax * C_t(i-1) / (Km + C_t(i-1) + C_t(i-1)^2/Ki);
    C_t(i) = max(0, C_t(i-1) - v*dt);
end
glucosa = (C0 - C_t) * 1.11;

% 2. P. stipitis - Monod dual (pentosas)
muG = 0.30; muX = 0.25; Pm = 80; Yps_ps = 0.40;
Glc_ps = glucosa * 0.6;
Xyl_ps = 250 * exp(-0.15*t);
mu_ps = (muG * Glc_ps./(2+Glc_ps) + muX * Xyl_ps./(2+Xyl_ps));
EtOH_ps = zeros(size(t));
for i = 2:length(t)
    mu_i = mu_ps(i-1) * max(0, 1 - EtOH_ps(i-1)/Pm);
    dS = (muG*Glc_ps(i-1)/(2+Glc_ps(i-1)) + muX*Xyl_ps(i-1)/(2+Xyl_ps(i-1)));
    EtOH_ps(i) = EtOH_ps(i-1) + Yps_ps * dS * dt * 0.3;
end

% 3. C. thermocellum - CBP
mu_cbp = 0.15; Ks_cbp = 10; Yps_cbp = 0.35;
rate_cbp = mu_cbp * C_t ./ (Ks_cbp + C_t) .* C_t;
EtOH_cbp = cumsum(rate_cbp) * dt * Yps_cbp * 0.01;

% 4. S. cerevisiae - Alta Tolerancia
params_sc = [0.35, 0.2, 200, 130, 0.05, 0.50];
[~, Y_sc] = ode45(@(t,y) ferm_ode(t,y,params_sc), [0 72], [0.5; 180; 0], 'MaxStep', 0.5);
t_sc = linspace(0,72,length(Y_sc));

% 5. S. pombe
mu_sp = 0.35; Yps_sp = 0.45; Pm_sp = 100;
S_sp = 150 * exp(-0.05*t);
EtOH_sp = Yps_sp * (150 - S_sp) .* (1 - 0.3*exp(-0.02*t));

% 6. F. oxysporum - RSM
b_rsm = [0.2, 0.01, 0.1, -0.0002, -0.05, 0.005];
T_fus = 37; A_fus = 1.0;
Y_fus = b_rsm(1) + b_rsm(2)*T_fus + b_rsm(2)*A_fus + b_rsm(3)*T_fus^2 ...
    + b_rsm(4)*A_fus^2 + b_rsm(5)*T_fus*A_fus;
EtOH_fus = Y_fus * cumsum(ones(size(t))*dt) * 0.5;

% 7. H2 - Gompertz
Ppot = 50; Rm = 5; lambda_h2 = 10;
H2 = Ppot * exp(-exp((Rm*exp(1)/Ppot)*(lambda_h2 - t) + 1));

% 8. C. vulgaris - Biodiesel
EtOH_total_approx = EtOH_ps + EtOH_cbp + interp1(t_sc, Y_sc(:,3), t, 'linear', 0);
biomass_chlorella = 0.20 * max(EtOH_total_approx);
biodiesel = 0.55 * biomass_chlorella * ones(size(t)) .* (1 - exp(-0.05*t));

figure('Position', [100 100 1400 900]);

subplot(2,2,1);
plot(t, glucosa, 'b-', 'LineWidth', 2); hold on;
plot(t, C_t, 'r--', 'LineWidth', 1.5);
xlabel('Tiempo (h)'); ylabel('Masa (kg)');
title('A. niger - Hidrolisis Enzimatica');
legend('Glucosa', 'Celulosa residual'); grid on;

subplot(2,2,2);
plot(t, EtOH_ps, 'b-', 'LineWidth', 2); hold on;
plot(t_sc, Y_sc(:,3), 'r-', 'LineWidth', 2);
plot(t, EtOH_sp, 'g-', 'LineWidth', 2);
plot(t, EtOH_cbp*10, 'm-', 'LineWidth', 1.5);
xlabel('Tiempo (h)'); ylabel('Etanol (g/L o kg)');
title('Fermentacion - Multi-organismo');
legend('P. stipitis', 'S. cerevisiae', 'S. pombe', 'C. thermocellum (x10)', 'Location', 'northwest');
grid on;

subplot(2,2,3);
plot(t, H2, 'r-', 'LineWidth', 2);
xlabel('Tiempo (h)'); ylabel('H_2 (potencial)');
title('T. thermosaccharolyticum - Hidrogeno (Gompertz)');
grid on;

subplot(2,2,4);
plot(t, biodiesel, 'g-', 'LineWidth', 2);
xlabel('Tiempo (h)'); ylabel('Biodiesel (kg)');
title('C. vulgaris - Biodiesel (55% biomasa)');
grid on;

sgtitle('Consorcio Microbiano - Perfiles de Produccion', 'FontSize', 14);
set(gcf, 'Color', 'w');
saveas(gcf, 'Fig08_Consorcio_Microbiano_8Org.png');

%% ---- FIGURA 5: Produccion de Hidrogeno (Gompertz modificado) ----
figure('Position', [100 100 800 500]);
Ppot_vals = [40, 50, 60];
Rm_vals = [3, 5, 7];
colors_h2 = {'b', 'r', 'g'};

for i = 1:3
    H2_i = Ppot_vals(i) * exp(-exp((Rm_vals(i)*exp(1)/Ppot_vals(i))*(lambda_h2 - t) + 1));
    plot(t, H2_i, [colors_h2{i} '-'], 'LineWidth', 2); hold on;
end
xlabel('Tiempo (h)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Produccion de H_2', 'FontSize', 12, 'FontName', 'Arial');
title('Produccion de Hidrogeno - Gompertz Modificado', 'FontSize', 14, 'FontName', 'Arial');
legend('Ppot=40, Rm=3', 'Ppot=50, Rm=5', 'Ppot=60, Rm=7', 'Location', 'southeast');
grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');
saveas(gcf, 'Fig09_Hidrogeno_Gompertz.png');

%% ---- FIGURA 6: Superficie de Respuesta F. oxysporum (RSM 3D) ----
[T_mesh, A_mesh] = meshgrid(25:1:50, 0.3:0.05:1.7);
b = [0.2, 0.01, 0.1, -0.0002, -0.05, 0.005];
Y_rsm = b(1) + b(2)*T_mesh + b(3)*A_mesh + b(4)*T_mesh.^2 + b(5)*A_mesh.^2 + b(6)*T_mesh.*A_mesh;

figure('Position', [100 100 900 700]);
surf(T_mesh, A_mesh, Y_rsm, 'EdgeColor', 'none');
colormap(jet); colorbar;
xlabel('Temperatura (C)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Aireacion (vvm)', 'FontSize', 12, 'FontName', 'Arial');
zlabel('Rendimiento (Y)', 'FontSize', 12, 'FontName', 'Arial');
title('Superficie de Respuesta - F. oxysporum (RSM)', 'FontSize', 14, 'FontName', 'Arial');
set(gca, 'FontSize', 11, 'FontName', 'Arial');
view(135, 30);
saveas(gcf, 'Fig10_RSM_Fusarium_3D.png');

close all;
fprintf('  -> Figuras 4, 5, 6 generadas.\n');

%% ========================================================================
function dydt = ferm_ode(t, y, p)
    mumax = p(1); Ks = p(2); Ki = p(3); Pmax = p(4); Yxs = p(5); Yps = p(6);
    X = y(1); S = max(0,y(2)); P = y(3);
    mu = mumax * S / (Ks + S + S^2/Ki) * max(0, 1 - P/Pmax);
    dXdt = mu * X;
    dSdt = -(1/Yxs) * mu * X;
    dPdt = Yps * (-dSdt);
    if S <= 0, dXdt=0; dSdt=0; dPdt=0; end
    dydt = [dXdt; dSdt; dPdt];
end
