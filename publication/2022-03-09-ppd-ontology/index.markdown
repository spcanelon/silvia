---
title: "Design and Evaluation of a Postpartum Depression Ontology"
author:
  - Rebecca B. Morse
  - Abigail C. Bretzin
  - name: Silvia P. Canelón
    orcid: 0000-0003-1709-1394
  - Bernadette A. D'Alonzo
  - Andrea L. C. Schneider
  - Mary R. Boland
date: '2022-03-09'
slug: ppd-ontology
categories:
  - research
  - EHR
  - pregnancy
  - ppd
description: 'Applied Clinical Informatics'
summary: 'Study describing an ontology created for the identification of patients with postpartum depression.'
subtitle: 'Study describing an ontology created for the identification of patients with postpartum depression.'
abstract: ''
links:
- icon: file-richtext-fill
  name: Publication
  url: https://doi.org/10.1055/s-0042-1743240
---

## Abstract

**Objective.** Postpartum depression (PPD) remains an understudied research area despite its high prevalence. The goal of this study is to develop an ontology to aid in the identification of patients with PPD and to enable future analyses with electronic health record (EHR) data.

**Methods.** We used Protégé-OWL to construct a postpartum depression ontology (PDO) of relevant comorbidities, symptoms, treatments, and other items pertinent to the study and treatment of PPD.

**Results.** The PDO identifies and visualizes the risk factor status of variables for PPD, including comorbidities, confounders, symptoms, and treatments. The PDO includes 734 classes, 13 object properties, and 4,844 individuals. We also linked known and potential risk factors to their respective codes in the International Classification of Diseases versions 9 and 10 that would be useful in structured EHR data analyses. The representation and usefulness of the PDO was assessed using a task-based patient case study approach, involving 10 PPD case studies. Final evaluation of the ontology yielded 86.4% coverage of PPD symptoms, treatments, and risk factors. This demonstrates strong coverage of the PDO for the PPD domain.

**Conclusion.** The PDO will enable future researchers to study PPD using EHR data as it contains important information with regard to structured (e.g., billing codes) and unstructured data (e.g., synonyms of symptoms not coded in EHRs). The PDO is publicly available through the National Center for Biomedical Ontology (NCBO) BioPortal (https://bioportal.bioontology.org/ontologies/PARTUMDO) which will enable other informaticists to utilize the PDO to study PPD in other populations.

![A graphical overview of the Postpartum Depression Ontology Superclasses and Direct Subclasses of the Ontology.](featured.jpg){fig-alt="At the top is 'owl:Thing' pointing to 3 superclasses: 'Medical Procedure Encounter or Treatment', 'Condition', and 'Maternal Descriptor.' These, in turn, point to specific subclasses. For example, superclass Condition points to subclasses 'infant or fetus condition' and 'maternal condition'"}
