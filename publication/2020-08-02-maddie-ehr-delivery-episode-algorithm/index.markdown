---
title: 'Development and Evaluation of MADDIE: Method to Acquire Delivery Date Information from Electronic Health Records'
author: 
  - name: Silvia P. Canelón
    orcid: 0000-0003-1709-1394
  - Heather H. Burris
  - Lisa D. Levine
  - Mary Regina Boland
date: '2020-11-17'
slug: maddie-ehr-delivery-episode-algorithm
alias:
  - /publication/maddie-ehr-delivery-episode-algorithm/
categories:
  - Research
tags:
  - pregnancy
  - algorithm
  - AMIA
  - EHR
  - R
description: 'International Journal of Biomedical Informatics'
# publication_short: 'Int J Med Inform'
subtitle: 'An R algorithm designed to extract delivery episode details from structured Electronic Health Record data.'
abstract: ''
links:
- icon: file-richtext-fill
  name: Publication
  url: https://doi.org/10.1016/j.ijmedinf.2020.104339
- icon: file-earmark-pdf
  name: 2020 AMIA Poster
  url: /publication/2020-maddie-ehr-delivery-episode-algorithm/AMIA2020_poster.pdf
- icon: file-richtext-fill
  name: medRxiv Preprint
  url: https://www.medrxiv.org/content/10.1101/2020.07.30.20165381v1
---

## Abstract

**Objective.** To develop an algorithm that infers patient delivery dates (PDDs) and delivery-specific details from Electronic Health Records (EHRs) with high accuracy; enabling pregnancy-level outcome studies in women’s health.

**Materials and Methods.** We obtained EHR data from 1,060,100 female patients treated at Penn Medicine hospitals or outpatient clinics between 2010-2017. We developed an algorithm called MADDIE: **M**ethod to **A**cquire **D**elivery **D**ate **I**nformation from **E**lectronic Health Records that infers a PDD for distinct deliveries based on EHR encounter dates assigned a delivery code, the frequency of code usage, and the time differential between code assignments. We validated MADDIE's PDDs against a birth log independently maintained by the Department of Obstetrics and Gynecology.
  
**Results.** MADDIE identified 50,560 patients having 63,334 distinct deliveries. MADDIE was 98.6% accurate (F1-score 92.1%) when compared to the birth log. The PDD was on average 0.68 days earlier than the true delivery date for patients with only one delivery (± 1.43 days) and 0.52 days earlier for patients with more than one delivery episode (± 1.11 days).
  
**Discussion.** MADDIE is the first algorithm to successfully infer PDD information using only structured delivery codes and identify multiple deliveries per patient. MADDIE is also the first to validate the accuracy of the PDD using an external gold standard of known delivery dates as opposed to manual chart review of a sample.<br><br>**Conclusion.** MADDIE augments the EHR with delivery-specific details extracted with high accuracy and relies only on structured EHR elements while harnessing temporal information and the frequency of code usage to identify accurate PDDs.

![Poster presented at the 2020 AMIA Annual Symposium](2020_AMIA_Annual_v2_letter.png){fig-alt=""}
