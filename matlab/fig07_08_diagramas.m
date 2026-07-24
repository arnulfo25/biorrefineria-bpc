%% ========================================================================
%  FIGURAS 7 y 3 - DIAGRAMA DE FLUJO Y BALANCE DE MASA
%  ========================================================================

%% ---- FIGURA 7: Diagrama de Flujo de la Biorrefineria ----
figure('Position', [100 100 1200 800]);
axis off; hold on;

boxes = {
    0.05, 0.85, 'Cana de azucar\n(9,200 t/dia)', [0.8 0.9 1];
    0.05, 0.65, 'Residuos de pina\n(2,000 t/dia)', [0.8 0.9 1];
    0.25, 0.75, 'BAGAZO TOTAL\n(2,740 t/dia)', [1 1 0.7];
    0.45, 0.85, 'Pretratamiento\nHemicelulosa\n(k=0.08/h, 60 min)', [0.7 1 0.7];
    0.45, 0.55, 'Deslignificacion\nLignina\n(k=0.06/h, 90 min)', [0.7 1 0.7];
    0.65, 0.75, 'Sacarificacion\nA. niger\n(Haldane, 72 h)', [0.7 1 0.7];
    0.85, 0.90, 'FERMENTACION\nConsortio 8 org.', [1 0.8 0.8];
    0.85, 0.70, 'P. stipitis\n+ S. cerevisiae\n+ S. pombe', [0.9 0.8 1];
    0.85, 0.45, 'C. thermocellum\n(CBP)', [0.9 0.8 1];
    0.95, 0.90, 'BIOETANOL\n2G', [1 0.9 0.5];
    0.95, 0.70, 'BUTANOL\n(via ABE)', [1 0.9 0.5];
    0.95, 0.50, 'PHA\n(bioplastico)', [0.5 1 0.8];
    0.95, 0.30, 'H_2 + Biodiesel\n(C. vulgaris)', [0.5 0.8 1];
};

w = 0.13; h = 0.12;
for i = 1:size(boxes,1)
    bx = boxes{i,1}; by = boxes{i,2}; bt = boxes{i,3}; bc = boxes{i,4};
    rectangle('Position', [bx-w/2, by-h/2, w, h], 'Curvature', 0.2, ...
        'FaceColor', bc, 'EdgeColor', 'k', 'LineWidth', 1.2);
    text(bx, by, bt, 'HorizontalAlignment', 'center', 'FontSize', 7, ...
        'FontName', 'Arial');
end

arrows = [1,3; 2,3; 3,4; 3,5; 4,6; 5,6; 6,7; 7,8; 7,9; 8,10; 8,11; 9,12; 9,13];
for i = 1:size(arrows,1)
    idx_from = arrows(i,1); idx_to = arrows(i,2);
    x1 = boxes{idx_from,1}; y1 = boxes{idx_from,2};
    x2 = boxes{idx_to,1}; y2 = boxes{idx_to,2};
    annotate('arrow', [x1 x2], [y1 y2]);
end

title('Diagrama de Flujo - Biorrefineria Integrada BPC', 'FontSize', 14, 'FontName', 'Arial');
saveas(gcf, 'Fig07_Diagrama_Flujo_Biorrefineria.png');

%% ---- FIGURA 8: Balance de Masa (Barras horizontales) ----
figure('Position', [100 100 1000 700]);

categorias = {'Cana entrante', 'Pina entrante', 'Bagazo total', ...
    'Celulosa (42%)', 'Hemicelulosa (25%)', 'Lignina (20%)', ...
    'Celulosa limpia (95%)', 'Xilosa liberada', 'Glucosa (x1.11)', ...
    'Etanol estimado', 'Butanol estimado', 'PHA estimado', 'H2 potencial', 'Biodiesel'};

valores = [9200, 2000, 2740, 1151.4, 685.4, 548.3, 1093.8, 680, 1214.1, ...
    480, 180, 210, 50, 55];

colores_bar = [0.3 0.6 1; 0.3 0.8 0.6; 0.9 0.8 0.3; 0.6 0.9 0.6; ...
    0.6 0.9 0.6; 0.6 0.9 0.6; 0.4 0.8 0.4; 0.8 0.6 1; 0.9 0.9 0.5; ...
    1 0.6 0.4; 1 0.5 0.5; 0.5 1 0.8; 0.5 0.7 1; 0.7 0.9 0.5];

barh(valores, 'FaceColor', 'flat');
for i = 1:length(valores)
    patch([0 valores(i)], [i-0.4 i-0.4; i-0.4 i-0.4], ...
        'FaceColor', colores_bar(i,:), 'EdgeColor', 'k');
end
barh(valores);
set(gca, 'YTickLabel', categorias, 'FontSize', 10, 'FontName', 'Arial');
xlabel('Toneladas por dia (t/dia)', 'FontSize', 12, 'FontName', 'Arial');
title('Balance de Masa - Biorrefineria BPC', 'FontSize', 14, 'FontName', 'Arial');
grid on;
saveas(gcf, 'Fig03_Balance_Masa.png');

close all;
fprintf('  -> Figuras 7, 8 generadas.\n');
