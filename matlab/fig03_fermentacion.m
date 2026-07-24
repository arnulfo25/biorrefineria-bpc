%% ========================================================================
%  FIGURA 6 - FERMENTACION COMPARATIVA (3 CEPA, ODE45)
%  Monod con inhibicion por sustrato y producto
%  ========================================================================

%% Parametros de las 3 cepas
cepas = {'S. cerevisiae (Panaderia)', 'S. cerevisiae (Alta Tol.)', 'K. marxianus (Termotol.)'};
mumax = [0.45, 0.35, 0.75];
Ks    = [0.5,  0.2,  1.0];
Ki    = [150,  200,  100];
Pmax  = [90,   130,  60];
Yxs   = [0.08, 0.05, 0.12];
Yps   = [0.48, 0.50, 0.40];
colores = {'b', 'r', 'g'};

%% Condiciones iniciales y tiempo
tspan = [0 72];
X0 = 0.5;
S0 = 200;
P0 = 0;

%% Simulacion ODE45 para cada cepa
t_eval = linspace(0, 72, 500);

figure('Position', [100 100 1400 400]);

for c = 1:3
    params = [mumax(c), Ks(c), Ki(c), Pmax(c), Yxs(c), Yps(c)];
    
    [t, Y] = ode45(@(t,y) ferment_ode(t, y, params), tspan, [X0; S0; P0], ...
        'MaxStep', 0.1);
    
    X_sol = interp1(t, Y(:,1), t_eval);
    S_sol = interp1(t, Y(:,2), t_eval);
    P_sol = interp1(t, Y(:,3), t_eval);
    
    subplot(1,3,1); hold on;
    plot(t_eval, X_sol, [colores{c} '-'], 'LineWidth', 2);
    
    subplot(1,3,2); hold on;
    plot(t_eval, S_sol, [colores{c} '-'], 'LineWidth', 2);
    
    subplot(1,3,3); hold on;
    plot(t_eval, P_sol, [colores{c} '-'], 'LineWidth', 2);
end

subplot(1,3,1);
xlabel('Tiempo (h)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Biomasa X (g/L)', 'FontSize', 12, 'FontName', 'Arial');
title('Biomasa', 'FontSize', 13, 'FontName', 'Arial');
legend(cepas, 'Location', 'southeast', 'FontSize', 9);
grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');

subplot(1,3,2);
xlabel('Tiempo (h)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Sustrato S (g/L)', 'FontSize', 12, 'FontName', 'Arial');
title('Consumo de Glucosa', 'FontSize', 13, 'FontName', 'Arial');
grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');

subplot(1,3,3);
xlabel('Tiempo (h)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Etanol P (g/L)', 'FontSize', 12, 'FontName', 'Arial');
title('Produccion de Etanol', 'FontSize', 13, 'FontName', 'Arial');
grid on; set(gca, 'FontSize', 11, 'FontName', 'Arial');

sgtitle('Fermentacion Comparativa - Tres Cepas (ODE45)', 'FontSize', 15, 'FontName', 'Arial');
saveas(gcf, 'Fig06_Fermentacion_Comparativa_3Cepas.png');
close all;
fprintf('  -> Figura 3 generada.\n');

%% ========================================================================
%  FUNCION ODE - Fermentacion Monod con inhibicion
%  ========================================================================
function dydt = ferment_ode(t, y, p)
    mumax = p(1); Ks = p(2); Ki = p(3); Pmax = p(4); Yxs = p(5); Yps = p(6);
    X = y(1); S = y(2); P = y(3);
    
    if S < 0, S = 0; end
    if X < 0, X = 0; end
    
    mu = mumax * S / (Ks + S + S^2/Ki) * max(0, 1 - P/Pmax);
    
    dXdt = mu * X;
    dSdt = -(1/Yxs) * mu * X;
    dPdt = Yps * (-dSdt);
    
    if S <= 0
        dXdt = 0; dSdt = 0; dPdt = 0;
    end
    
    dydt = [dXdt; dSdt; dPdt];
end
