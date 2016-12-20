# raspi-stepone

In my work, we tend to need to replicate systems. When I set up a raspberry pi as a prototyping device, it is not uncommon that I will actually build 50 of them, though I might not necessarily need all of them at the same time.

Over time, the base raspbian image evolves. When I start a project, I like to pick the latest Raspbian image from the [RaspberryPi.Org website] (https://www.raspberrypi.org/downloads/raspbian).

From that image, I might want to do a number of different things, but there is a set of core configurations that I like to start from:
* Change the 'Pi' user's password
* Create my own user, provisioned with all the rights I will need
* Install US keyboard and locale
* Set up a new default hostname for the new image
* Configure the network so that if the Pi does not find a wifi network, it turns itself into an access point so I can always connect to it
* Refresh the system with all the latest packages (apt-get update and upgrade)
* Install python and core development tools
* Install the latest node.JS which I use all the time
* Setup bluetooth
* Setup Avahi so we can connect to the pi using hostname.local
* Free the serial port from the terminal so it can be used for communications
* Install the gpio, smbus and i2c libraries to communicate with peripherals
* Install my latest bashrc and nanorc files

So, Stepone does that for me in one easy step.

To use Stepone, follow these instructions:
* Download the latest raspbian image from the [Raspberrypi.org website] (https://www.raspberrypi.org/downloads/raspbian). I normally only download the base image.
* Load the image onto an sd card. I use [Pi-Baker on my macbook] (http://www.tweaking4all.com/software/macosx-software/macosx-apple-pi-baker/). I think it is a fantastic little tool.
* Place the SD card into the pi, connect it to a network using an ethernet cable, plug a keyboard, a screen, and turn it on.
* log in using the `pi` user with password `raspberry`.
* Assuming you have network connectivity, install git by typing `sudo apt-get install -y git`.
* Then download Stepone by typing `git clone https://github.com/fpapleux/raspi-stepone`.
* Go into the Stepone directory `cd raspi-stepone`.
* Start the setup script by typing `sudo ./setup.sh` and follow the few prompts and then just wait until it invites you to reboot.
* Reboot. Verify that everything is running (if it did not find the 'fabien' SSID, your raspberry pi should have created an access point called 'Fabien 2605' that uses the password 'harleydavidson'.

When this is done, I then turn off the pi, plug the SD card back into my laptop and save the new image onto my laptop. From that point on, I will use that image to create new raspberry pi's.

Let me know if you have any question.
 
