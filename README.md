# slog

POSIX compatible logging library for bash, dash, zsh, and others

slog is a fork of [Fred Palmer's log4bash](https://github.com/fredpalmer/log4bash/blob/master/README.md). log4bash is very nice, but requires bash, and also includes some macOS-isms that I didn't need. So, I ported it to run correctly under bash, dash, and zsh. I also needed logging to both STDOUT and a file, without needing to tee, or whatever. So, this does that, too. slog is under the same fun license as log4bash.

I renamed it to slog, because there's already a (quite old, but still pretty good) log4sh, and because it doesn't really feel like a log4X implementation, to me. Not enough enterprise and too much fun to fit the mold.

# slog

slog is a very simple, very concise, logging library for POSIX shell scripts that makes it easy to print nice colorful messages to the console, while also optionally writing to a log file.

## Contributors

Fred Palmer - Original author of log4bash

Joe Cooper - Ported to POSIX shell, switched to tput for colors, removed speak and captains log types, added logging to file

## Using slog

Import slog.sh using '.' (using 'source' is a bashism, and will not work on other shells).

Set the LOG_PATH variable, if you would like output written to a file. This file will be created if it does not exist, and appended to, if it does exist.

Optionally set the LOG_LEVEL_STDOUT and/or LOG_LEVEL_LOG variables. These variables determine the minimum severity of the log entry to write to each output. e.g. Setting these variables to "WARNING" would cause only errors of level "WARNING" or "ERROR" to be written. The acceptable values, in order of severity, goes, from lowest to highest severity: DEBUG, INFO, SUCCESS, WARNING, ERROR.

``` bash

    #!/bin/sh
    
    . ./slog.sh
    # Set LOG_PATH, if you also want output written to a file
    LOG_PATH=./my.log
    
    log "This is regular log message... log and log_info do the same thing";

    log_warning "Luke ... you turned off your targeting computer";
    log_info "I have you now!";
    log_success "You're all clear kid, now let's blow this thing and go home.";
    log_error "One thing's for sure, we're all gonna be a lot thinner.";

```

## An Overview of slog


### Colorized Output

slog uses tput to produce colorized output. It uses colors 1, 2, and 3, which coincides with red, green, and yellow in many shell pallettes (but not all, by any means). These are used for log_error, log_warning, and log_success, respectively. Color will be disabled for non-interactive terminals (so if being piped into a file). If a LOG_PATH is defined, the log will contain no color information, either.

![Screenshot of slog with colors](http://i.imgur.com/mcEXscp.png)

### Logging Levels

* **log_info**

    Prints an "INFO" level message to stdout and/or file with the timestamp of the occurrence.

* **log_warning**

    Prints a "WARNING" level message to stdout and/or file with the timestamp of the occurrence.

* **log_success**

    Prints a "SUCCESS" level message to stdout and/or file with the timestamp of the occurrence.

* **log_error**

    Prints an "ERROR" level message to stdout and/or file with the timestamp of the occurrence.

* **log_debug**

    Prints a "DEBUG" level message to stdout and/or file with the timestamp of the occurrence. Disabled, by default.

### Logging Options

Logging options can be configured anywhere within your script, and can be changed at any point. Obviously, the settings will only apply to log function calls that happen after you have defined them. Usually, you'd want to define them at the beginning of your main script, and never change them.

* **LOG_PATH**

    Set this variable in order to write log entries to a log file. By default, entries will be printed to STDOUT.
    
* **LOG_LEVEL_STDOUT**

    Set this variable in order to determine what severity events to write to STDOUT. The default minimum level is "INFO".
    
* **LOG_LEVEL_LOG**

    Set this variable in order to determine what several events to write to the log file (set in LOG_PATH). The default minimmum level of "INFO".
    
### Other Useful Values

* **SCRIPT_ARGS**

    A global array of all the arguments used to run your script

* **SCRIPT_NAME**

    The script name (sometimes tricky to get right depending on how one invokes a script).

* **SCRIPT_BASE_DIR**

    The script's base directory which is not always the current working directory.

### Problems?

Open a ticket if you run into any problems. Patches are welcome (as long as you keep it simple and compatibile with all the shells), and I especially hope folks will report compatitibility issues with POSIX (and close to POSIX) shells. I'm working on tools that target many Linux distributions and BSDs, so I like to know when my shell scripts are going to act funny.
