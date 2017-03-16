#!/bin/sh
#--------------------------------------------------------------------------------------------------
# slog - Makes logging in POSIX shell scripting suck less
# Copyright (c) Fred Palmer
# POSIX version Copyright Joe Cooper
# Licensed under the MIT license
# http://github.com/swelljoe/slog
#--------------------------------------------------------------------------------------------------
set -e  # Fail on first error

# LOG_PATH - Define $LOG_PATH in your script to log to a file, otherwise
# just writes to STDOUT.

# LOG_LEVEL_STDOUT - Define to determine above which level goes to STDOUT.
# By default, all log levels will be written to STDOUT.
LOG_LEVEL_STDOUT="INFO"

# LOG_LEVEL_LOG - Define to determine which level goes to LOG_PATH.
# By default all log levels will be written to LOG_PATH.
LOG_LEVEL_LOG="INFO"

# Useful global variables that users may wish to reference
SCRIPT_ARGS="$@"
SCRIPT_NAME="$0"
SCRIPT_NAME="${SCRIPT_NAME#\./}"
SCRIPT_NAME="${SCRIPT_NAME##/*/}"

# Determines if we print colors or not
if [ $(tty -s) ]; then
    readonly INTERACTIVE_MODE="off"
else
    readonly INTERACTIVE_MODE="on"
fi

#--------------------------------------------------------------------------------------------------
# Begin Logging Section
if [ "${INTERACTIVE_MODE}" = "off" ]
then
    # Then we don't care about log colors
    LOG_DEFAULT_COLOR=""
    LOG_ERROR_COLOR=""
    LOG_INFO_COLOR=""
    LOG_SUCCESS_COLOR=""
    LOG_WARN_COLOR=""
    LOG_DEBUG_COLOR=""
else
    LOG_DEFAULT_COLOR=$(tput sgr0)
    LOG_ERROR_COLOR=$(tput setaf 1)
    LOG_INFO_COLOR=$(tput sgr 0)
    LOG_SUCCESS_COLOR=$(tput setaf 2)
    LOG_WARN_COLOR=$(tput setaf 3)
    LOG_DEBUG_COLOR=$(tput setaf 4)
fi

# This function scrubs the output of any control characters used in colorized output
# It's designed to be piped through with text that needs scrubbing.  The scrubbed
# text will come out the other side!
prepare_log_for_nonterminal() {
    # Essentially this strips all the control characters for log colors
    sed "s/[[:cntrl:]]\[[0-9;]*m//g"
}

log() {
    local log_text="$1"
    local log_level="$2"
    local log_color="$3"

    # Levels for comparing against LOG_LEVEL_STDOUT and LOG_LEVEL_LOG
    local LOG_LEVEL_DEBUG=0
    local LOG_LEVEL_INFO=1
    local LOG_LEVEL_SUCCESS=2
    local LOG_LEVEL_WARNING=3
    local LOG_LEVEL_ERROR=4

    # Default level to "info"
    [ -z ${log_level} ] && log_level="INFO";
    [ -z ${log_color} ] && log_color="${LOG_INFO_COLOR}";

    # Validate LOG_LEVEL_STDOUT and LOG_LEVEL_LOG since they'll be eval-ed.
    case $LOG_LEVEL_STDOUT in
        DEBUG|INFO|SUCCESS|WARNING|ERROR)
            ;;
        *)
            LOG_LEVEL_STDOUT=INFO
            ;;
    esac
    case $LOG_LEVEL_LOG in
        DEBUG|INFO|SUCCESS|WARNING|ERROR)
            ;;
        *)
            LOG_LEVEL_LOG=INFO
            ;;
    esac

    # Check LOG_LEVEL_STDOUT to see if this level of entry goes to STDOUT.
    # XXX This is the horror that happens when your language doesn't have a hash data struct.
    eval log_level_int="\$LOG_LEVEL_${log_level}";
    eval log_level_stdout="\$LOG_LEVEL_${LOG_LEVEL_STDOUT}"
    if [ $log_level_stdout -le $log_level_int ]; then
        # STDOUT
        printf "${log_color}[$(date +"%Y-%m-%d %H:%M:%S %Z")] [${log_level}] ${log_text} ${LOG_DEFAULT_COLOR}\n";
    fi
    eval log_level_log="\$LOG_LEVEL_${LOG_LEVEL_LOG}"
    # Check LOG_LEVEL_LOG to see if this level of entry goes to LOG_PATH
    if [ $log_level_log -le $log_level_int ]; then
        # LOG_PATH minus fancypants colors
        if [ ! -z $LOG_PATH ]; then
            printf "[$(date +"%Y-%m-%d %H:%M:%S %Z")] [${log_level}] ${log_text}\n" >> $LOG_PATH;
        fi
    fi

    return 0;
}

log_info()      { log "$@"; }
log_success()   { log "$1" "SUCCESS" "${LOG_SUCCESS_COLOR}"; }
log_error()     { log "$1" "ERROR" "${LOG_ERROR_COLOR}"; }
log_warning()   { log "$1" "WARNING" "${LOG_WARN_COLOR}"; }
log_debug()     { log "$1" "DEBUG" "${LOG_DEBUG_COLOR}"; }

# End Logging Section
#--------------------------------------------------------------------------------------------------

