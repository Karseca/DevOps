#!/bin/bash
# Array variable declaration for functions
source_inst=(sitename)
source_host=(hostname) # FQDN 
source_email=(email@test email@test1)

# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$
INPUT_SUB/tmp/menu_sub.sh.$$ 

# Storage file for displaying command output
OUTPUT=/tmp/output.sh.$$
OUTPUT_SUB=/tmp/output_sub.sh.$$
 
# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; rm $INPUT_SUB; rm $OUTPUT_SUB; exit" SIGHUP SIGINT SIGTERM
 
#
# Purpose - display output using msgbox 
#  $1 -> set msgbox height
#  $2 -> set msgbox width
#  $3 -> set msgbox title
#
function display_output(){
	local h=${1-21}			# box height default 21
	local w=${2-41} 		# box width default 41
	local t=${3-Output} 		# box title 
	dialog --backtitle "NBSI - GOM Operations " --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}
}

function display_submenu(){
		local height=${1-21}                # box height default 21
	        local width=${2-41}                 # box width default 41
	        local title=${3-Output}             # box title
		dialog --backtitle "NBSI - GOM Operations " --title "${title}" --clear --msgbox "$(<$OUTPUT_SUB)" ${height} ${width}	
}

function options(){
	
		### display sub menu ###
		dialog --clear --help-button --backtitle "NBSI - GOM Operations" \
        	--title "[ OPERATIONS - MENU ]" \
		--menu  "You can use the UP/DOWN arrow keys, to select instance.\n\
		Choose the Instance: " 15 75 9 \
		"Instancia de Producao CX PRD - '${source_inst[0]}'" \
        	"Instancia de Producao CX PRD - DEV e QUA - '${source_inst[1]}'" \
        	"Instancia de Producao CX PRD - DBs - ${source_inst[2]}" \
        	"Instancia de Producao CX PRD - ${source_inst[3]}" \
        	"Instancia de Producao CX PRD - ${source_inst[4]}" \
	        "Instancia de Producao CX PRD - ${source_inst[5]}" \
        	"Instancia de Producao CV PRD - ${source_inst[6]}" \
	        "Instancia de Producao CV PRD - ${source_inst[7]}" \
	        "Back" 2>"${INPUT_SUB}"
			
		display_submenu 21 41
		
		submenuitem=$(<"${INPUT_SUB}")

		# make decision
		case $submenuitem in
        		'Instancia de Producao CX PRD - ${source_inst[0]}')  echo something ;;
        		'Instancia de Producao CX PRD - DEV e QUA - ${source_inst[1]}') ;;
        		'Instancia de Producao CX PRD - DBs - ${source_inst[2]}') ;;
        		'Instancia de Producao CX PRD - ${source_inst[3]}') ;;
        		'Instancia de Producao CX PRD - ${source_inst[4]}') ;;
			'Instancia de Producao CX PRD - ${source_inst[5]}') ;;
			'Instancia de Producao CV PRD - ${source_inst[6]}') ;;
			'Instancia de Producao CV PRD - ${source_inst[7]}') ;;	
			'Back');;
		esac
}

while true
do
 
	### display main menu ###
	dialog --clear  --help-button --backtitle "NBSI - GOM Operations" \
	--title "[ M A I N - M E N U ]" \
	--menu  " You can use the UP/DOWN arrow keys, the first \n\
	letter of the choice as a hot key, or the \n\
	number keys 1-4 to choose an option.\n\
	Choose the TASK to execute: " 15 75 4 \
	"Restart OMD Services" "Restart de servicos" \
	"OMD Services Recompile" "Recompilacao de OMD e Restart Servicos" \
	"Update DNS Cache" "Update de CACHE DNS" \
	Exit "Exit to the shell" 2>"${INPUT}"
	
	[ $? -ne 0 ] && break	
 
	menuitem=$(<"${INPUT}")

	# make decision 
	case $menuitem in
		'Restart OMD Services') options;
					;; 
		'OMD Services Recompile') options;
					;;
		'Update DNS Cache') 	  options;
					;;
		'Exit') clear; echo "Bye"; break
					;;
	esac

done

# if temp files found, delete them
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
[ -f $OUTPUT_SUB ] && rm $OUTPUT_SUB
[ -f INPUT_SUB ] && rm $INPUT_SUB
