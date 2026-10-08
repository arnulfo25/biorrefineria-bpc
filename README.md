# Biorrefinería BPC — Computational Framework

**Integrated in silico biorefinery for the valorization of agro-industrial waste through microbial consortia and metabolic engineering**

Villanueva-Castillo et al., 2026

## Overview

This repository contains the MATLAB scripts, input data, and model parameters
for the computational simulation of an integrated multi-product biorefinery
processing 2,740 t/day of mixed sugarcane bagasse and pineapple residues.

## Repository structure

```
biorrefineria-bpc/
├── matlab/              MATLAB R2025a scripts
│   ├── master_generar_todo.m      Master script (runs everything)
│   ├── generar_todas_figuras.m    All figure generation
│   ├── generar_tablas.m           Table generation
│   ├── fig01_02_pretratamiento.m  Pretreatment & delignification kinetics
│   ├── fig03_fermentacion.m       Comparative fermentation
│   ├── fig04_05_06_consortio.m    8-organism consortium
│   ├── fig07_08_diagramas.m       Process flow diagrams
│   ├── fig09_10_vias_metabolicas.m ABE & PHA pathways
│   ├── fig11_14_estadistica.m     Sensitivity analysis
│   ├── fig15_16_17_morales.m      Yield evaluation
│   ├── fig18_costos.m             Cost analysis
│   └── fig19_knockouts.m          CRISPR knockout map
├── data/                Input CSV data files
│   ├── composition/               Biomass composition
│   ├── fermentation/              Strain parameters
│   ├── consortium/                Microbial consortium config
│   ├── metabolic_engineering/     Gene lists, knockouts
│   └── costs/                     Implementation plan
├── LICENSE
└── README.md
```

## Requirements

- MATLAB R2022a or later (tested on R2025a)
- Statistics and Machine Learning Toolbox
- No additional toolboxes required

## Usage

1. Clone the repository
2. Open MATLAB and navigate to the `matlab/` folder
3. Run `master_generar_todo.m` to execute the full pipeline

```matlab
cd matlab
master_generar_todo
```

## Model parameters

All kinetic parameters (Vmax, Km, Ki, μmax, Pmax, Yps) were drawn from the
published literature. Parameter sources are documented in the manuscript
(Table 2 and Section 2.9). Parameter uncertainty was propagated through
Monte Carlo simulation (N = 10,000) with ±25% variation.

## License

This work is licensed under a Creative Commons Attribution 4.0 International
License (CC-BY 4.0). See LICENSE file for details.

## Citation

If you use this code or data, please cite:

> Villanueva-Castillo A, García-López RB, Pastelín-Rojas CF, et al. (2026).
> Integrated in silico biorefinery for the valorization of agro-industrial
> waste through microbial consortia and metabolic engineering.
> *Biochemical Engineering Journal* [submitted].

## Contact

Dr. Arnulfo Villanueva-Castillo
arnulfo.villanueva@correo.buap.mx
Facultad de Medicina Veterinaria y Zootecnia, BUAP, México

## Funding

Vicerrectoría de Investigación y Estudios de Posgrado (VIEP),
Benemérita Universidad Autónoma de Puebla, grant VIEP reg. 00435-PV/2024.
