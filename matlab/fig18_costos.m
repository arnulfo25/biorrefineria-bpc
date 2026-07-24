%% ========================================================================
%  FIGURA 21 - COSTOS POR FASE DE IMPLEMENTACION (BARRAS APILADAS)
%  ========================================================================

fases = {'Fase 1', 'Fase 2', 'Fase 3', 'Fase 4', 'Fase 5*', 'Fase 6*'};
genes = [110, 175, 155, 60, 85, 85];
ensamblaje = [15, 10, 0, 10, 5, 15];
reactivos = [0, 0, 0, 0, 0, 0];

total_genes = sum(genes(1:4));
total_ensamblaje = sum(ensamblaje(1:4));

figure('Position', [100 100 1000 600]);

b1 = bar(genes, 'FaceColor', [0.2 0.6 0.9], 'EdgeColor', 'k');
hold on;
b2 = bar(ensamblaje, 'FaceColor', [0.9 0.6 0.2], 'EdgeColor', 'k', 'BarWidth', 0.6);

for i = 1:6
    total_i = genes(i) + ensamblaje(i);
    text(i, total_i + 5, sprintf('$%d', total_i), 'HorizontalAlignment', 'center', ...
        'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Arial');
end

set(gca, 'XTickLabel', fases, 'FontSize', 11, 'FontName', 'Arial');
xlabel('Fase de Implementacion', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Costo (USD)', 'FontSize', 12, 'FontName', 'Arial');
title('Costos por Fase - Biorrefineria BPC', 'FontSize', 14, 'FontName', 'Arial');
legend([b1 b2], {'Sintesis de Genes', 'Ensamblaje Golden Gate'}, 'Location', 'northeast');
grid on;

text(4.5, max(genes)*0.9, sprintf('Core (1-4): $%d USD | Completo (1-6): $%d USD', ...
    total_genes+total_ensamblaje, sum(genes)+sum(ensamblaje)), ...
    'FontSize', 11, 'FontName', 'Arial', 'BackgroundColor', [1 1 0.9], ...
    'EdgeColor', 'k', 'Margin', 5);

text(5.5, 150, '* Opcional', 'FontSize', 10, 'FontAngle', 'italic', 'Color', [0.5 0.5 0.5]);

saveas(gcf, 'Fig21_Costos_Fases.png');
close all;
fprintf('  -> Figura 18 generada.\n');
