%% ========================================================================
%  FIGURAS 11 y 12 - VIAS METABOLICAS BUTANOL Y PHA
%  ========================================================================

%% ---- FIGURA 9: Via Metabolica ABE (Butanol) ----
figure('Position', [100 100 1200 500]);
axis off; hold on;

reacciones = {
    '2 Acetil-CoA', 'Acetoacetil-CoA', 'thl', -5.2, 0.15, 0.6;
    'Acetoacetil-CoA', '3-HB-CoA', 'hbd (NADH)', -18.7, 0.35, 0.6;
    '3-HB-CoA', 'Crotonil-CoA', 'crt', 3.1, 0.55, 0.6;
    'Crotonil-CoA', 'Butiril-CoA', 'ter (NADH)', -25.4, 0.75, 0.6;
    'Butiril-CoA', 'BUTANOL', 'adhE2 (NADH)', -32.1, 0.92, 0.6;
};

for i = 1:size(reacciones,1)
    sust = reacciones{i,1}; prod = reacciones{i,2}; enz = reacciones{i,3};
    dG = reacciones{i,4}; xpos = reacciones{i,5};
    
    rectangle('Position', [xpos-0.07, 0.55, 0.14, 0.12], 'Curvature', 0.3, ...
        'FaceColor', [0.85 0.92 1], 'EdgeColor', 'k', 'LineWidth', 1.2);
    text(xpos, 0.61, sust, 'HorizontalAlignment', 'center', 'FontSize', 8, 'FontName', 'Arial');
    
    rectangle('Position', [xpos+0.12, 0.55, 0.14, 0.12], 'Curvature', 0.3, ...
        'FaceColor', [0.85 0.92 1], 'EdgeColor', 'k', 'LineWidth', 1.2);
    text(xpos+0.19, 0.61, prod, 'HorizontalAlignment', 'center', 'FontSize', 8, 'FontName', 'Arial');
    
    if dG < 0
        fc = [0.6 0.9 0.6];
        txt_dG = sprintf('dG = %.1f kJ/mol', dG);
    else
        fc = [1 0.8 0.6];
        txt_dG = sprintf('dG = +%.1f kJ/mol *', dG);
    end
    
    rectangle('Position', [xpos+0.02, 0.72, 0.15, 0.08], 'Curvature', 0.2, ...
        'FaceColor', fc, 'EdgeColor', 'k', 'LineWidth', 1);
    text(xpos+0.095, 0.76, txt_dG, 'HorizontalAlignment', 'center', 'FontSize', 7.5, 'FontWeight', 'bold');
    
    text(xpos+0.095, 0.52, enz, 'HorizontalAlignment', 'center', 'FontSize', 8, ...
        'FontAngle', 'italic', 'Color', [0.6 0 0]);
    
    if i < size(reacciones,1)
        annotation('arrow', [xpos+0.26 xpos+0.30], [0.61 0.61]);
    end
end

text(0.5, 0.95, 'Via Metabolica ABE - Produccion de Butanol en S. cerevisiae', ...
    'HorizontalAlignment', 'center', 'FontSize', 13, 'FontWeight', 'bold', 'FontName', 'Arial');
text(0.5, 0.90, sprintf('Balance redox: -3 NADH/butanol | Cuello de botella: crt (dG = +3.1 kJ/mol)'), ...
    'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', [0.8 0 0]);
text(0.95, 0.05, 'Origenes: C. acetobutylicum (thl,hbd,crt,adhE2), T. denticola (ter), E. coli (yqhD)', ...
    'HorizontalAlignment', 'right', 'FontSize', 8, 'FontAngle', 'italic');
legend('off');
saveas(gcf, 'Fig11_Via_Metabolica_Butanol_dG.png');

%% ---- FIGURA 10: Via Metabolica PHA (Bioplastico) ----
figure('Position', [100 100 1000 500]);
axis off; hold on;

reacciones_pha = {
    '2 Acetil-CoA', 'Acetoacetil-CoA', 'phaA', -5.2, 0.15, 0.6;
    'Acetoacetil-CoA', '(R)-3-HB-CoA', 'phaB (NADPH)', -18.7, 0.45, 0.6;
    '(R)-3-HB-CoA', 'PHB (polimero)', 'phaC', -42.3, 0.75, 0.6;
};

for i = 1:size(reacciones_pha,1)
    sust = reacciones_pha{i,1}; prod = reacciones_pha{i,2}; enz = reacciones_pha{i,3};
    dG = reacciones_pha{i,4}; xpos = reacciones_pha{i,5};
    
    rectangle('Position', [xpos-0.08, 0.55, 0.16, 0.12], 'Curvature', 0.3, ...
        'FaceColor', [0.85 1 0.85], 'EdgeColor', 'k', 'LineWidth', 1.2);
    text(xpos, 0.61, sust, 'HorizontalAlignment', 'center', 'FontSize', 9, 'FontName', 'Arial');
    
    rectangle('Position', [xpos+0.14, 0.55, 0.16, 0.12], 'Curvature', 0.3, ...
        'FaceColor', [0.85 1 0.85], 'EdgeColor', 'k', 'LineWidth', 1.2);
    text(xpos+0.22, 0.61, prod, 'HorizontalAlignment', 'center', 'FontSize', 9, 'FontName', 'Arial');
    
    fc = [0.6 0.9 0.6];
    txt_dG = sprintf('dG = %.1f kJ/mol', dG);
    
    rectangle('Position', [xpos+0.02, 0.72, 0.15, 0.08], 'Curvature', 0.2, ...
        'FaceColor', fc, 'EdgeColor', 'k', 'LineWidth', 1);
    text(xpos+0.095, 0.76, txt_dG, 'HorizontalAlignment', 'center', 'FontSize', 8, 'FontWeight', 'bold');
    
    text(xpos+0.095, 0.50, enz, 'HorizontalAlignment', 'center', 'FontSize', 9, ...
        'FontAngle', 'italic', 'Color', [0 0.4 0.6]);
    
    if i < size(reacciones_pha,1)
        annotation('arrow', [xpos+0.30 xpos+0.35], [0.61 0.61]);
    end
end

text(0.5, 0.95, 'Via Metabolica PHA - Bioplastico en S. cerevisiae', ...
    'HorizontalAlignment', 'center', 'FontSize', 13, 'FontWeight', 'bold', 'FontName', 'Arial');
text(0.5, 0.90, sprintf('Balance redox: -1 NADPH/monomero | Sinergia: phaA = thl (compartido con via butanol)'), ...
    'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', [0 0.4 0.6]);
text(0.95, 0.05, 'Origen: Cupriavidus necator (phaA, phaB, phaC, phaCBP-M-CPF4)', ...
    'HorizontalAlignment', 'right', 'FontSize', 9, 'FontAngle', 'italic');
legend('off');
saveas(gcf, 'Fig12_Via_Metabolica_PHA_dG.png');

close all;
fprintf('  -> Figuras 9, 10 generadas.\n');
