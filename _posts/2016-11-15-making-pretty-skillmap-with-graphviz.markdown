---
layout: post
title: Making pretty skillmap with graphviz
date: '2016-11-14 18:19:00'
tags:
  - english
  - howto
  - graphviz
  - graphs
  - dot
  - maps
  - visualization
---

![PNG](/images/my-skills.png)

I've been searching for some way to visualize my skills today, for fun mostly. At first I was trying to use GraphML and Gephi and it was: Hard, Slow, GUI and Ugly.

After one hour of efforts I listened to [@Shoonoise](https://twitter.com/shoonoise/status/798232697265156096) and gave dot a try. Aaaaand it's perfect human-oriented "language"! Just look at this example:

``` dot
digraph G {
    Documentation -> Markdown;
    Documentation -> Confluence;
    Documentation -> Wiki;
    Documentation -> RST;
    Documentation -> ReadTheDocs;
    SCM -> Ansible;
    ProductManagement -> Scrum;
    ProductManagement -> Jira;
    ProductManagement -> Agile;
}
```

No ```<node id="1" label="SCM"/>```, no ```<edge source="1" target="2"/>```. Just human readable text!

I don't remember how I got it, it was long ago, when I profiled python for first time. Maybe ```pip install graphviz``` will help, maybe ```port install pydot```.

And result of two hours of "fun", generated from [DOT (source)](/share/my-skills.gv) by:

```
sfdp -Goverlap=prism  share/my-skills.gv | gvmap -e | neato -Ecolor="#55555522" -n2 -Tsvg > images/my-skills.svg
sfdp -Goverlap=prism  share/my-skills.gv | gvmap -e | neato -Ecolor="#55555522" -n2 -Tpng > images/my-skills.png
```

[SVG](/images/my-skills.svg)

[PNG](/images/my-skills.png)
