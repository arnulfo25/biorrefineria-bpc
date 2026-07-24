%% ========================================================================
%  MASTER SCRIPT - GENERAR TODAS LAS FIGURAS Y TABLAS
%  Biorrefineria Integrada BPC
%  Autor: Arnulfo Villanueva-Castillo (BUAP FMVZ)
%  Fecha: Junio 2026
%  ========================================================================
%  Ejecutar este script para generar todas las figuras y tablas.
%  Los archivos se guardan en la carpeta actual (Figuras_Tablas_MATLAB/).
%  ========================================================================

clc; clear; close all;

ruta = fileparts(mfilename('fullpath'));
cd(ruta);

fprintf('============================================================\n');
fprintf('  GENERANDO FIGURAS Y TABLAS - BIORREFINERIA BPC\n');
fprintf('  Fecha: %s\n', datestr(now));
fprintf('============================================================\n\n');

%% Figuras 1, 2 y 20 - Pretratamiento, Sacarificacion, Efecto Ambiental
fprintf('[1/10] Figuras 1a, 1b, 2, 20 - Pretratamiento y Sacarificacion...\n');
fig01_02_pretratamiento;

%% Figura 3 - Fermentacion comparativa 3 cepas
fprintf('[2/10] Figura 3 - Fermentacion comparativa...\n');
fig03_fermentacion;

%% Figuras 4, 5, 6 - Consorcio microbiano, H2, RSM
fprintf('[3/10] Figuras 4, 5, 6 - Consorcio microbiano...\n');
fig04_05_06_consortio;

%% Figuras 7, 8 - Diagrama de flujo y balance de masa
fprintf('[4/10] Figuras 7, 8 - Diagramas de flujo...\n');
fig07_08_diagramas;

%% Figuras 9, 10 - Vias metabolicas Butanol y PHA
fprintf('[5/10] Figuras 9, 10 - Vias metabolicas...\n');
fig09_10_vias_metabolicas;

%% Figuras 11, 12, 13, 14 - Estadistica y diagnosticos
fprintf('[6/10] Figuras 11-14 - Analisis estadistico...\n');
fig11_14_estadistica;

%% Figuras 15, 16, 17 - Modelo Morales y potencia
fprintf('[7/10] Figuras 15, 16, 17 - Modelo Morales...\n');
fig15_16_17_morales;

%% Figura 18 - Costos por fase
fprintf('[8/10] Figura 18 - Costos por fase...\n');
fig18_costos;

%% Figura 19 - Knockouts CRISPR
fprintf('[9/10] Figura 19 - Knockouts CRISPR...\n');
fig19_knockouts;

%% Todas las tablas (1-16)
fprintf('[10/10] Tablas 1-16 - Generando CSVs...\n');
generar_tablas;

fprintf('\n============================================================\n');
fprintf('  GENERACION COMPLETADA\n');
fprintf('  Figuras generadas: 20\n');
fprintf('  Tablas generadas: 16\n');
fprintf('  Carpeta: %s\n', ruta);
fprintf('============================================================\n');
