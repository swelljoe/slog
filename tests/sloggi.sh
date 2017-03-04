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

log "ok 1 - This is regular log message... ";

log_info "ok 2 - So is this...";

log_success "ok 3 - Yeah!! Awesome Possum.";

log_warning "ok 4 - Luke ... you turned off your targeting computer";

log_error "ok 5 - Whoops! I made a booboo";

if [ -e ./my.log ]; then
    # Did the log get created with actual data?
    grep -q Whoops "$LOG_PATH"
    if [ $? -eq 0 ]; then
        log_success "ok 6 - Log was created successfully! We'll remove it now."
        rm "$LOG_PATH"
    else
        echo "not ok 6 - Log file was created, but doesn't contain the right data."
    fi
else
    echo "not ok 6 - Some tests failed."
fi

