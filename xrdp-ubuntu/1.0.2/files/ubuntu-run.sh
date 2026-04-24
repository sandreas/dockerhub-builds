#!/bin/bash


start_xrdp_services() {
    # Preventing xrdp startup failure
    rm -rf /var/run/xrdp-sesman.pid
    rm -rf /var/run/xrdp.pid
    rm -rf /var/run/xrdp/xrdp-sesman.pid
    rm -rf /var/run/xrdp/xrdp.pid

    # Use exec ... to forward SIGNAL to child processes
    xrdp-sesman && exec xrdp -n
}

stop_xrdp_services() {
    xrdp --kill
    xrdp-sesman --kill
    exit 0
}


# form: "<username> <password> <sudo_yes_no>"
if [[ "$USERS_TO_ADD" == "" ]]; then 
    echo "No input parameters. exiting..."
    echo "there should be 3 input parameters per user: '<username> <password> <sudo_yes_no>'"
    exit
fi

arr=($USERS_TO_ADD)
length=${#arr[@]}
chunk_size=3

for ((i=0; i<length; i+=chunk_size)); do
    USERNAME="${arr[i]}"
    PASSWORD="${arr[i+1]}"
    ENABLE_SUDO="${arr[i+2]}"

    addgroup $USERNAME
    #echo "username is $1"
    useradd -m -s /bin/bash -g $USERNAME $USERNAME
    wait
    #getent passwd | grep foo
    echo $USERNAME:$PASSWORD | chpasswd 
    wait
    #echo "sudo is $3"
    if [[ "$ENABLE_SUDO" == "yes" ]]; then
        usermod -aG sudo $1
    fi
    wait
    echo "user '$USERNAME' is added"    
done



#echo Entryponit script is Running...
#echo
#
#users=$(($#/3))
#mod=$(($# % 3))
#
##echo "users is $users"
##echo "mod is $mod"
#
#if [[ $# -eq 0 ]]; then 
#    echo "No input parameters. exiting..."
#    echo "there should be 3 input parameters per user"
#    exit
#fi
#
#if [[ $mod -ne 0 ]]; then 
#    echo "incorrect input. exiting..."
#    echo "there should be 3 input parameters per user"
#    exit
#fi
#echo "You entered $users users"
#
#
#while [ $# -ne 0 ]; do
#
#    addgroup $1
#    #echo "username is $1"
#    useradd -m -s /bin/bash -g $1 $1
#    wait
#    #getent passwd | grep foo
#    echo $1:$2 | chpasswd 
#    wait
#    #echo "sudo is $3"
#    if [[ $3 == "yes" ]]; then
#        usermod -aG sudo $1
#    fi
#    wait
#    echo "user '$1' is added"
#
#    # Shift all the parameters down by three
#    shift 3
#done
#
#
#
#echo -e "This script is ended\n"

echo -e "starting xrdp services...\n"

trap "stop_xrdp_services" SIGKILL SIGTERM SIGHUP SIGINT EXIT
start_xrdp_services