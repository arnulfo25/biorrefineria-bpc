%% ========================================================================
%  FIGURAS 14, 15, 16, 17 - ANALISIS ESTADISTICO Y DIAGNOSTICOS
%  Simula datos para generar graficos diagnosticos
%  ========================================================================

%% Generar datos simulados de la biorrefineria (version v2)
rng(42);
n_rep = 100;
temps = [30, 37, 45];
phs = [4.5, 5.5, 6.5];
timePts = [100, 200];
organisms = {'P.stipitis','Z.mobilis','S.pombe','S.cerevisiae','C.thermocellum','F.oxysporum'};
scenarios = {'A', 'B'};

n_total = n_rep * numel(temps) * numel(phs) * numel(timePts) * numel(organisms) * numel(scenarios);
EtOH = zeros(n_total, 1);
Temp_v = zeros(n_total, 1);
pH_v = zeros(n_total, 1);
tPts_v = zeros(n_total, 1);
Org_v = strings(n_total, 1);
Scen_v = strings(n_total, 1);

idx = 0;
for ir = 1:n_rep
    for it = 1:numel(temps)
        for ip = 1:numel(phs)
            for itp = 1:numel(timePts)
                for io = 1:numel(organisms)
                    for isc = 1:numel(scenarios)
                        idx = idx + 1;
                        T_i = temps(it);
                        pH_i = phs(ip);
                        tp_i = timePts(itp);
                        
                        base = 50;
                        eff_T = exp(-0.5*((T_i-37)/8)^2);
                        eff_pH = exp(-0.5*((pH_i-5.5)/0.8)^2);
                        
                        org_factor = [0.7, 0.85, 0.9, 1.0, 0.5, 0.6];
                        scen_factor = [1.0, 0.7];
                        
                        EtOH(idx) = base * eff_T * eff_pH * org_factor(io) * scen_factor(isc) ...
                            * (1 + 0.15*randn) * (tp_i/100)^0.1;
                        Temp_v(idx) = T_i;
                        pH_v(idx) = pH_i;
                        tPts_v(idx) = tp_i;
                        Org_v(idx) = organisms{io};
                        Scen_v(idx) = scenarios{isc};
                    end
                end
            end
        end
    end
end

logEtOH = log(EtOH + eps);

%% Modelo lineal (fitlm)
tbl = table(logEtOH, Temp_v, pH_v, tPts_v, categorical(Scen_v), categorical(Org_v), ...
    'VariableNames', {'logEtOH','Temp','pH','timePts','scenario','organism'});

mdl = fitlm(tbl, 'logEtOH ~ Temp + pH + timePts + scenario + organism');
residuos = mdl.Residuals.Raw;
ajustados = mdl.Fitted;

%% ---- FIGURA 11: QQ-plot de Residuos ----
figure('Position', [100 100 700 600]);
qqplot(residuos);
title('QQ-Plot - Normalidad de Residuos', 'FontSize', 14, 'FontName', 'Arial');
set(gca, 'FontSize', 11, 'FontName', 'Arial');
saveas(gcf, 'Fig17_QQplot_Residuos.png');

%% ---- FIGURA 12: Residuos vs Valores Ajustados ----
figure('Position', [100 100 800 500]);
scatter(ajustados, residuos, 8, 'filled', 'MarkerFaceAlpha', 0.3);
xlabel('Valores Ajustados', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Residuos', 'FontSize', 12, 'FontName', 'Arial');
title('Residuos vs Valores Ajustados', 'FontSize', 14, 'FontName', 'Arial');
yline(0, 'r--', 'LineWidth', 1.5);
grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');
saveas(gcf, 'Fig15_Residuos_vs_Ajustados.png');

%% ---- FIGURA 13: Importancia de Coeficientes ----
figure('Position', [100 100 1000 600]);
coefs = mdl.Coefficients.Estimate(2:end);
se_coefs = mdl.Coefficients.SE(2:end);
t_coefs = mdl.Coefficients.tStat(2:end);
names = mdl.CoefficientNames(2:end);

std_coefs = coefs ./ max(abs(coefs));

barh(std_coefs, 'FaceColor', [0.3 0.6 0.9], 'EdgeColor', 'k');
hold on;
for i = 1:length(std_coefs)
    if std_coefs(i) >= 0
        text(std_coefs(i)+0.05, i, sprintf('t=%.2f', t_coefs(i)), 'FontSize', 8, 'FontName', 'Arial');
    else
        text(std_coefs(i)-0.25, i, sprintf('t=%.2f', t_coefs(i)), 'FontSize', 8, 'FontName', 'Arial');
    end
end
set(gca, 'YTickLabel', names, 'FontSize', 9, 'FontName', 'Arial');
xlabel('Coeficiente Estandarizado', 'FontSize', 12, 'FontName', 'Arial');
title('Importancia de Coeficientes - Modelo Lineal', 'FontSize', 14, 'FontName', 'Arial');
xline(0, 'r--', 'LineWidth', 1.5);
grid on;
saveas(gcf, 'Fig16_Importancia_Coeficientes.png');

%% ---- FIGURA 14: Matriz de Correlacion (Heatmap) ----
EtOH_kg = EtOH;
EtOH_peak = EtOH * (1 + 0.2*randn(n_total,1));
Glucosa_kg = 200 * ones(n_total,1) - EtOH * 0.5;

M_corr = [EtOH_kg, EtOH_peak, Glucosa_kg, Temp_v, pH_v, tPts_v];
var_names = {'EtOH (kg)', 'EtOH peak', 'Glucosa', 'Temp', 'pH', 'timePts'};
R = corrcoef(M_corr);

figure('Position', [100 100 700 600]);
imagesc(R);
colormap(redblue_cmap());
colorbar;
caxis([-1 1]);
for i = 1:6
    for j = 1:6
        text(i, j, sprintf('%.2f', R(j,i)), 'HorizontalAlignment', 'center', ...
            'FontSize', 10, 'FontWeight', 'bold', 'Color', ...
            iif(abs(R(j,i))>0.5, 'w', 'k'));
    end
end
set(gca, 'XTick', 1:6, 'XTickLabel', var_names, 'XTickLabelRotation', 45, ...
    'YTick', 1:6, 'YTickLabel', var_names, 'FontSize', 10, 'FontName', 'Arial');
title('Matriz de Correlacion de Pearson', 'FontSize', 14, 'FontName', 'Arial');
saveas(gcf, 'Fig17_Matriz_Correlacion.png');

%% Guardar resultados del modelo para tablas
save('datos_estadistica.mat', 'mdl', 'R', 'var_names');
close all;
fprintf('  -> Figuras 11, 12, 13, 14 generadas.\n');

%% ========================================================================
function c = redblue_cmap()
    n = 256;
    r = [linspace(0,1,n)', linspace(1,1,n)', linspace(1,0,n)'];
    g = [linspace(0,1,n)', linspace(1,1,n)', linspace(0,1,n)'];
    b = [linspace(1,1,n)', linspace(1,1,n)', linspace(0,1,n)'];
    c = [linspace(0,0.8,n/2)' zeros(n/2,1) linspace(0.8,0,n/2)' ...
         zeros(n/2,1) zeros(n/2,1) zeros(n/2,1) linspace(0,0.8,n/2)' zeros(n/2,1)];
    
    half = floor(n/2);
    cmap = zeros(n,3);
    for i = 1:half
        cmap(i,:) = [0.5+0.5*i/half, 1-i/half*0.8, 1-i/half*0.8];
    end
    for i = (half+1):n
        cmap(i,:) = [1-(i-half)/half*0.8, 1-(i-half)/half*0.8, 0.5+0.5*(i-half)/half];
    end
    c = cmap;
end

function out = iif(cond, a, b)
    if cond, out = a; else, out = b; end
end
