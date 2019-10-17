#!/bin/bash -x

find . -name "jqa*" -type d -depth 1 \
     -exec bash -c ' cd {}; \
                     git reset --hard HEAD ; \
                     git checkout -- . ;  \
                     git clean -d -f' \;
