#!/bin/sh

# find all "interesting" source files, so I can sed various things:
# - copyright notice
# - license (it's changed at least once already)
# - homepage (it's going to change at least once more ;-)

find . \( -name BUILDING -o -name NOTES -o -name README -o -name TODO \
       -o -name COPYRIGHT \
       -o -name "*.in" -o -name "*.sh" \
       -o -name "*.c" -o -name "*.h" -o -name "*.mu4" \) \
       -exec "$@" {} \;
