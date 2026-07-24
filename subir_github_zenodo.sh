#!/bin/bash
# ================================================================
# SCRIPT: Subir repositorio biorrefineria-bpc a GitHub + Zenodo
# Ejecutar línea por línea en Terminal
# ================================================================

# --- PASO 1: Crear repo en GitHub ---
# Opción A: Con gh CLI (si está instalado)
gh repo create biorrefineria-bpc --public --description "Computational framework for integrated biorefinery simulation (MATLAB)"

# Opción B: Manual en https://github.com/new
#   Nombre: biorrefineria-bpc
#   Descripción: Computational framework for integrated biorefinery simulation
#   Público
#   NO inicializar README (ya lo tenemos)
#   Crear repo

# --- PASO 2: Inicializar git local ---
cd "/Users/arnulfo/Desktop/Proyectos 2026/Resultados_Biorrefineria/biorrefineria-bpc"

git init
git add .
git commit -m "Initial release: MATLAB scripts + data for BPC biorefinery simulation"

# --- PASO 3: Conectar y subir ---
# Reemplaza USUARIO por tu username de GitHub
git remote add origin https://github.com/USUARIO/biorrefineria-bpc.git
git branch -M main
git push -u origin main

# --- PASO 4: Crear release tag (necesario para Zenodo) ---
git tag v1.0.0
git push origin v1.0.0

# Crear release en GitHub:
gh release create v1.0.0 --title "v1.0.0 — Manuscript submission" \
  --notes "MATLAB code and data for: Villanueva-Castillo et al. (2026). Integrated in silico biorefinery..."

# ================================================================
# --- PASO 5: Archivar en Zenodo ---
# ================================================================
#
# Método automático (recomendado): Conectar GitHub → Zenodo
#
# 1. Ir a https://zenodo.org → Login (con GitHub u ORCID)
# 2. Arriba: GitHub → "Enable" tu repositorio biorrefineria-bpc
# 3. Activar el toggle ON
# 4. Cada vez que hagas un GitHub Release, Zenodo crea automáticamente
#    un DOI permanente
#
# Método manual: Subir ZIP a Zenodo
#
# 1. Crear ZIP:
#    cd "/Users/arnulfo/Desktop/Proyectos 2026/Resultados_Biorrefineria"
#    zip -r biorrefineria-bpc-v1.0.0.zip biorrefineria-bpc/
#
# 2. Ir a https://zenodo.org/deposit/new
# 3. Subir el ZIP
# 4. Llenar metadatos:
#      Tipo: Software
#      Autores: Villanueva-Castillo, Arnulfo; García-López, Ricardo Brayan; etc.
#      Título: Computational framework for integrated biorefinery simulation (BPC)
#      Licencia: CC-BY 4.0
#      Idioma: English
#      Keywords: biorefinery, bioethanol, MATLAB, metabolic engineering, CRISPR
# 5. Publish → Obtener DOI (ej: 10.5281/zenodo.xxxxxxx)
#
# --- PASO 6: Actualizar manuscrito con el DOI ---
# Reemplazar en el manuscrito la URL del repositorio por:
#   https://github.com/USUARIO/biorrefineria-bpc (archived: 10.5281/zenodoo.xxxxxxx)
#
# ================================================================
