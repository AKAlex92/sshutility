# sshutility
This utility helps the user to connect via ssh in a fast way.
## Required packages
This is the list of the required packages: jq, sshpass.
## How to setup the script
All the credentials are saved in a json file, called config.json, with the following rules:
```
example of the json
{
        "servers":
        [
                {"nome":"SERVER NAME 1","host":"XX.XXX.XXX.XX","port":"1234","user":"foo","password":"abcdefg"},
                {"nome":"SERVER NAME 2","host":"YY.YYY.YYY.YY","port":"5678","user":"bar","password":"hilmnop"}
		    ]
}
```
## How to use
This will search for config.json file in the same directory of the script. If the config file does exists then the utility will read it and create the selection menu for the ssh connection. Otherwise it will give you an error.
```
./sshlaunch.sh
```
It is also possible to set a different config file using the parameter -f or --config-file. Also in this way the utility will perform a check if the file exists.
```
./sshlaunch.sh -f /home/user/randomfile.json
```
For other kinds of options, just use the help command.
```
./sshlaunch.sh -h
```
## Authors

* **Alessandro Ripa** - *Initial work* - [sshutility](https://github.com/AKAlex92/sshutility/)
