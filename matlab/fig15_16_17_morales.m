%% ========================================================================
%  FIGURAS 18, 19, 20 - MODELO MORALES, POTENCIA, COMPARATIVO
%  ========================================================================

%% ---- FIGURA 15: Modelo Morales - Rendimiento vs Temperatura ----
rng(123);
cana = 9200;
pina = 2000;
bc = cana * 0.25;
bp = pina * 0.22;
bt = bc + bp;

X1 = 0.472; X2 = 0.178; X3 = 0.350;
temps_m = 30:5:60;
n_rep_morales = 500;
Y_ref = 5.26;

Y_all = [];
T_all = [];

for T = temps_m
    if T <= 50
        inhibicion = 1.0;
    else
        inhibicion = 1.0 - 0.05*(T-50);
    end
    eficiencia = 1.20 * inhibicion;
    
    Y_base = 5.191*X1 + 4.1975*X2 + 4.6575*X3 ...
        - 1.417*X1*X2 + 0.433*X1*X3 - 0.93*X2*X3 ...
        + 18.3107*X1*X2*X3;
    
    Y_sim = Y_base * eficiencia * (1 + 0.1*randn(n_rep_morales,1));
    Y_all = [Y_all; Y_sim];
    T_all = [T_all; T * ones(n_rep_morales,1)];
end

figure('Position', [100 100 900 600]);
hold on;
for i = 1:numel(temps_m)
    idx = T_all == temps_m(i);
    x_jitter = temps_m(i) + 0.8*rand(sum(idx),1) - 0.4;
    scatter(x_jitter, Y_all(idx), 4, [0.5 0.5 0.9], 'filled', 'MarkerFaceAlpha', 0.15);
end

means = zeros(size(temps_m));
for i = 1:numel(temps_m)
    means(i) = mean(Y_all(T_all == temps_m(i)));
end
plot(temps_m, means, 'r-o', 'LineWidth', 2.5, 'MarkerSize', 8);
yline(Y_ref, 'k--', 'LineWidth', 2, 'Label', 'Ref: 5.26% (Morales 2012)');
xlabel('Temperatura (C)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Rendimiento Etanol (% v/v)', 'FontSize', 12, 'FontName', 'Arial');
title('Modelo Morales (2012) - Rendimiento vs Temperatura', 'FontSize', 14, 'FontName', 'Arial');
legend('Simulaciones', 'Media', 'Referencia 5.26%', 'Location', 'southeast');
grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');
saveas(gcf, 'Fig18_Morales_Rendimiento_vs_Temperatura.png');

%% Prueba de hipotesis global
[h_global, p_global] = ttest(Y_all, Y_ref, 'Tail', 'right');
es_global = (mean(Y_all) - Y_ref) / std(Y_all);
pot_global = normcdf(es_global * sqrt(length(Y_all)) - 1.645);

fprintf('  Prueba t vs 5.26%%: h=%d, p=%.4e, efecto=%.3f, potencia=%.3f\n', ...
    h_global, p_global, es_global, pot_global);

%% ---- FIGURA 16: Potencia Estadistica por Predictor ----
load('datos_estadistica.mat', 'mdl');

coefs_tbl = mdl.Coefficients;
n_predictores = height(coefs_tbl) - 1;
predictor_names = coefs_tbl.Row(2:end);
t_stats = coefs_tbl.tStat(2:end);
p_vals = coefs_tbl.pValue(2:end);

df_error = mdl.DFE;
alpha = 0.05;
t_crit = tinv(1 - alpha/2, df_error);

power_vals = zeros(n_predictores, 1);
beta_vals = zeros(n_predictores, 1);

for i = 1:n_predictores
    lambda_nc = t_stats(i);
    power_vals(i) = 1 - nctcdf(t_crit, df_error, lambda_nc) + nctcdf(-t_crit, df_error, lambda_nc);
    beta_vals(i) = 1 - power_vals(i);
end

figure('Position', [100 100 1000 600]);
b = barh(power_vals, 'FaceColor', [0.3 0.7 0.5], 'EdgeColor', 'k');
hold on;
xline(0.80, 'r--', 'LineWidth', 2, 'Label', 'Potencia = 0.80');

for i = 1:n_predictores
    if power_vals(i) >= 0.80
        text(max(0.85, power_vals(i)+0.02), i, sprintf('%.3f', power_vals(i)), ...
            'FontSize', 8, 'Color', [0 0.5 0], 'FontWeight', 'bold');
    else
        text(power_vals(i)+0.02, i, sprintf('%.3f', power_vals(i)), ...
            'FontSize', 8, 'Color', [0.8 0 0]);
    end
end

set(gca, 'YTickLabel', predictor_names, 'FontSize', 9, 'FontName', 'Arial');
xlabel('Potencia Estadistica (1 - beta)', 'FontSize', 12, 'FontName', 'Arial');
title('Potencia Estadistica por Predictor (alpha=0.05)', 'FontSize', 14, 'FontName', 'Arial');
xlim([0 1.05]);
grid on;
saveas(gcf, 'Fig19_Potencia_Estadistica.png');

%% Guardar datos para tablas
T Morales_data = table(temps_m', means', ...
    arrayfun(@(T) std(Y_all(T_all==T)), temps_m)', ...
    'VariableNames', {'Temperatura', 'Media_Rendimiento', 'SD_Rendimiento'});
save('datos_morales.mat', 'Y_all', 'T_all', 'means', 'h_global', 'p_global', ...
    'es_global', 'pot_global', 'power_vals', 'beta_vals', 'predictor_names');

%% ---- FIGURA 17: Rendimiento Comparativo vs Morales (5.26%) ----
figure('Position', [100 100 1000 600]);

condiciones = {'30C-pH4.5', '30C-pH5.5', '30C-pH6.5', ...
    '37C-pH4.5', '37C-pH5.5', '37C-pH6.5', ...
    '45C-pH4.5', '45C-pH5.5', '45C-pH6.5'};

rng(77);
rend_cond = zeros(9, 50);
for i = 1:9
    T_i = temps_m(mod(i-1,3)+1);
    pH_i = phs(ceil(i/3));
    eff_T = exp(-0.5*((T_i-37)/8)^2);
    eff_pH = exp(-0.5*((pH_i-5.5)/0.8)^2);
    rend_cond(i,:) = 5.26 * eff_T * eff_pH * (1 + 0.1*randn(1,50)) * 1.2;
end

boxplot(rend_cond', 'Labels', condiciones);
hold on;
yline(Y_ref, 'r--', 'LineWidth', 2, 'Label', sprintf('Ref: %.2f%% (Morales)', Y_ref));
ylabel('Rendimiento Etanol (% v/v)', 'FontSize', 12, 'FontName', 'Arial');
title('Rendimiento Comparativo vs Referencia Morales (5.26%)', 'FontSize', 14, 'FontName', 'Arial');
set(gca, 'FontSize', 9, 'FontName', 'Arial');
xtickangle(30);
grid on;
saveas(gcf, 'Fig20_Rendimiento_vs_Morales.png');

close all;
fprintf('  -> Figuras 15, 16, 17 generadas.\n');
