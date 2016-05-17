#!/bin/bash
#
#
#
#
#
#
#
##############################################################
function check_web_access()
{
	case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
  		 [23]) echo "HTTP connectivity is up"; sleep 5; ;;
  			5) echo "The web proxy won't let us through"; sleep 5; ;;
  			*) echo "The network is down or very slow"; sleep 5; ;;
	esac
}

# Call to function to validate HTTP connection status
check_web_access