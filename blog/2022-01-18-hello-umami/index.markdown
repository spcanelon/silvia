---
title: "Hello Umami: Deploying a Privacy-Friendly Open Source Tool for Web Analytics"
author: Silvia Canelón
image: featured.jpg
date: '2022-01-18'
slug: hello-umami
categories:
  - R
  - website
  - blogdown
  - test
  - hugo
subtitle: 'A use case for adding Umami web analytics to a blogdown site and deploying using Railway.'
summary: 'A use case for adding Umami web analytics to a blogdown site and deploying using Railway.'
links:
  - icon: graph-up-arrow
    icon_pack: fas
    name: Umami Docs
    url: https://umami.is
---

<style type="text/css">
.page-main img {
  box-shadow: 0px 0px 2px 2px rgba( 0, 0, 0, 0.2 );
}

.tweet-timestamp {
  display: block;
  position: relative;
  font-size: 1em;
}
.tweet-timestamp a .tweet-timestamp__text {
  color: var(--text-light);
}
.tweet-timestamp a:hover .tweet-timestamp__text {
  color: var(--text-mild);
}
.tweet-timestamp .tweet-link > i {
	display: inline-block;
	position: absolute;
  left: -1.5em;
  top: 3px;
}
</style>

## What to expect

A brief walkthrough of the steps I took to deploy Umami web analytics for my personal website, as documented in a short Twitter thread.

<!-- Code modified from https://github.com/gadenbuie/garrickadenbuie-com/blob/main/content/blog/2020/setting-up-a-new-macbook-pro/index.Rmarkdown -->














<span class="tweet-timestamp"><a class="tweet-link" href="https://twitter.com/spcanelon/status/1480703744220319750" title="2022-01-11 00:50:57" target="_blank" rel="noopener noreferrer"><span class="tweet-timestamp__text">07:50pm<i class="pl2 fab fa-twitter fa-fw"></i></span></a></span>Months ago I removed GA from my
[#RStats](https://twitter.com/hashtag/RStats)
[#blogdown](https://twitter.com/hashtag/blogdown)
site & this weekend I added <http://umami.is> 🍚
([\@caozilla](https://twitter.com/caozilla)) as an
open source, privacy-friendly, web analytics alternative

I was intimidated by the self-hosting aspect, but the docs +
[\@Railway](https://twitter.com/Railway) made it
possible! Steps in 🧵

![](img/FIx3DDLXMAUdyi1.jpg)



## Installation

<span class="tweet-timestamp"><a class="tweet-link" href="https://twitter.com/spcanelon/status/1480703746728505346" title="2022-01-11 00:50:58" target="_blank" rel="noopener noreferrer"><span class="tweet-timestamp__text">07:50pm<i class="pl2 fab fa-twitter fa-fw"></i></span></a></span>Steps I followed:

1. Install Railway CLI with Homebrew <https://docs.railway.app/develop/cli>

2. Install PostgreSQL with Homebrew <https://wiki.postgresql.org/wiki/Homebrew>

3. Fork Umami repo & follow steps in "Running on Railway from a
forked repository" at <https://umami.is/docs/running-on-railway>

4. Clone repo locally w git



## Railway

<span class="tweet-timestamp"><a class="tweet-link" href="https://twitter.com/spcanelon/status/1480703748586590214" title="2022-01-11 00:50:58" target="_blank" rel="noopener noreferrer"><span class="tweet-timestamp__text">07:50pm<i class="pl2 fab fa-twitter fa-fw"></i></span></a></span>5. Link local setup to Railway project in the terminal w/ `railway
link <projectid>`. Project ID is in the Railway dashboard under
Setup

6. Create PostgreSQL tables using `railway run` in local umami
directory + steps in "Create database tables" at
<https://umami.is/docs/running-on-railway>

<span class="tweet-timestamp"><a class="tweet-link" href="https://twitter.com/spcanelon/status/1480703750247440385" title="2022-01-11 00:50:58" target="_blank" rel="noopener noreferrer"><span class="tweet-timestamp__text">07:50pm<i class="pl2 fab fa-twitter fa-fw"></i></span></a></span>7. Deploy with `railway up`! 🚄

8. Follow steps in Umami Getting Started docs
<https://umami.is/docs/login> to login & add website

9. Add tracking code to website. In my
[#HugoApero](https://twitter.com/hashtag/HugoApero)
[#blogdown](https://twitter.com/hashtag/blogdown)
site I added it to layouts/partials/head.html. My example at
<https://github.com/spcanelon/silvia/blob/7d407b5967ae5d1bfe9df97e9a395fd02adeb985/layouts/partials/head.html#L21-L29>



## Tracker Configuration

<span class="tweet-timestamp"><a class="tweet-link" href="https://twitter.com/spcanelon/status/1480703752017436677" title="2022-01-11 00:50:59" target="_blank" rel="noopener noreferrer"><span class="tweet-timestamp__text">07:50pm<i class="pl2 fab fa-twitter fa-fw"></i></span></a></span>10. In order to not track my own visits to my site, I followed the
tip in
[\@DeepankarBhade](https://twitter.com/DeepankarBhade)'s
post <https://dpnkr.in/blog/self-host-umami> and disabled Umami from my browser's
local storage. He kindly explained the steps to me in this thread 😅
<https://twitter.com/DeepankarBhade/status/1480214508987551750?s=20>



## Pricing

<span class="tweet-timestamp"><a class="tweet-link" href="https://twitter.com/spcanelon/status/1480703754018050048" title="2022-01-11 00:50:59" target="_blank" rel="noopener noreferrer"><span class="tweet-timestamp__text">07:50pm<i class="pl2 fab fa-twitter fa-fw"></i></span></a></span>A note about Railway pricing <https://docs.railway.app/reference/limits>:

I'm using the free tier, the Starter Plan, which has \$5 of credits.
In the past 2 days I've used \$0.7258 of my credits & it's estimated
I'll use \$3.04 by the end of the month. My site receives relatively
low traffic, so YMMV

<span class="tweet-timestamp"><a class="tweet-link" href="https://twitter.com/spcanelon/status/1480703755733635072" title="2022-01-11 00:51:00" target="_blank" rel="noopener noreferrer"><span class="tweet-timestamp__text">07:51pm<i class="pl2 fab fa-twitter fa-fw"></i></span></a></span>There is a free-ish \$10 credit Railway plan available also, where you
would only get billed for any usage above \$10

For a fully free & more adventurous experience you could give up the
convenience of Railway & self-host! See the Umami docs for options
<https://umami.is/docs/hosting>



## GoatCounter

<span class="tweet-timestamp"><a class="tweet-link" href="https://twitter.com/spcanelon/status/1480703757344284672" title="2022-01-11 00:51:00" target="_blank" rel="noopener noreferrer"><span class="tweet-timestamp__text">07:51pm<i class="pl2 fab fa-twitter fa-fw"></i></span></a></span>I'll leave you with another great free, open source, privacy-friendly
option, which is GoatCounter 🐐 <https://www.goatcounter.com/>. And
[\@mattdray](https://twitter.com/mattdray) wrote a
blogdown post about it! <https://twitter.com/mattdray/status/1306353556706992128?s=20>

For more convos about GA web analytics alternatives, see
<https://twitter.com/ma_salmon/status/1379363183526285312?s=20>



## Updating Umami

<span class="tweet-timestamp"><a class="tweet-link" href="https://twitter.com/spcanelon/status/1483512641159147531" title="2022-01-18 18:52:30" target="_blank" rel="noopener noreferrer"><span class="tweet-timestamp__text">01:52pm<i class="pl2 fab fa-twitter fa-fw"></i></span></a></span>Note to self -- how to update <http://umami.is> with new
releases:

Recent update to v1.25.0 <https://github.com/mikecao/umami/releases/tag/v1.25.0>

1. Fetch upstream from my umami fork
2. Locally in terminal, change to my umami directory
3. git pull, npm install, railway up 🚄

🚀
[#WebAnalytics](https://twitter.com/hashtag/WebAnalytics)

