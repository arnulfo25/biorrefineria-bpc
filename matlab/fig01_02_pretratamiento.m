%% ========================================================================
%  FIGURAS 1, 2, 4 y 5
%  Pretratamiento, Deslignificacion, Sacarificacion, Efecto Ambiental
%  ========================================================================

%% Parametros globales
M_base = 1000;
celulosa_pct = 0.42;
hemicelulosa_pct = 0.25;
lignina_pct = 0.20;
M_cel = M_base * celulosa_pct;
M_hemi = M_base * hemicelulosa_pct;
M_lig = M_base * lignina_pct;

%% ---- FIGURA 1a: Cinetica de Pretratamiento (Solubilizacion Hemicelulosa)
k_hemi = 0.08;
t_pret = linspace(0, 2, 500);
Hemi_sol = M_hemi * exp(-k_hemi * t_pret);
Hemi_liq = M_hemi - Hemi_sol;

figure('Position', [100 100 800 500]);
plot(t_pret*60, Hemi_sol, 'r-', 'LineWidth', 2); hold on;
plot(t_pret*60, Hemi_liq, 'b-', 'LineWidth', 2);
plot(t_pret*60, M_hemi*ones(size(t_pret)), 'k--', 'LineWidth', 1);
xlabel('Tiempo (min)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Masa (kg)', 'FontSize', 12, 'FontName', 'Arial');
title('Etapa 1: Solubilizacion de Hemicelulosa (k=0.08/h)', 'FontSize', 14, 'FontName', 'Arial');
legend('Hemicelulosa solida', 'Xilosa en liquido', 'Hemicelulosa total', 'Location', 'east');
grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');
saveas(gcf, 'Fig01_Cinetica_Pretratamiento.png');

%% ---- FIGURA 1b: Cinetica de Deslignificacion
k_lig = 0.06;
t_desl = linspace(0, 2.5, 500);
Lig_sol = M_lig * exp(-k_lig * t_desl);
Lig_ext = M_lig - Lig_sol;
M_cel_limpia = M_cel * 0.95;

figure('Position', [100 100 800 500]);
plot(t_desl*60, Lig_sol, 'r-', 'LineWidth', 2); hold on;
plot(t_desl*60, Lig_ext, 'b-', 'LineWidth', 2);
plot(t_desl*60, M_lig*ones(size(t_desl)), 'k--', 'LineWidth', 1);
xlabel('Tiempo (min)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Masa (kg)', 'FontSize', 12, 'FontName', 'Arial');
title('Etapa 2: Deslignificacion (k=0.06/h)', 'FontSize', 14, 'FontName', 'Arial');
legend('Lignina residual', 'Lignina extraida', 'Lignina total', 'Location', 'east');
grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');
saveas(gcf, 'Fig04_Cinetica_Deslignificacion.png');

%% ---- FIGURA 2: Cinetica de Sacarificacion Enzimatica (Haldane)
Vmax = 8; Km = 10; Ki = 50;
C = linspace(0.1, 200, 1000);
vel = Vmax * C ./ (Km + C + C.^2 ./ Ki);
Vmax_adj_37 = Vmax;

t_sac = linspace(0, 72, 500);
C0 = M_cel_limpia;
C_t = zeros(size(t_sac));
C_t(1) = C0;
dt = t_sac(2) - t_sac(1);
for i = 2:length(t_sac)
    vel_i = Vmax * C_t(i-1) / (Km + C_t(i-1) + C_t(i-1)^2/Ki);
    C_t(i) = C_t(i-1) - vel_i * dt;
    if C_t(i) < 0, C_t(i) = 0; end
end
glucosa_t = (C0 - C_t) * 1.11;

figure('Position', [100 100 1200 500]);
subplot(1,2,1);
plot(C, vel, 'b-', 'LineWidth', 2);
xlabel('Concentracion de celulosa (kg)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Velocidad de hidrolisis (kg/h)', 'FontSize', 12, 'FontName', 'Arial');
title('Cinetica de Haldane (A. niger)', 'FontSize', 13, 'FontName', 'Arial');
grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');
[C_max, idx_max] = max(vel);
hold on; plot(C(idx_max), C_max, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
text(C(idx_max)+10, C_max, sprintf('Vmax: %.2f kg/h\nC: %.1f kg', C_max, C(idx_max)), 'FontSize', 10);

subplot(1,2,2);
plot(t_sac, glucosa_t, 'g-', 'LineWidth', 2); hold on;
plot(t_sac, C_t, 'r-', 'LineWidth', 2);
xlabel('Tiempo (h)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Masa (kg)', 'FontSize', 12, 'FontName', 'Arial');
title('Evolucion temporal de sacarificacion', 'FontSize', 13, 'FontName', 'Arial');
legend('Glucosa producida (x1.11)', 'Celulosa residual', 'Location', 'east');
grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');
saveas(gcf, 'Fig04_Cinetica_Sacarificacion_Haldane.png');

%% ---- FIGURA 20: Efecto Ambiental Gaussiano
T_range = 20:0.5:60;
T_opt = 37; sigma_T = 8;
f_T = exp(-0.5 * ((T_range - T_opt)/sigma_T).^2);

pH_range = 3:0.1:8;
pH_opt = 5.5; sigma_pH = 0.8;
f_pH = exp(-0.5 * ((pH_range - pH_opt)/sigma_pH).^2);

figure('Position', [100 100 1200 500]);
subplot(1,2,1);
plot(T_range, f_T*100, 'r-', 'LineWidth', 2); hold on;
xline(37, 'k--', 'T_{opt}=37 C', 'LineWidth', 1.5);
xline(30, 'b:', '30 C', 'LineWidth', 1);
xline(45, 'b:', '45 C', 'LineWidth', 1);
xlabel('Temperatura (C)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Eficiencia relativa (%)', 'FontSize', 12, 'FontName', 'Arial');
title('Efecto de Temperatura (Gaussiano)', 'FontSize', 13, 'FontName', 'Arial');
ylim([0 110]); grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');

subplot(1,2,2);
plot(pH_range, f_pH*100, 'b-', 'LineWidth', 2); hold on;
xline(5.5, 'k--', 'pH_{opt}=5.5', 'LineWidth', 1.5);
xlabel('pH', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Eficiencia relativa (%)', 'FontSize', 12, 'FontName', 'Arial');
title('Efecto de pH (Gaussiano)', 'FontSize', 13, 'FontName', 'Arial');
ylim([0 110]); grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');
saveas(gcf, 'Fig05_Efecto_Ambiental_Gaussiano.png');

close all;
fprintf('  -> Figuras 1a, 1b, 2, 20 generadas.\n');
