%% ========================================================================
%  FIGURA 13 - DIAGRAMA DE KNOCKOUTS CRISPR EN S. cerevisiae
%  ========================================================================

figure('Position', [100 100 1100 750]);
axis off; hold on;

metabolitos = {
    0.5, 0.85, 'Glucosa', [0.9 0.95 1], 0.05;
    0.5, 0.70, 'Piruvato', [0.9 0.95 1], 0.05;
    0.5, 0.55, 'Acetaldehido', [0.9 0.95 1], 0.05;
    0.5, 0.40, 'Acetil-CoA', [0.9 0.95 1], 0.05;
    0.85, 0.70, 'Etanol', [1 0.9 0.8], 0.06;
    0.85, 0.55, 'Glicerol', [1 0.9 0.8], 0.06;
    0.15, 0.40, 'Butanol', [0.6 1 0.6], 0.06;
    0.15, 0.25, 'PHA', [0.6 1 0.8], 0.06;
};

w = 0.11; h = 0.08;
for i = 1:size(metabolitos,1)
    bx = metabolitos{i,1}; by = metabolitos{i,2};
    bt = metabolitos{i,3}; bc = metabolitos{i,4}; fs = metabolitos{i,5};
    rectangle('Position', [bx-w/2, by-h/2, w, h], 'Curvature', 0.3, ...
        'FaceColor', bc, 'EdgeColor', 'k', 'LineWidth', 1.2);
    text(bx, by, bt, 'HorizontalAlignment', 'center', 'FontSize', 9, ...
        'FontWeight', 'bold', 'FontName', 'Arial');
end

% Etiquetas de enzimas nativas (KO)
ko_labels = {
    0.72, 0.70, 'ADH1 (KO)', [1 0.6 0.6];    % Piruvato -> Etanol
    0.72, 0.55, 'ADH2 (KO)', [1 0.6 0.6];     % Acetaldehido -> Etanol (oxid)
    0.72, 0.47, 'PDC1 (CRISPRi)', [1 0.8 0.6]; % Piruvato -> Acetaldehido
    0.72, 0.40, 'GPD1/GPD2 (KO)', [1 0.6 0.6]; % -> Glicerol
    0.28, 0.40, 'Via ABE', [0.6 1 0.6];         % Acetil-CoA -> Butanol
    0.28, 0.25, 'Via PHA', [0.6 1 0.8];          % Acetil-CoA -> PHA
};

for i = 1:size(ko_labels,1)
    bx = ko_labels{i,1}; by = ko_labels{i,2};
    bt = ko_labels{i,3}; bc = ko_labels{i,4};
    
    if contains(bt, 'KO')
        edge_c = 'r'; line_w = 2;
    elseif contains(bt, 'CRISPRi')
        edge_c = [0.8 0.5 0]; line_w = 2;
    else
        edge_c = [0 0.5 0]; line_w = 1.5;
    end
    
    rectangle('Position', [bx-0.09, by-0.03, 0.18, 0.06], 'Curvature', 0.15, ...
        'FaceColor', bc, 'EdgeColor', edge_c, 'LineWidth', line_w, 'LineStyle', '--');
    text(bx, by, bt, 'HorizontalAlignment', 'center', 'FontSize', 8.5, ...
        'FontName', 'Arial', 'FontWeight', 'bold');
end

annotation('doublearrow', [0.35 0.65], [0.62 0.62], 'Color', 'r', 'LineWidth', 1.5);
annotation('doublearrow', [0.35 0.65], [0.47 0.47], 'Color', 'r', 'LineWidth', 1.5);

text(0.5, 0.95, 'Mapa Metabolico - Knockouts CRISPR en S. cerevisiae', ...
    'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Arial');

text(0.5, 0.12, sprintf('6 intervenciones: 4 KO + 1 CRISPRi + 1 KO condicional | Total: $30 USD'), ...
    'HorizontalAlignment', 'center', 'FontSize', 10, 'BackgroundColor', [1 1 0.9], ...
    'EdgeColor', 'k', 'Margin', 3);

text(0.5, 0.05, sprintf('Objetivo: redirigir flujo de carbono hacia Butanol + PHA'), ...
    'HorizontalAlignment', 'center', 'FontSize', 10, 'FontAngle', 'italic');

saveas(gcf, 'Fig13_Diagrama_Knockouts_CRISPR.png');
close all;
fprintf('  -> Figura 19 generada.\n');
