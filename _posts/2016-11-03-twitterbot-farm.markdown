# A new pet project

Month ago I thought: why it is so hard to run many twitter-bots in Heroku? I had around 10-12 of them at that moment.

- They had been having a lot of common code.
- They was not a __single__ bots - each of them consist of two bots: one as source of words (my own account @strizhechenko) and second - words processor + poster.
- They hadn't duplicate control, because
- They even hadn't storage to keep some of their data, so
- They frequently had been getting a twitter API's rate limit.
- Heroku have no crontab -> you put APScheduler into your app -> 10-12 bots are enough to run out of free dyno hours in a week.

So I start this: <https://github.com/strizhechenko/twitterbot-farm>. There is a lot of work ahead, but it's already work for three bots.

# Main ideas

## 1. No virtualenv'es

One environment for __all__ bots - OpenVZ container.

_(Actually, I just can't into microservices :D)_

## 2. No useless api calls

One reader bot as a text-source keeps his tweets in redis db. Multiple "subscribers" reads him. The only API calls is:
- one home_timeline() request per reader per hour.
- one update_status per writer per hour.

_(Well, I really respect owners of API servers and have some remorses when I cause so useless workload)_

## 3. One utility to rule them all

No one likes to code if it isn't required (haha, all this project isn't required, lol). Bot's create, list, stats, destroy, import, export, etc - it's all just **commands**. And commands should be called from language for commands - bash. I created util "tfctl" (for most of commands it's just a transparent wrapper to python script) and it's nice to have no daemons, only crond with util's calls! No APScheduler, no need to monitor state of each bot -> less resource usage!

_(Actually it's just my greed)_

## 4. Opportunity to make a use of machine learning

Okay, not a machine learning, but statistic/something else for fun and practice. For example "analyzer" bots, working on top of "writers" that using stats of followers rates to build dynamic blacklists of boring words and lists of "hot" words that auditory will like to see again (maybe a little bit morphed).

_(Actually I just sad, because I had been reading a books about ML for a long time without any practice)._

## 5. Easy to transfer somewhere

Now it runs on my working server in OpenVZ container. I allocated only 256mb RAM and it using only 20mb. Maybe someday I will transfer it to digital ocean or somewhere else. So I have a rule: _no local changes, only via ansible-playbook that installs latest version from pip_. So I think it will be easy to deploy it somewhere else.

Tfctl have two options: export and import, creating tar archive enough to restore all the data required for running a bots (redis's dump.rdb).

_(Actually I just want to try to learn best practices of maintaining a python packages)._

## 6. Easy to visualize

If all the data is stored in one place it's much more easy to get a statistic and visualize it. For example that's how my fresh influxdb + grafana installations look alike (number is all stored tweets count for readers and unprocessed tweets count in source for writers):

![influxdb and grafana](images/influxdb_grafana_twitterbot_farm.img)

_(Actually, I just want to touch fresh grafana and influxdb versions and have experiments with alerting without upgrading my production servers with no reason.)_

# Problems

## I didn't choose code storage strategy

Now the only issue left is organizing twitterbots code storage. There are few options:

Options\results | Everything is unified | Forking and backporting are easy | Everyone can see code I proud in | Everyone can see ugly code | SSH-key management required
----- | :-----: | :-----: | :-----: | :-----: | :-----:
Everything is public and list of them too. Maybe branches of one github public repo | + | + | + | + | -
Something is public (github repos), something is private (bitbucket) | - | - | + | - | +
Eveything is private. Bitbucket only | + | + | - | - | +
