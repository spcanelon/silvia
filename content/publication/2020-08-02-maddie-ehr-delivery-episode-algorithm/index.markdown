---
title: 'Development and Evaluation of MADDIE: Method to Acquire Delivery Date Information from Electronic Health Records'
author: "Silvia P. Canelón, Heather H. Burris, Lisa D. Levine, Mary Regina Boland"
date: '2020-11-17'
slug: maddie-ehr-delivery-episode-algorithm
categories:
  - Research
tags:
  - pregnancy
  - algorithm
  - AMIA
  - EHR
  - R
doi: ''
publishDate: '2020-11-06'
publication_types:
  - '2'
publication: 'International Journal of Biomedical Informatics'
publication_short: 'Int J Med Inform'
abstract: "**Objective.** To develop an algorithm that infers patient delivery dates (PDDs) and delivery-specific details from Electronic Health Records (EHRs) with high accuracy; enabling pregnancy-level outcome studies in women’s health.<br><br>**Materials and Methods.** We obtained EHR data from 1,060,100 female patients treated at Penn Medicine hospitals or outpatient clinics between 2010-2017. We developed an algorithm called MADDIE: **M**ethod to **A**cquire **D**elivery **D**ate **I**nformation from **E**lectronic Health Records that infers a PDD for distinct deliveries based on EHR encounter dates assigned a delivery code, the frequency of code usage, and the time differential between code assignments. We validated MADDIE's PDDs against a birth log independently maintained by the Department of Obstetrics and Gynecology.<br><br>**Results.** MADDIE identified 50,560 patients having 63,334 distinct deliveries. MADDIE was 98.6% accurate (F1-score 92.1%) when compared to the birth log. The PDD was on average 0.68 days earlier than the true delivery date for patients with only one delivery (± 1.43 days) and 0.52 days earlier for patients with more than one delivery episode (± 1.11 days).<br><br>**Discussion.** MADDIE is the first algorithm to successfully infer PDD information using only structured delivery codes and identify multiple deliveries per patient. MADDIE is also the first to validate the accuracy of the PDD using an external gold standard of known delivery dates as opposed to manual chart review of a sample.<br><br>**Conclusion.** MADDIE augments the EHR with delivery-specific details extracted with high accuracy and relies only on structured EHR elements while harnessing temporal information and the frequency of code usage to identify accurate PDDs."
summary: 'An R algorithm designed to extract delivery episode details from structured Electronic Health Record data.'
featured: yes
url_pdf: 
url_code: ~
url_dataset: ~
url_poster: ~
url_project: ~
url_slides: ~
url_source:
url_video: ~
image:
  caption: '[Canelón et al. Int J Med Inform (2020)](featured.png)'
  placement: 2
  focal_point: 'Center'
  preview_only: no
projects: []
slides: ''
links:
- icon: doi
  icon_pack: ai
  name: Publication
  url: https://doi.org/10.1016/j.ijmedinf.2020.104339
- icon: file-pdf
  icon_pack: fas
  name: AMIA 2020 Poster
  url: AMIA2020_poster.pdf
- icon: external-link-alt
  icon_pack: fas
  name: medRxiv Preprint
  url: https://www.medrxiv.org/content/10.1101/2020.07.30.20165381v1
---

## Abstract
**Objective.** To develop an algorithm that infers patient delivery dates (PDDs) and delivery-specific details from Electronic Health Records (EHRs) with high accuracy; enabling pregnancy-level outcome studies in women’s health.<br><br>**Materials and Methods.** We obtained EHR data from 1,060,100 female patients treated at Penn Medicine hospitals or outpatient clinics between 2010-2017. We developed an algorithm called MADDIE: **M**ethod to **A**cquire **D**elivery **D**ate **I**nformation from **E**lectronic Health Records that infers a PDD for distinct deliveries based on EHR encounter dates assigned a delivery code, the frequency of code usage, and the time differential between code assignments. We validated MADDIE's PDDs against a birth log independently maintained by the Department of Obstetrics and Gynecology.<br><br>**Results.** MADDIE identified 50,560 patients having 63,334 distinct deliveries. MADDIE was 98.6% accurate (F1-score 92.1%) when compared to the birth log. The PDD was on average 0.68 days earlier than the true delivery date for patients with only one delivery (± 1.43 days) and 0.52 days earlier for patients with more than one delivery episode (± 1.11 days).<br><br>**Discussion.** MADDIE is the first algorithm to successfully infer PDD information using only structured delivery codes and identify multiple deliveries per patient. MADDIE is also the first to validate the accuracy of the PDD using an external gold standard of known delivery dates as opposed to manual chart review of a sample.<br><br>**Conclusion.** MADDIE augments the EHR with delivery-specific details extracted with high accuracy and relies only on structured EHR elements while harnessing temporal information and the frequency of code usage to identify accurate PDDs.

<br>
![[2020 AMIA Poster (letter)](2020_AMIA_Annual_v2_letter.pdf)](2020_AMIA_Annual_v2_letter.png)
