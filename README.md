# raspi-stepone

In my work, we tend to need to replicate systems. When I set up a raspberry pi as a prototyping device, it is not uncommon that I will actually build 50 of them, though I might not necessarily need all of them at the same time.

Over time, the base raspbian image evolves. When I start a project, I like to pick the latest from the [RaspberryPi.Org website] (https://www.raspberrypi.org/downloads.raspbian).

From that image, I might want to do a number of different things, but there is a set of core configurations that I like to start from:
* that 'Pi' user needs a different password
* I want my own user created
* I want US keyboard and locale
* Configure the network so that if the Pi does not find a wifi networks, it turns itself into an access point so I can always connect to it


So, Stepone does that for me in one easy step.

