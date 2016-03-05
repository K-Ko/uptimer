# uptimer

Simple host monitoring script via http://pushover.net

## Register yourself

Go to http://pushover.net and register for an account.

(Use your "User key" as configuration value for `USER=`)

## Add a device

Add your device, choose from https://pushover.net/apps

## Add application

Add uptimer as script to your account.

(Use your "API Token" as configuration value for `TOKEN=`)

## Configure your host to monitor

Copy configuration template

    # cp config.conf.dist config.conf

and fill with your data

Add uptimer to your crontab

    # crontab -e

and add

    */5 * * * * /path/to/uptimer.sh /path/to/config.conf >/dev/null

to monitor each 5 minutes

If your want receive emails for failed tests, remove `>/dev/null`
