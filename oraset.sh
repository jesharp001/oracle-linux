## -- =====================================================
# -- JSHARP's script for setting the Oracle env
# -- using a menu @ login prompt. 
# -- ********************************************
# -- This script is meant for Linux only.
# -- -- Put this script in the /etc/profile.d/ directory.
## -- *******************************************
# -- ~/.bashrc edit for setting the bash prompt to env
# -- variables is at the bottom. Used to keep track of:
# -- -- what database the environment is set for,
# -- -- user logged in as,
# -- -- machine connected to, 
# -- -- and if session is an ssh connection.
# -- ********************************************
# -- Please be kind to spiders.
## -- *******************************************
# -- Dependencies: 
# -- -- /etc/oratab
# -- -- bash
## -- =====================================================
#
# Check dependencies: 
if [ -f /etc/oratab ]; then
    OTAB=/etc/oratab
else
    echo "oratab not found in linux kernel files."
    exit
fi
##
# Ask user which database: 
if [ -z $1 ]; then
# egrep -v to exclude comment lines in oratab
# -- commented using '#' OR (=|) commented using '\*'
# cut command to exclude parts that != the oracle SID
# -- cut -f1 parameter = field 1
# -- cut -d: parameter = delimiter=':'
    SIDLIST=$(egrep -v '#|\*' ${OTAB} | cut -f1 -d:)
    PS3='SID? '
    select sid in ${SIDLIST}; do
        if [ -n $sid ]; then
            HOLD_SID=$sid
            break
        fi
    done
else
    if egrep -v '#|\*' ${OTAB} | grep -w "${1}:">/dev/null; then
        HOLD_SID=$1
    else
        echo "SID: $1 not found in $OTAB"
    fi
    shift
fi
#
# Set Oracle environment variables according to user input
export ORACLE_SID=$HOLD_SID
export ORACLE_HOME=$(egrep -v '#|\*' $OTAB | grep -w $ORACLE_SID:|cut -f2 -d:)
export ORACLE_BASE=${ORACLE_HOME%%/product*}
export TNS_ADMIN=$ORACLE_HOME/network/admin
export ADR_BASE=$ORACLE_BASE/diag
#
# Set bash prompt to reflect environment variables -- copy these 2 lines to the ~/.bashrc file.
# export OSID=${ORACLE_SID}
# export PS1='\[\e[0;31m\][${OSID}]\[\e[0;35m\]\u\[\e[0;37m\]@\h\e[0;33m${text}\e[m\w $ '
