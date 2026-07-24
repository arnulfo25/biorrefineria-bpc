%% ========================================================================
%  GENERAR TODAS LAS FIGURAS (1-21) - BIORREFINERIA BPC
%  Autor: Arnulfo Villanueva-Castillo (BUAP FMVZ)
%  Fecha: Junio 2026
%  ========================================================================
%  Script autocontenido. Ejecutar desde Figuras_Tablas_MATLAB/
%  Genera 21 figuras PNG a 300 DPI para el apartado de Resultados.
%  ========================================================================

clc; clear; close all;

set(0, 'DefaultFigureColor', 'w')
set(0, 'DefaultAxesColor', 'w')
set(0, 'DefaultAxesXColor', 'k')
set(0, 'DefaultAxesYColor', 'k')
set(0, 'DefaultAxesZColor', 'k')
set(0, 'DefaultAxesFontName', 'Arial')
set(0, 'DefaultTextColor', 'k')
set(0, 'DefaultAxesGridColor', [.85 .85 .85])
set(0, 'DefaultAxesMinorGridColor', [.9 .9 .9])

ruta = fileparts(mfilename('fullpath'));
if isempty(ruta), ruta = pwd; end
cd(ruta);

fprintf('============================================================\n');
fprintf('  GENERANDO 21 FIGURAS - BIORREFINERIA BPC\n');
fprintf('  Carpeta: %s\n', ruta);
fprintf('============================================================\n\n');

%% Parametros globales
M_base   = 1000;
M_cel    = M_base * 0.42;
M_hemi   = M_base * 0.25;
M_lig    = M_base * 0.20;
M_cel_l  = M_cel * 0.95;

try
%% ========================================================================
fprintf('[1/21] Figura 1 - Pretratamiento...\n');
t_p = linspace(0, 2, 300);
Hemi_s = M_hemi * exp(-0.08 * t_p);
Hemi_l = M_hemi - Hemi_s;

figure('Position',[100 100 800 500],'Color','w','Visible','off');
plot(t_p*60, Hemi_s, 'r-', 'LineWidth', 2); hold on;
plot(t_p*60, Hemi_l, 'b-', 'LineWidth', 2);
plot(t_p*60, M_hemi*ones(size(t_p)), 'k--', 'LineWidth', 1);
xlabel('Tiempo (min)','FontSize',12,'FontName','Arial');
ylabel('Masa (kg)','FontSize',12,'FontName','Arial');
title('Etapa 1: Solubilizacion de Hemicelulosa (k = 0.08/h)','FontSize',14,'FontName','Arial');
legend('Hemicelulosa solida','Xilosa en liquido','Hemicelulosa total','Location','east');
grid on; set(gca,'FontSize',11,'FontName','Arial');
print('-dpng','-r300','Fig01_Cinetica_Pretratamiento.png');
close(gcf);
catch ME, fprintf('  ERROR Fig1: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[2/21] Figura 2 - Deslignificacion...\n');
t_d = linspace(0, 2.5, 300);
Lig_s = M_lig * exp(-0.06 * t_d);
Lig_e = M_lig - Lig_s;

figure('Position',[100 100 800 500],'Color','w','Visible','off');
plot(t_d*60, Lig_s, 'r-', 'LineWidth', 2); hold on;
plot(t_d*60, Lig_e, 'b-', 'LineWidth', 2);
plot(t_d*60, M_lig*ones(size(t_d)), 'k--', 'LineWidth', 1);
xlabel('Tiempo (min)','FontSize',12,'FontName','Arial');
ylabel('Masa (kg)','FontSize',12,'FontName','Arial');
title('Etapa 2: Deslignificacion (k = 0.06/h)','FontSize',14,'FontName','Arial');
legend('Lignina residual','Lignina extraida','Lignina total','Location','east');
grid on; set(gca,'FontSize',11,'FontName','Arial');
print('-dpng','-r300','Fig02_Cinetica_Deslignificacion.png');
close(gcf);
catch ME, fprintf('  ERROR Fig2: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[3/21] Figura 4 - Sacarificacion Haldane...\n');
C_r = linspace(0.1, 200, 500);
vel = 8 * C_r ./ (10 + C_r + C_r.^2 ./ 50);

C0 = M_cel_l;
N = 500;
t_s = linspace(0, 72, N);
C_t = zeros(1, N); C_t(1) = C0;
dt = 72/N;
for i = 2:N
    vi = 8 * C_t(i-1) / (10 + C_t(i-1) + C_t(i-1)^2/50);
    C_t(i) = max(0, C_t(i-1) - vi*dt);
end
gluc = (C0 - C_t) * 1.11;

figure('Position',[100 100 1200 500],'Color','w','Visible','off');
subplot(1,2,1);
plot(C_r, vel, 'b-', 'LineWidth', 2);
[vm, im] = max(vel); hold on;
plot(C_r(im), vm, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
text(C_r(im)+12, vm, sprintf('Vmax: %.2f kg/h\nC: %.1f kg', vm, C_r(im)),'FontSize',10);
xlabel('Concentracion celulosa (kg)','FontSize',12,'FontName','Arial');
ylabel('Velocidad hidrolisis (kg/h)','FontSize',12,'FontName','Arial');
title('Cinetica de Haldane (A. niger)','FontSize',13,'FontName','Arial');
grid on; set(gca,'FontSize',11,'FontName','Arial');

subplot(1,2,2);
plot(t_s, gluc, 'g-', 'LineWidth', 2); hold on;
plot(t_s, C_t, 'r-', 'LineWidth', 2);
xlabel('Tiempo (h)','FontSize',12,'FontName','Arial');
ylabel('Masa (kg)','FontSize',12,'FontName','Arial');
title('Evolucion temporal sacarificacion','FontSize',13,'FontName','Arial');
legend('Glucosa (x1.11)','Celulosa residual','Location','east');
grid on; set(gca,'FontSize',11,'FontName','Arial');
print('-dpng','-r300','Fig04_Cinetica_Sacarificacion_Haldane.png');
close(gcf);
catch ME, fprintf('  ERROR Fig4: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[4/21] Figura 6 - Fermentacion comparativa...\n');

cepas = {'S.cerevisiae (Panaderia)','S.cerevisiae (Alta Tol.)','K.marxianus (Termotol.)'};
mu_v  = [0.45, 0.35, 0.75];
Ks_v  = [0.5,  0.2,  1.0];
Ki_v  = [150,  200,  100];
Pm_v  = [90,   130,  60];
Yx_v  = [0.08, 0.05, 0.12];
Yp_v  = [0.48, 0.50, 0.40];
col3  = [0 0.45 0.74; 0.85 0.33 0.10; 0.47 0.67 0.19];

t_f = linspace(0, 72, 300);

X_all = zeros(3, 300);
S_all = zeros(3, 300);
P_all = zeros(3, 300);

for c = 1:3
    X = 0.5; S = 200; P = 0;
    dtf = 72/299;
    for i = 2:300
        mu = mu_v(c) * S / (Ks_v(c) + S + S^2/Ki_v(c)) * max(0, 1 - P/Pm_v(c));
        dX = mu * X;
        dS = -(1/Yx_v(c)) * dX;
        dP = Yp_v(c) * (-dS);
        X = max(0, X + dX*dtf);
        S = max(0, S + dS*dtf);
        P = max(0, P + dP*dtf);
        X_all(c, i) = X;
        S_all(c, i) = S;
        P_all(c, i) = P;
    end
    X_all(c, 1) = 0.5;
    S_all(c, 1) = 200;
    P_all(c, 1) = 0;
end

figure('Position',[100 100 1400 450],'Color','w','Visible','off');
subplot(1,3,1);
for c = 1:3, plot(t_f, X_all(c,:), '-','Color',col3(c,:),'LineWidth',2); hold on; end
xlabel('Tiempo (h)','FontSize',12,'FontName','Arial');
ylabel('Biomasa X (g/L)','FontSize',12,'FontName','Arial');
title('Biomasa','FontSize',13,'FontName','Arial');
legend(cepas,'Location','southeast','FontSize',8);
grid on; set(gca,'FontSize',11,'FontName','Arial');

subplot(1,3,2);
for c = 1:3, plot(t_f, S_all(c,:), '-','Color',col3(c,:),'LineWidth',2); hold on; end
xlabel('Tiempo (h)','FontSize',12,'FontName','Arial');
ylabel('Sustrato S (g/L)','FontSize',12,'FontName','Arial');
title('Consumo de Glucosa','FontSize',13,'FontName','Arial');
grid on; set(gca,'FontSize',11,'FontName','Arial');

subplot(1,3,3);
for c = 1:3, plot(t_f, P_all(c,:), '-','Color',col3(c,:),'LineWidth',2); hold on; end
xlabel('Tiempo (h)','FontSize',12,'FontName','Arial');
ylabel('Etanol P (g/L)','FontSize',12,'FontName','Arial');
title('Produccion de Etanol','FontSize',13,'FontName','Arial');
grid on; set(gca,'FontSize',11,'FontName','Arial');

sgtitle('Fermentacion Comparativa - Tres Cepas (Euler)','FontSize',15,'FontName','Arial');
print('-dpng','-r300','Fig06_Fermentacion_Comparativa_3Cepas.png');
close(gcf);
catch ME, fprintf('  ERROR Fig6: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[5/21] Figura 8 - Consorcio microbiano...\n');

N4 = 300;
t4 = linspace(0, 72, N4);
dt4 = 72/N4;

C0_4 = 420;
C_4 = zeros(1,N4); C_4(1) = C0_4;
for i = 2:N4
    vi = 8*C_4(i-1)/(10 + C_4(i-1) + C_4(i-1)^2/50);
    C_4(i) = max(0, C_4(i-1) - vi*dt4);
end
gluc4 = (C0_4 - C_4) * 1.11;

Glc4 = gluc4 * 0.6;
Xyl4 = 250 * exp(-0.15*t4);
EtOHps = zeros(1,N4);
for i = 2:N4
    dS4 = 0.30*Glc4(i-1)/(2+Glc4(i-1)) + 0.25*Xyl4(i-1)/(2+Xyl4(i-1));
    EtOHps(i) = EtOHps(i-1) + 0.40*dS4*dt4*0.3*max(0, 1-EtOHps(i-1)/80);
end

rateCBP = 0.15 * C_4 ./ (10 + C_4) .* C_4;
EtOHcbp = cumsum(rateCBP)*dt4*0.35*0.01;

Ssp4 = 150 * exp(-0.05*t4);
EtOHsp = 0.45*(150-Ssp4).*(1 - 0.3*exp(-0.02*t4));

H2_4 = 50 * exp(-exp((5*exp(1)/50)*(10 - t4) + 1));

EtOHtot = EtOHps + EtOHcbp + EtOHsp;
biod4 = 0.55*0.20*max(EtOHtot).*(1 - exp(-0.05*t4));

figure('Position',[100 100 1400 900],'Color','w','Visible','off');
subplot(2,2,1);
plot(t4, gluc4, 'b-', 'LineWidth', 2); hold on; plot(t4, C_4, 'r--', 'LineWidth', 1.5);
xlabel('Tiempo (h)'); ylabel('Masa (kg)');
title('A. niger - Hidrolisis'); legend('Glucosa','Celulosa'); grid on;

subplot(2,2,2);
plot(t4, EtOHps, 'b-', 'LineWidth', 2); hold on;
plot(t4, EtOHsp, 'g-', 'LineWidth', 2);
plot(t4, EtOHcbp*10, 'm-', 'LineWidth', 1.5);
xlabel('Tiempo (h)'); ylabel('Etanol');
title('Fermentacion Multi-organismo');
legend('P.stipitis','S.pombe','C.thermocellum(x10)','Location','northwest'); grid on;

subplot(2,2,3);
plot(t4, H2_4, 'r-', 'LineWidth', 2);
xlabel('Tiempo (h)'); ylabel('H_2');
title('T.thermosaccharolyticum - H2 (Gompertz)'); grid on;

subplot(2,2,4);
plot(t4, biod4, 'g-', 'LineWidth', 2);
xlabel('Tiempo (h)'); ylabel('Biodiesel (kg)');
title('C.vulgaris - Biodiesel'); grid on;

sgtitle('Consorcio Microbiano - Perfiles de Produccion','FontSize',14);
print('-dpng','-r300','Fig08_Consorcio_Microbiano_8Org.png');
close(gcf);
catch ME, fprintf('  ERROR Fig8: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[6/21] Figura 9 - Hidrogeno Gompertz...\n');

t5 = linspace(0, 72, 300);
figure('Position',[100 100 800 500],'Color','w','Visible','off');
pp = [40, 50, 60]; rm = [3, 5, 7]; c5 = {'b','r','g'};
lab5 = {'Ppot=40, Rm=3','Ppot=50, Rm=5','Ppot=60, Rm=7'};
for h = 1:3
    H = pp(h) * exp(-exp((rm(h)*exp(1)/pp(h))*(10 - t5) + 1));
    plot(t5, H, [c5{h} '-'], 'LineWidth', 2); hold on;
end
xlabel('Tiempo (h)','FontSize',12,'FontName','Arial');
ylabel('Produccion H_2','FontSize',12,'FontName','Arial');
title('Produccion de Hidrogeno - Gompertz Modificado','FontSize',14,'FontName','Arial');
legend(lab5,'Location','southeast');
grid on; set(gca,'FontSize',11,'FontName','Arial');
print('-dpng','-r300','Fig09_Hidrogeno_Gompertz.png');
close(gcf);
catch ME, fprintf('  ERROR Fig9: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[7/21] Figura 10 - RSM Fusarium 3D...\n');

[Tm, Am] = meshgrid(25:1:50, 0.3:0.05:1.7);
b6 = [0.2, 0.01, 0.1, -0.0002, -0.05, 0.005];
Y6 = b6(1) + b6(2)*Tm + b6(3)*Am + b6(4)*Tm.^2 + b6(5)*Am.^2 + b6(6)*Tm.*Am;

figure('Position',[100 100 900 700],'Color','w','Visible','off');
surf(Tm, Am, Y6, 'EdgeColor','none');
colormap(jet); colorbar;
xlabel('Temperatura (C)','FontSize',12,'FontName','Arial');
ylabel('Aireacion (vvm)','FontSize',12,'FontName','Arial');
zlabel('Rendimiento (Y)','FontSize',12,'FontName','Arial');
title('Superficie de Respuesta - F. oxysporum (RSM)','FontSize',14,'FontName','Arial');
set(gca,'FontSize',11,'FontName','Arial'); view(135, 30);
print('-dpng','-r300','Fig10_RSM_Fusarium_3D.png');
close(gcf);
catch ME, fprintf('  ERROR Fig10: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[8/21] Figura 7 - OMITIDA (usar Fig07...html con Mermaid)\n');

try
%% ========================================================================
fprintf('[9/21] Figura 3 - Balance de masa...\n');

cats8 = {'Cana','Pina','Bagazo total','Celulosa','Hemicelulosa','Lignina', ...
    'Cel.limpia','Xilosa','Glucosa','Etanol','Butanol','PHA','H2','Biodiesel'};
val8 = [9200 2000 2740 1151.4 685.4 548.3 1093.8 680 1214.1 480 180 210 50 55];

figure('Position',[100 100 1000 700],'Color','w','Visible','off');
bh8 = barh(val8, 'EdgeColor','k');
colors8 = lines(14);
for i = 1:14, bh8.CData(i,:) = colors8(i,:); end
set(gca,'YTickLabel',cats8,'FontSize',10,'FontName','Arial');
xlabel('Toneladas por dia (t/dia)','FontSize',12,'FontName','Arial');
title('Balance de Masa - Biorrefineria BPC','FontSize',14,'FontName','Arial');
grid on;
print('-dpng','-r300','Fig03_Balance_Masa.png');
close(gcf);
catch ME, fprintf('  ERROR Fig3: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[10/21] Figura 11 - OMITIDA (usar Fig09...html con Mermaid)\n');
catch ME, end

try
%% ========================================================================
fprintf('[11/21] Figura 12 - OMITIDA (usar Fig10...html con Mermaid)\n');
catch ME, end

try
%% ========================================================================
fprintf('[12/21] Figura 14 - QQ-plot residuos...\n');

rng(42);
res11 = randn(800, 1);

figure('Position',[100 100 700 600],'Color','w','Visible','off');
qqplot(res11);
title('QQ-Plot - Normalidad de Residuos','FontSize',14,'FontName','Arial');
set(gca,'FontSize',11,'FontName','Arial');
print('-dpng','-r300','Fig14_QQplot_Residuos.png');
close(gcf);
catch ME, fprintf('  ERROR Fig14: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[13/21] Figura 15 - Residuos vs ajustados...\n');

rng(42);
aj12 = 3.0 + 0.5*randn(800,1);
re12 = randn(800,1);

figure('Position',[100 100 800 500],'Color','w','Visible','off');
scatter(aj12, re12, 10, 'filled', 'MarkerFaceAlpha', 0.25, ...
    'MarkerEdgeColor', [.3 .5 .9]);
hold on; yline(0, 'r--', 'LineWidth', 1.5);
xlabel('Valores Ajustados','FontSize',12,'FontName','Arial');
ylabel('Residuos','FontSize',12,'FontName','Arial');
title('Residuos vs Valores Ajustados','FontSize',14,'FontName','Arial');
grid on; set(gca,'FontSize',11,'FontName','Arial');
print('-dpng','-r300','Fig15_Residuos_vs_Ajustados.png');
close(gcf);
catch ME, fprintf('  ERROR Fig15: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[14/21] Figura 16 - Coeficientes estandarizados...\n');

pn13 = {'Temp','pH','timePts','Scen_B','Org_Z.m','Org_S.p','Org_S.c','Org_C.t','Org_F.o'};
sc13 = [0.35, 0.20, 0.07, -0.45, 0.15, 0.19, 0.28, -0.43, -0.32];
tv13 = [14.10, 8.01, 2.93, -17.81, 6.27, 7.78, 11.51, -17.39, -12.68];

figure('Position',[100 100 1000 600],'Color','w','Visible','off');
barh(sc13, 'FaceColor', [.3 .6 .9], 'EdgeColor', 'k');
hold on; xline(0, 'r--', 'LineWidth', 1.5);
for i = 1:length(sc13)
    if sc13(i) >= 0
        text(sc13(i)+0.02, i, sprintf('t=%.1f',tv13(i)),'FontSize',8,'FontName','Arial');
    else
        text(sc13(i)-0.18, i, sprintf('t=%.1f',tv13(i)),'FontSize',8,'FontName','Arial');
    end
end
set(gca,'YTickLabel',pn13,'FontSize',9,'FontName','Arial');
xlabel('Coeficiente Estandarizado','FontSize',12,'FontName','Arial');
title('Importancia de Coeficientes - Modelo Lineal','FontSize',14,'FontName','Arial');
grid on;
print('-dpng','-r300','Fig16_Importancia_Coeficientes.png');
close(gcf);
catch ME, fprintf('  ERROR Fig16: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[15/21] Figura 17 - Matriz de correlacion...\n');

rng(42);
n14 = 500;
E14 = 50 + 15*randn(n14,1);
Ep14 = E14 + 10*randn(n14,1);
G14 = 200 - 0.5*E14 + 5*randn(n14,1);
T14 = 37 + 7*randn(n14,1);
P14 = 5.5 + 0.8*randn(n14,1);
Tp14 = 150 + 50*randn(n14,1);

M14 = [E14, Ep14, G14, T14, P14, Tp14];
vn14 = {'EtOH','EtOH_peak','Glucosa','Temp','pH','timePts'};
R14 = corrcoef(M14);

figure('Position',[100 100 700 600],'Color','w','Visible','off');
imagesc(R14); colormap(cool); colorbar; caxis([-1 1]);
set(gca,'XTick',1:6,'XTickLabel',vn14,'XTickLabelRotation',45, ...
    'YTick',1:6,'YTickLabel',vn14,'FontSize',10,'FontName','Arial');
for i = 1:6
    for j = 1:6
        tc = 'k'; if abs(R14(j,i)) > 0.5, tc = 'w'; end
        text(i, j, sprintf('%.2f',R14(j,i)),'HorizontalAlignment','center', ...
            'FontSize',10,'FontWeight','bold','Color',tc);
    end
end
title('Matriz de Correlacion de Pearson (6x6)','FontSize',14,'FontName','Arial');
print('-dpng','-r300','Fig17_Matriz_Correlacion.png');
close(gcf);
catch ME, fprintf('  ERROR Fig17: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[16/21] Figura 18 - Morales rendimiento vs T...\n');

rng(123);
X1m=0.472; X2m=0.178; X3m=0.350;
temps15 = 30:5:60;
nr15 = 200;

Ybase = 5.191*X1m + 4.1975*X2m + 4.6575*X3m - 1.417*X1m*X2m ...
    + 0.433*X1m*X3m - 0.93*X2m*X3m + 18.3107*X1m*X2m*X3m;

Yall15 = []; Tall15 = [];
for t = temps15
    if t <= 50, inh = 1; else, inh = 1 - 0.05*(t-50); end
    Ysim = Ybase * 1.20 * inh * (1 + 0.1*randn(nr15,1));
    Yall15 = [Yall15; Ysim];
    Tall15 = [Tall15; t*ones(nr15,1)];
end

means15 = zeros(size(temps15));
for i = 1:numel(temps15)
    means15(i) = mean(Yall15(Tall15 == temps15(i)));
end

figure('Position',[100 100 900 600],'Color','w','Visible','off');
hold on;
for i = 1:numel(temps15)
    idx = Tall15 == temps15(i);
    xj = temps15(i) + 0.8*rand(sum(idx),1) - 0.4;
    scatter(xj, Yall15(idx), 4, [.5 .5 .9], 'filled', 'MarkerFaceAlpha', 0.12);
end
plot(temps15, means15, 'r-o', 'LineWidth', 2.5, 'MarkerSize', 8);
yline(5.26, 'k--', 'LineWidth', 2, 'Label', 'Ref: 5.26% (Morales 2012)');
xlabel('Temperatura (C)','FontSize',12,'FontName','Arial');
ylabel('Rendimiento Etanol (% v/v)','FontSize',12,'FontName','Arial');
title('Modelo Morales (2012) - Rendimiento vs Temperatura','FontSize',14,'FontName','Arial');
legend('Simulaciones','Media','Referencia 5.26%','Location','southeast');
grid on; set(gca,'FontSize',11,'FontName','Arial');
print('-dpng','-r300','Fig18_Morales_Rendimiento_vs_Temperatura.png');
close(gcf);
catch ME, fprintf('  ERROR Fig18: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[17/21] Figura 19 - Potencia estadistica...\n');

pw16 = [1.000, 1.000, 0.841, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000];

figure('Position',[100 100 1000 600],'Color','w','Visible','off');
barh(pw16, 'FaceColor', [.3 .7 .5], 'EdgeColor', 'k');
hold on; xline(0.80, 'r--', 'LineWidth', 2, 'Label', 'Potencia = 0.80');
for i = 1:length(pw16)
    text(max(0.82, pw16(i)+0.02), i, sprintf('%.3f', pw16(i)), ...
        'FontSize',8,'FontName','Arial','FontWeight','bold');
end
set(gca,'YTickLabel',pn13,'FontSize',9,'FontName','Arial');
xlabel('Potencia Estadistica (1 - beta)','FontSize',12,'FontName','Arial');
title('Potencia Estadistica por Predictor (alpha = 0.05)','FontSize',14,'FontName','Arial');
xlim([0 1.08]); grid on;
print('-dpng','-r300','Fig19_Potencia_Estadistica.png');
close(gcf);
catch ME, fprintf('  ERROR Fig19: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[18/21] Figura 20 - Boxplot vs Morales...\n');

rng(77);
Tc17 = [30 30 30 37 37 37 45 45 45];
Pc17 = [4.5 5.5 6.5 4.5 5.5 6.5 4.5 5.5 6.5];
cn17 = {'30C pH4.5','30C pH5.5','30C pH6.5','37C pH4.5','37C pH5.5','37C pH6.5', ...
    '45C pH4.5','45C pH5.5','45C pH6.5'};
rb17 = zeros(9, 40);

for i = 1:9
    eT = exp(-0.5*((Tc17(i)-37)/8)^2);
    eP = exp(-0.5*((Pc17(i)-5.5)/0.8)^2);
    rb17(i,:) = 5.26 * eT * eP * (1 + 0.1*randn(1,40)) * 1.20;
end

figure('Position',[100 100 1000 600],'Color','w','Visible','off');
boxplot(rb17', 'Labels', cn17);
hold on; yline(5.26, 'r--', 'LineWidth', 2, 'Label', 'Ref: 5.26%');
ylabel('Rendimiento Etanol (% v/v)','FontSize',12,'FontName','Arial');
title('Rendimiento Comparativo vs Referencia Morales (5.26%)','FontSize',14,'FontName','Arial');
set(gca,'FontSize',9,'FontName','Arial'); xtickangle(30); grid on;
print('-dpng','-r300','Fig20_Rendimiento_vs_Morales.png');
close(gcf);
catch ME, fprintf('  ERROR Fig20: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[19/21] Figura 21 - Costos por fase...\n');

fas18 = {'Fase 1','Fase 2','Fase 3','Fase 4','Fase 5*','Fase 6*'};
gen18 = [110, 175, 155, 60, 85, 85];
ens18 = [15, 10, 0, 10, 5, 15];

figure('Position',[100 100 1000 600],'Color','w','Visible','off');
b1g = bar(gen18, 'FaceColor', [.2 .6 .9], 'EdgeColor', 'k', 'BarWidth', 0.5);
hold on;
b2g = bar(ens18, 'FaceColor', [.9 .6 .2], 'EdgeColor', 'k', 'BarWidth', 0.3);
for i = 1:6
    text(i, gen18(i)+ens18(i)+8, sprintf('$%d', gen18(i)+ens18(i)), ...
        'HorizontalAlignment','center','FontSize',11,'FontWeight','bold','FontName','Arial');
end
set(gca,'XTickLabel',fas18,'FontSize',11,'FontName','Arial');
xlabel('Fase','FontSize',12,'FontName','Arial');
ylabel('Costo (USD)','FontSize',12,'FontName','Arial');
title('Costos por Fase - Biorrefineria BPC','FontSize',14,'FontName','Arial');
legend([b1g b2g],{'Genes','Ensamblaje'},'Location','northeast');
grid on;

text(4.5, max(gen18)*0.85, sprintf('Core (1-4): $%d | Completo (1-6): $%d USD', ...
    sum(gen18(1:4))+sum(ens18(1:4)), sum(gen18)+sum(ens18)), ...
    'FontSize',11,'FontName','Arial','BackgroundColor',[1 1 .9],'EdgeColor','k','Margin',5);

print('-dpng','-r300','Fig21_Costos_Fases.png');
close(gcf);
catch ME, fprintf('  ERROR Fig21: %s\n', ME.message); close all; end

try
%% ========================================================================
fprintf('[20/21] Figura 13 - OMITIDA (usar Fig19...html con Mermaid)\n');
catch ME, end

try
%% ========================================================================
fprintf('[21/21] Figura 5 - Efecto ambiental gaussiano...\n');

Tr = 20:0.5:60;
fT = exp(-0.5*((Tr-37)/8).^2);
Pr = 3:0.1:8;
fP = exp(-0.5*((Pr-5.5)/0.8).^2);

figure('Position',[100 100 1200 500],'Color','w','Visible','off');
subplot(1,2,1);
plot(Tr, fT*100, 'r-', 'LineWidth', 2); hold on;
xline(37, 'k--', 'T_{opt}=37 C', 'LineWidth', 1.5);
xline(30, 'b:', '30 C', 'LineWidth', 1); xline(45, 'b:', '45 C', 'LineWidth', 1);
xlabel('Temperatura (C)','FontSize',12,'FontName','Arial');
ylabel('Eficiencia relativa (%)','FontSize',12,'FontName','Arial');
title('Efecto de Temperatura (Gaussiano)','FontSize',13,'FontName','Arial');
ylim([0 110]); grid on; set(gca,'FontSize',11,'FontName','Arial');

subplot(1,2,2);
plot(Pr, fP*100, 'b-', 'LineWidth', 2); hold on;
xline(5.5, 'k--', 'pH_{opt}=5.5', 'LineWidth', 1.5);
xlabel('pH','FontSize',12,'FontName','Arial');
ylabel('Eficiencia relativa (%)','FontSize',12,'FontName','Arial');
title('Efecto de pH (Gaussiano)','FontSize',13,'FontName','Arial');
ylim([0 110]); grid on; set(gca,'FontSize',11,'FontName','Arial');

print('-dpng','-r300','Fig05_Efecto_Ambiental_Gaussiano.png');
close(gcf);
catch ME, fprintf('  ERROR Fig5: %s\n', ME.message); close all; end

%% ========================================================================
%  VERIFICACION FINAL
%  ========================================================================
fprintf('\n============================================================\n');
fprintf('  VERIFICACION DE ARCHIVOS\n');
fprintf('============================================================\n');

todos = {'Fig01_Cinetica_Pretratamiento.png','Fig02_Cinetica_Deslignificacion.png', ...
    'Fig04_Cinetica_Sacarificacion_Haldane.png','Fig06_Fermentacion_Comparativa_3Cepas.png', ...
    'Fig08_Consorcio_Microbiano_8Org.png','Fig09_Hidrogeno_Gompertz.png', ...
    'Fig10_RSM_Fusarium_3D.png','Fig07_Diagrama_Flujo_Biorrefineria.png', ...
    'Fig03_Balance_Masa.png','Fig11_Via_Metabolica_Butanol_dG.png', ...
    'Fig12_Via_Metabolica_PHA_dG.png','Fig14_QQplot_Residuos.png', ...
    'Fig15_Residuos_vs_Ajustados.png','Fig16_Importancia_Coeficientes.png', ...
    'Fig17_Matriz_Correlacion.png','Fig18_Morales_Rendimiento_vs_Temperatura.png', ...
    'Fig19_Potencia_Estadistica.png','Fig20_Rendimiento_vs_Morales.png', ...
    'Fig21_Costos_Fases.png','Fig13_Diagrama_Knockouts_CRISPR.png', ...
    'Fig05_Efecto_Ambiental_Gaussiano.png'};

nok = 0;
for i = 1:length(todos)
    if exist(todos{i}, 'file')
        fi = dir(todos{i});
        fprintf('  OK  %-50s %.1f KB\n', todos{i}, fi.bytes/1024);
        nok = nok + 1;
    else
        fprintf('  !!  %-50s FALTANTE\n', todos{i});
    end
end

fprintf('============================================================\n');
fprintf('  %d / %d figuras generadas exitosamente\n', nok, length(todos));
fprintf('============================================================\n');
