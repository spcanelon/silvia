---
title: "Medication-Wide Association Study Using Electronic Health Record Data of Prescription Medication Exposure and Multifetal Pregnancies: Retrospective Study"
author: "Lena Davidson, Silvia P. Canelón, and Mary R. Boland"
date: '2022-06-07'
slug: mwas-multiple-birth
categories:
  - Research
tags:
  - EHR
  - pregnancy
  - medications
publishDate: '2022-06-07'
publication: 'JMIR Medical Informatics'
summary: 'EHR study describing an MWAS approach to explore connections between prescription medication exposure and the risk of multiple gestation pregnancies'
subtitle: 'EHR study describing an MWAS approach to explore connections between prescription medication exposure and the risk of multiple gestation pregnancies'
featured: yes
links:
- icon: doi
  icon_pack: ai
  name: Publication
  url: https://doi.org/10.2196/32229
format: hugo
---



<style type="text/css">
.page-main img {
  box-shadow: 0px 0px 2px 2px rgba( 0, 0, 0, 0.2 );
  #/* ease | ease-in | ease-out | linear */
  transition: transform ease-in-out 1s;
}

.page-main img:hover {
  transform: scale(1.8);
}
</style>

<img src="featured.png" data-fig-alt="Confounding relationships for medication-outcome associations are illustrated. Within the MWAS, we adjust for maternal age, infertility diagnosis, and assisted reproductive technology–resulting pregnancy diagnosis. The study does not adjust for all known associations of multiple birth such as obstetric complications or family history of multiples. The validation of the MWAS models observed performance in capturing fertility medication exposure." style="width:100.0%" />

<p class="caption" style="text-align:left;">
<b>Figure 1.</b> A graphical overview of the medication-wide association study analyses on multiple birth.
</p>

## Abstract

### Background

Medication-wide association studies (MWAS) have been applied to assess the risk of individual prescription use and a wide range of health outcomes, including cancer, acute myocardial infarction, acute liver failure, acute renal failure, and upper gastrointestinal ulcers. Current literature on the use of preconception and periconception medication and its association with the risk of multiple gestation pregnancies (eg, monozygotic and dizygotic) is largely based on assisted reproductive technology (ART) cohorts. However, among non-ART pregnancies, it is unknown whether other medications increase the risk of multifetal pregnancies.

### Objective

This study aimed to investigate the risk of multiple gestational births (eg., *twins* and *triplets*) following preconception and periconception exposure to prescription medications in patients who delivered at Penn Medicine.

### Methods

We used electronic health record data between 2010 and 2017 on patients who delivered babies at Penn Medicine, a health care system in the Greater Philadelphia area. We explored 3 logistic regression models: model 1 (no adjustment); model 2 (adjustment for maternal age); and model 3---our final logistic regression model (adjustment for maternal age, ART use, and infertility diagnosis). In all models, multiple births (MBs) were our outcome of interest (binary outcome), and each medication was assessed separately as a binary variable. To assess our MWAS model performance, we defined ART medications as our gold standard, given that these medications are known to increase the risk of MB.

### Results

Of the 63,334 distinct deliveries in our cohort, only 1877 pregnancies (2.96%) were prescribed any medication during the preconception and first trimester period. Of the 123 medications prescribed, we found 26 (21.1%) medications associated with MB (using nominal *P* values) and 10 (8.1%) medications associated with MB (using Bonferroni adjustment) in fully adjusted model 3. We found that our model 3 algorithm had an accuracy of 85% (using nominal *P* values) and 89% (using Bonferroni-adjusted *P* values).

### Conclusions

Our work demonstrates the opportunities in applying the MWAS approach with electronic health record data to explore associations between preconception and periconception medication exposure and the risk of MB while identifying novel candidate medications for further study. Overall, we found 3 novel medications linked with MB that could be explored in further work; this demonstrates the potential of our method to be used for hypothesis generation.