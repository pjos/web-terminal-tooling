#!/usr/bin/env bash

__oc_ps1()
{
: ${KUBECONFIG:=~/.kube/config}
test -f ${KUBECONFIG} &&
    {
        awk -F'/' '/current-context/{
            proj=gensub(/(.+) (.+)/,"\\2","g", $1)
            cluster=gensub(/api-(.+)-svk-local:6443/,"\\1","g",$2)
            split($3,a,":"); user=a[length(a)]
            # ---------------------------------------------------------------
            # Lets construct ocp prompt
            # ---------------------------------------------------------------
            # OCP User
            if ( cluster == "ocplabb" )  {
              clusterColor="\033[32m";
              cluster="labb ";
            }
    	    else if ( cluster == "openshift-development" )  {
              clusterColor="\033[32m";
              cluster="dev ";
            }
            else if  ( cluster == "openshift-stage" ) {
              clusterColor="\033[33m";
              cluster="stg";
            }
            else if  ( cluster == "openshift-prod" ) {
              clusterColor="\033[31m";
              cluster="pro";
            }
            else {
              clusterColor="\033[31m";
            }

            PS1=clusterColor
            PS1=PS1 user
            # OC Cluster
            PS1=PS1 "\033[36m"
            PS1=PS1 "@"
            PS1=PS1 clusterColor
            PS1=PS1 cluster
            # OCP Projekt
            PS1=PS1 "\033[36m"
            PS1=PS1 " "proj
            PS1=PS1 "\033[0m"
            # Returnera resultat
            print PS1 " "
        }' ${KUBECONFIG}
    }
}

# To disable directory shortening set PROMPT_DIRTRIM=-1 in the top of your ~/.profile
test -z "$PROMPT_DIRTERM" && PROMPT_DIRTRIM=1

PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
#PS1="$PS1"'\n'                 # new line
PS1="$PS1"'${PROMPT_START@P}\[\e[${PROMPT_COLOR}m\]\h '
PS1="$PS1"'`__oc_ps1`'    # ocp context user
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\w'                 # current working directory
PS1="$PS1"'\[\033[36m\]'  # change color to cyan
PS1="$PS1"'`__git_ps1`'   # bash function
PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'$ '                 # prompt: always $


