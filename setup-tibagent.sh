#!/usr/bin/env bash
# Author: Abhijit Wakchaure <awakchau@tibco.com>

# Default configs, please do not change
VERSION="v1.1.0"
PORT=7816
DEFAULT_ACCESS_KEY="key"
SECRET_KEY_FROM_CLIPBOARD=$(xclip -o -sel c)
AGENT_NAME="agent_"$(date '+%Y_%m_%d_T_%H_%M_%S')

ACCESS_KEY=""
SECRET_KEY=""
SPEC=""

# -----------------------------  Helper functions  -----------------------------

function generate_random_port() {
    while nc -z 127.0.0.1 $PORT; do
        echo "$PORT is already in use, generating new port..."
        PORT=$(shuf -i 2000-9999 -n 1)
    done
    echo "Generated new random port for tibagent [$AGENT_NAME]: $PORT"
}

# arg1: error message
# [arg2]: exit code
exit_with_error() {
    printf '\n%s\n' "$1" >&2 ## Send message to stderr.
    exit 1
}

# arg1: command to run
fail_by_rc() {
    cmd_with_args="$@"
    "$@"
    rc=$?
    if [ ${rc} -ne 0 ]; then
        cmd_with_args=$(echo ${cmd_with_args} | sed "s/--password .*/--password REDACTED/")
        exit_with_error "Failed to execute command ${cmd_with_args}" $rc
    fi
}


# ---------------------------  END Helper functions  ---------------------------

function start_tibagent() {
    echo -e "\nStep 0/4: Making tibagent binary executable..."
    fail_by_rc chmod +x tibagent

    USERNAME=$(cat ~/.tibco/ec/ec.rc | cut -d '@' -f1)"@tibco.com"
    PASSWORD=$(cat ~/.tibco/ec/ec.rc | cut -d '@' -f2)

    echo -e "\nStep 1/4: Logging out and logging in with username [$USERNAME]..."
    fail_by_rc ./tibagent logout
    fail_by_rc ./tibagent login --username $USERNAME --password $PASSWORD

    echo -e "\nStep 2/4: Generating a random port for tibagent [$AGENT_NAME] and configuring..."
    generate_random_port
    fail_by_rc ./tibagent configure agent -p $PORT $AGENT_NAME

    ACCESS_KEY=${ACCESS_KEY:-$DEFAULT_ACCESS_KEY}
    SECRET_KEY=${SECRET_KEY:-$SECRET_KEY_FROM_CLIPBOARD}
    if [ "$ACCESS_KEY" = "system" ]; then
        echo -e "\nStep 3/4: Configuring connect not required with system access key, skipping this step..."
    else
        echo -e "\nStep 3/4: Configuring connect for tibagent [$AGENT_NAME] with access key [$ACCESS_KEY] and secret key [$SECRET_KEY]..."
        fail_by_rc ./tibagent configure connect -a ${ACCESS_KEY} -s ${SECRET_KEY} $AGENT_NAME
    fi
    
    echo -e "\nStep 4/4: Starting tibagent [$AGENT_NAME] with spec [$SPEC]..."
    fail_by_rc ./tibagent start agent --spec ${SPEC} $AGENT_NAME
}

function print_help() {
    echo -e "\n-----  setup-tibagent ${VERSION}  -------\n"
    echo -e "-a | --access-key: Optional, default is 'key', pass 'system' if you want to use system access key"
    echo -e "-s | --secret-key: Optional, by default secret key is taken from clipboard"
    echo -e "-p | --spec:       Required! Spec for the tibagent\n"
}

function validate() {
    if [ -z "$SPEC" ]; then
        echo 'ERROR: Missing required flag -p (or --spec)' >&2
        exit 1
    fi
}

# ---------------------------  MAIN  ---------------------------

if [ $# -eq 0 ]; then
    print_help
    echo 'ERROR: Missing required flag -p (or --spec)' >&2
    exit 1
fi

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
    -a | --access-key)
        ACCESS_KEY="$2"
        shift # past argument
        shift # past value
        ;;
    -s | --secret-key)
        SECRET_KEY="$2"
        shift # past argument
        shift # past value
        ;;
    -p | --spec)
        SPEC="$2"
        shift # past argument
        shift # past value
        ;;
    -* | --*)
        print_help
        echo "Unknown option $1" >&2
        exit 1
        ;;
    *)
        POSITIONAL_ARGS+=("$1") # save positional arg
        shift                   # past argument
        ;;
    esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

validate
start_tibagent
