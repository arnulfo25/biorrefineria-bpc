%% ========================================================================
%  GENERAR TODAS LAS TABLAS (1-16) EN FORMATO CSV
%  ========================================================================

%% TABLA 1: Composicion de Materia Prima Lignocelulosica
T1 = table(...
    {'Bagazo cana'; 'Bagazo pina'; 'Total'}, ...
    [9200; 2000; 11200], ...
    [25; 22; NaN], ...
    [2300; 440; 2740], ...
    [42; 42; 42], ...
    [25; 25; 25], ...
    [20; 20; 20], ...
    'VariableNames', {'Fuente', 'Capacidad_t_dia', 'Rendimiento_bagazo_pct', ...
    'Bagazo_t_dia', 'Celulosa_pct', 'Hemicelulosa_pct', 'Lignina_pct'});
writetable(T1, 'Tabla01_Composicion_Materia_Prima.csv');
fprintf('  Tabla 1 OK\n');

%% TABLA 2: Parametros Cineticos de Cepas Fermentativas
T2 = readtable('../Datos_Cepas_Fermentacion.csv');
writetable(T2, 'Tabla02_Cepas_Fermentacion.csv');
fprintf('  Tabla 2 OK (copiada)\n');

%% TABLA 3: Consorcio Microbiano y Modelos Matematicos
T3 = readtable('../Datos_Consorcio_Microbiano.csv');
writetable(T3, 'Tabla03_Consorcio_Microbiano.csv');
fprintf('  Tabla 3 OK (copiada)\n');

%% TABLA 4: Diseno Experimental y Factores Evaluados
T4 = table(...
    {'Version v6'; 'Version v6'; 'Version v6'; 'Version v6'; ...
     'Version v2'; 'Version v2'; 'Version v2'; 'Version v2'; 'Version v2'; 'Version v2'}, ...
    {'Temperatura'; 'Aireacion'; 'Replicas'; 'Total corridas'; ...
     'Temperatura'; 'pH'; 'Resolucion temporal'; 'Escenario'; 'Organismos'; 'Total corridas'}, ...
    {'30, 37, 45 C'; '0.5, 1.0, 1.5 vvm'; '20'; '180'; ...
     '30, 37, 45 C'; '4.5, 5.5, 6.5'; '100, 200 puntos'; 'A (4 org), B (2 org)'; ...
     '6 niveles'; '10,800'}, ...
    {'3 niveles'; '3 niveles'; '-'; '-'; ...
     '3 niveles'; '3 niveles'; '2 niveles'; '2 niveles'; '6 niveles'; '-'}, ...
    'VariableNames', {'Version', 'Factor', 'Valores', 'Niveles'});
writetable(T4, 'Tabla04_Diseno_Experimental.csv');
fprintf('  Tabla 4 OK\n');

%% TABLA 10: Resultados del Modelo Lineal (fitlm)
load('datos_estadistica.mat', 'mdl');
ct5 = mdl.Coefficients;
T5 = table(ct5.Row, ct5.Estimate, ct5.SE, ct5.tStat, ct5.pValue, ...
    'VariableNames', {'Predictor', 'Estimate', 'SE', 'tStat', 'pValue'});
writetable(T5, 'Tabla10_Modelo_Lineal_fitlm.csv');

% Agregar R2 y RMSE
fprintf('  Tabla 10 OK (R2=%.4f, RMSE=%.4f)\n', mdl.Rsquared.Adjusted, mdl.RMSE);

%% TABLA 11: Resultados del Modelo Mixto (fitlme)
tbl_mixto = table(log(EtOH_v), Temp_v, pH_v, tPts_v, categorical(Org_v), ...
    'VariableNames', {'logEtOH', 'Temp', 'pH', 'timePts', 'organism'});
lme = fitlme(tbl_mixto, 'logEtOH ~ Temp + pH + timePts + (1|organism)');

T6_fixed = table(lme.CoefficientsPredictor, lme.CoefficientsEstimate, ...
    lme.CoefficientsSE, lme.CoefficientsDF, lme.CoefficientsTStat, lme.CoefficientsPValue, ...
    'VariableNames', {'Predictor', 'Estimate', 'SE', 'DF', 'tStat', 'pValue'});
writetable(T6_fixed, 'Tabla11_Modelo_Mixto_fitlme.csv');
fprintf('  Tabla 11 OK\n');

%% TABLA 12: Factor de Inflacion de Varianza (VIF)
X_design = [Temp_v, pH_v, tPts_v, dummyvar(categorical(Scen_v(:,1))), dummyvar(categorical(Org_v(:,1)))];
n_vars = size(X_design, 2);
vif_vals = zeros(n_vars, 1);
for j = 1:n_vars
    X_others = X_design(:, setdiff(1:n_vars, j));
    R2_j = 1 - sum((X_design(:,j) - X_others * (X_others \ X_design(:,j))).^2) / ...
        sum((X_design(:,j) - mean(X_design(:,j))).^2);
    vif_vals(j) = 1 / (1 - R2_j);
end
var_names_vif = {'Temp', 'pH', 'timePts', 'Scen_B', 'Org_2', 'Org_3', 'Org_4', 'Org_5', 'Org_6'};
T7 = table(var_names_vif(:), vif_vals, ...
    'VariableNames', {'Variable', 'VIF'});
writetable(T7, 'Tabla12_VIF.csv');
fprintf('  Tabla 12 OK\n');

%% TABLA 5: Catalogo de Genes Butanol
T8 = readtable('../Datos_Genes_Butanol.csv');
writetable(T8, 'Tabla05_Genes_Butanol.csv');
fprintf('  Tabla 10 OK (copiada)\n');

%% TABLA 7: Catalogo de Genes PHA
T9 = readtable('../Datos_Genes_PHA.csv');
writetable(T9, 'Tabla07_Genes_PHA.csv');
fprintf('  Tabla 12 OK (copiada)\n');

%% TABLA 9: Knockouts CRISPR
T10 = readtable('../Datos_Knockouts_CRISPR.csv');
writetable(T10, 'Tabla09_Knockouts_CRISPR.csv');
fprintf('  Tabla 12 OK (copiada)\n');

%% TABLA 6: Simulacion de Produccion de Butanol
T11 = readtable('../Datos_Simulacion_Butanol.csv');
writetable(T11, 'Tabla06_Simulacion_Butanol.csv');
fprintf('  Tabla 11 OK (copiada)\n');

%% TABLA 8: Simulacion de Produccion de PHA
T12 = readtable('../Datos_Simulacion_PHA.csv');
writetable(T12, 'Tabla08_Simulacion_PHA.csv');
fprintf('  Tabla 10 OK (copiada)\n');

%% TABLA 16: Plan de Implementacion y Costos
T13 = readtable('../Datos_Costos_Fases.csv');
writetable(T13, 'Tabla16_Costos_Fases.csv');
fprintf('  Tabla 16 OK (copiada)\n');

%% TABLA 14: Prueba de Hipotesis vs Morales
load('datos_morales.mat', 'Y_all', 'T_all', 'means', 'h_global', 'p_global', 'es_global');
temps_m = 30:5:60;
n_t = numel(temps_m);

media_t = zeros(n_t, 1);
sd_t = zeros(n_t, 1);
n_t_vals = zeros(n_t, 1);
h_t = zeros(n_t, 1);
p_t = zeros(n_t, 1);
es_t = zeros(n_t, 1);

for i = 1:n_t
    datos_i = Y_all(T_all == temps_m(i));
    media_t(i) = mean(datos_i);
    sd_t(i) = std(datos_i);
    n_t_vals(i) = length(datos_i);
    [h_t(i), p_t(i)] = ttest(datos_i, 5.26, 'Tail', 'right');
    es_t(i) = (media_t(i) - 5.26) / sd_t(i);
end

T14 = table(temps_m', media_t, sd_t, n_t_vals, h_t, p_t, es_t, ...
    'VariableNames', {'Temperatura_C', 'Media_pct', 'SD_pct', 'n', 'h_rechazo', 'p_value', 'tamano_efecto'});
writetable(T14, 'Tabla14_Prueba_Hipotesis_Morales.csv');
fprintf('  Tabla 14 OK (h_global=%d, p=%.4e)\n', h_global, p_global);

%% TABLA 15: Potencia Estadistica por Predictor
load('datos_estadistica.mat', 'power_vals', 'beta_vals', 'predictor_names');
load('datos_morales.mat', 'power_vals', 'beta_vals', 'predictor_names', 'pot_global');

coefs_tbl = mdl.Coefficients;
est_vals = coefs_tbl.Estimate(2:end);
t_stat_vals = coefs_tbl.tStat(2:end);

T15 = table(predictor_names, est_vals, t_stat_vals, power_vals, beta_vals, ...
    'VariableNames', {'Predictor', 'Estimate', 't_Statistic', 'Power_1_minus_beta', 'Beta_Type_II'});
writetable(T15, 'Tabla15_Potencia_Estadistica.csv');
fprintf('  Tabla 15 OK\n');

%% TABLA 13: Modelo de Referencia Morales (2012)
T16 = table(...
    {'X1 (bagazo cana)'; 'X2 (bagazo pina)'; 'X3 (otros)'; ...
     'b1'; 'b2'; 'b3'; 'b12'; 'b13'; 'b23'; 'b123'; 'Y_teorico'; ...
     'X1 opt'; 'X2 opt'; 'X3 opt'}, ...
    [0.472; 0.178; 0.350; 5.191; 4.1975; 4.6575; -1.417; 0.433; -0.93; 18.3107; 5.26; ...
     0.472; 0.178; 0.350], ...
    'VariableNames', {'Variable', 'Valor'});
writetable(T16, 'Tabla13_Modelo_Morales.csv');
fprintf('  Tabla 16 OK\n');

fprintf('\n  ========================================\n');
fprintf('  16 tablas generadas exitosamente.\n');
fprintf('  ========================================\n');
