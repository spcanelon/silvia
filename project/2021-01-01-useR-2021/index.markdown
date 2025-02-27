---
title: "useR!2021 Cost Conversion Tool"
author: Silvia Canelón
date: 2021-01-01
slug: user2021-cost-conversion-tool
image: featured.png
alias:
  - /project/user-2021/
categories:
  - journalism
  - R
  - tidyverse
  - useR
subtitle: "A [cost-conversion tool](https://spcanelon.github.io/useR2021-cost-conversion-tool/) created for the [useR!2021 Conference](https://user2021.r-project.org/) (July 5-9, 2021) that leverages Gross Domestic Product and Purchasing Power Parity to adapt sponsorship and registration fees according to the country of residence."
excerpt: "A [cost-conversion tool](https://spcanelon.github.io/useR2021-cost-conversion-tool/) created for the [useR!2021 Conference](https://user2021.r-project.org/) (July 5-9, 2021) that leverages Gross Domestic Product and Purchasing Power Parity to adapt sponsorship and registration fees according to the country of residence."
links:
- icon: arrow-left-right
  name: cost conversion tool
  url: https://spcanelon.github.io/useR2021-cost-conversion-tool/
- icon: github
  name: code
  url: https://github.com/spcanelon/useR2021-cost-conversion-tool
- icon: box-arrow-up-right
  name: useR2021! registration details
  url: https://user2021.r-project.org/participation/registration-details/
---

<a href='https://user2021.r-project.org'><img src='https://user2021.r-project.org/img/artwork/user-logo-color.png' align="right" height="200" alt='The useR! logo which is adapted from the R project logo.'/></a>I created a cost conversion tool used for the useR!2021 Conference to adapt conference and sponsorship fees according to the country of residence. The cost conversion was done according to Gross Domestic Product (GDP) adjusted by Purchasing Power Parity (PPP) provided by the World Bank. We wanted conference attendees and sponsors from different parts of the world to be able to participate in useR! and believed that this is a fair approach. It reflects the reality that attendees and sponsors from “High income” countries have a different purchasing power than those from "Low income" countries. The income categories and cost conversions are listed in a [data table created in R](https://user2021.r-project.org/participation/registration-details/) that attendees can use to search for their country and attendee status if applicable (i.e. Industry, Academia, Student). They can use a built-in search bar, or filter according to a specific column.

You can read more about purchasing power parities, price level indexes, and PPP-based expenditures in the May 2020 World Bank post [New results from the International Comparison Program shed light on the size of the global economy](https://blogs.worldbank.org/opendata/new-results-international-comparison-program-shed-light-size-global-economy?token=b6827c8c6191327b728245ab1a2d8d84).

The Global Income Groups listed in the fee tables below were obtained using data from the 2017 International Comparison Program (ICP) which you can read more about in the report [Purchasing Power Parities and the Size of World Economies: Results from the 2017 International Comparison Program](https://openknowledge.worldbank.org/bitstream/handle/10986/33623/9781464815300.pdf). The conversion factors were calculated using PPP-based GDP per capita for each Global Income Group using data from the [ICP 2017 World Bank Database](https://databank.worldbank.org/source/icp-2017).
