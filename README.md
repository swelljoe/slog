# slog

POSIX compatible logging library for bash, dash and others

slog is a fork of [Fred Palmer's log4bash](https://github.com/fredpalmer/log4bash/blob/master/README.md). log4bash is very nice, but requires bash, and also includes some macOS-isms that I didn't need. So, I ported it to run correctly under bash, dash, and zsh. I also needed logging to both STDOUT and a file, without needing to tee, or whatever. So, this does that, too. slog is under the same fun license as log4bash.

I renamed it to slog, because there's already a (quite old, but still pretty good) log4sh, and because it doesn't really feel like a log4X implementation, to me. Not enough enterprise and too much fun to fit the mold.

# slog

slog is a very simple, very concise, logging library for POSIX shell scripts that makes it easy to print nice colorful messages to the console, while also optionally writing to a log file.

## Contributors

Fred Palmer - Original author of log4bash

Joe Cooper - Ported to POSIX shell, switched to tput for colors, removed speak and captains log types, added logging to file

## Using slog

Set the LOG_PATH variable, if you would like output written to a file. This file will be created if it does not exist, and appended to, if it does exist.

Source slog.sh using '.' (using 'source' is a bashism, and will not work on other shells).

``` bash

    #!/bin/sh
    
    LOG_PATH=./my.log
    . ./slog.sh

    log "This is regular log message... log and log_info do the same thing";

    log_warning "Luke ... you turned off your targeting computer";
    log_info "I have you now!";
    log_success "You're all clear kid, now let's blow this thing and go home.";
    log_error "One thing's for sure, we're all gonna be a lot thinner.";

```

## An Overview of slog


### Colorized Output

[Screenshot of slog with colors](http://i.imgur.com/mcEXscp.png)

### Logging Levels

* **log_info**

    Prints an "INFO" level message to stdout with the timestamp of the occurrence.

* **log_warning**

    Prints a "WARNING" level message to stdout with the timestamp of the occurrence.

* **log_success**

    Prints a "SUCCESS" level message to stdout with the timestamp of the occurrence.

* **log_error**

    Prints an "ERROR" level message to stdout with the timestamp of the occurrence.

### Other Useful Tidbits

* **SCRIPT_ARGS**

    A global array of all the arguments used to create run your script

* **SCRIPT_NAME**

    The script name (sometimes tricky to get right depending on how one invokes a script).

* **SCRIPT_BASE_DIR**

    The script's base directory which is not always the current working directory.

### More to Come

    Please add any feature requests to a ticket for this project.
