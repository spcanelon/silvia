---
title: "A Bayesian Hierarchical Modeling Framework for Geospatial Analysis of Adverse Pregnancy Outcomes"
author: 
  - Cecilia Balocchi
  - Ray Bai
  - Jessica Liu
  - name: Silvia P. Canelón
    orcid: 0000-0003-1709-1394
  - Edward I. George
  - Yong Chen
  - Mary Regina Boland
date: '2021-05-11'
slug: geospatial-analysis-pregnancy-outcomes
alias:
  - /publication/geospatial-analysis-pregnancy-outcomes/
categories:
  - research
  - EHR
  - pregnancy
  - health disparities
  - preprint
description: 'arXiv'
subtitle: 'Study describing a Bayesian hierarchichal modeling framework used to explore which neighborhood-level factors and patient-level features were most informative for preterm birth and stillbirth pregnancy outcomes.'
abstract: ''
links:
- icon: arxiv
  name: Preprint
  url: https://arxiv.org/abs/2105.04981
---

## Abstract

Studying the determinants of adverse pregnancy outcomes like stillbirth and preterm birth is of considerable interest in epidemiology. Understanding the role of both individual and community risk factors for these outcomes is crucial for planning appropriate clinical and public health interventions. With this goal, we develop geospatial mixed effects logistic regression models for adverse pregnancy outcomes. Our models account for both spatial autocorrelation and heterogeneity between neighborhoods. To mitigate the low incidence of stillbirth and preterm births in our data, we explore using class rebalancing techniques to improve predictive power. To assess the informative value of the covariates in our models, we use posterior distributions of their coefficients to gauge how well they can be distinguished from zero. As a case study, we model stillbirth and preterm birth in the city of Philadelphia, incorporating both patient-level data from electronic health records (EHR) data and publicly available neighborhood data at the census tract level. We find that patient-level features like self-identified race and ethnicity were highly informative for both outcomes. Neighborhood-level factors were also informative, with poverty important for stillbirth and crime important for preterm birth. Finally, we identify the neighborhoods in Philadelphia at highest risk of stillbirth and preterm birth. 