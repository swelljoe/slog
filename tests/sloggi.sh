#!/bin/sh
#--------------------------------------------------------------------------------------------------
# slog - Simple logging for POSIX and bash shells
# Copyright (c) Fred Palmer, Joe Cooper
# Licensed under the MIT license
# http://github.com/swelljoe/slog
# (Original bash4log version: http://github.com/fredpalmer/log4bash)
#--------------------------------------------------------------------------------------------------

# XXX Output is not quite TAP, but should be. We could make a TAP mode for slog, or strip the
# non-tap output in the log.

LOG_PATH="./my.log"
. ../slog.sh

log "ok 1 - This is regular log message... "

log_info "ok 2 - So is this..."

log_success "ok 3 - Yeah!! Awesome Possum."

log_warning "ok 4 - Luke ... you turned off your targeting computer"

log_error "ok 5 - Whoops! I made a booboo"

# Test if log level settings work
LOG_LEVEL_LOG="ERROR"
log_info "ok 6 - This should only appear on the console and not in the log file"

if [ -e ./my.log ]; then
    # Did the log get created with actual data?
    grep -q Whoops "$LOG_PATH"
    if [ $? -eq 0 ]; then
        log_success "ok 7 - Log was created successfully!"
    else
        echo "not ok 7 - Log file was created, but doesn't contain the right data."
    fi
    # Check to see if test 6 didn't go to log file due to LOG_LEVEL_LOG
    grep -q -v 'ok 6' "$LOG_PATH"
    if [ $? -eq 0 ]; then
    	log_success "ok 8 - Log file does not contain log entry from test 6. That's good!"
    else
        log_error "not ok 8 - Log contains entry created in test 6, but shouldn't due to LOG_LEVEL_LOG"
    fi
    rm $LOG_PATH
else
    echo "not ok 7 - No log file was created."
    echo "not ok 8 - No log file was created."
fi

