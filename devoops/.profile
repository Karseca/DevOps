trap '' 2
stty eof  '?'

time=$(date +%y-%m-%d\ -\ %H:%M:%S)

if [ -f ~/etc/environment ]
then
    eval $(egrep -v '^[[:space:]]*(#|$)' < ~/etc/environment | sed 's/^/export /')
fi

# Only load bashrc when in a bash shell and not loaded yet.
# The load once is ensured by the variable $BASHRC.
if [ "$BASH" -a -s ~/.bashrc -a -z "$BASHRC" ]; then
    . ~/.bashrc
fi

clear

# Script de operacao e monitorizacao
source_inst=(instance instance02 instance03 instance04 instance05 instance06 instance07 instance08)
source_host=(server00 server01)
source /opt/devoops/default/include/gom_startup.conf


function startup {
clear
echo "#############################################"
echo ""
echo "          O que deseja fazer ?               "
echo ""
echo "#############################################"
echo ""
echo "1) Restart da solucao"
echo -e  "\e[00;31mATENCAO - IRA PARAR e ARRANCAR TODOS os SERVICOS INERENTES!\e[00m"
echo ""
echo "2) Compilacao OMD e Restart servicos"
echo -e  "\e[00;31mATENCAO - IRA RECOMPILAR e CARREGAR a CONFIG da APLICA��O e PARAR e ARRANCAR TODOS os SERVICOS INERENTES!\e[00m"
echo ""
echo "3) Update de CACHE DNS"
echo "   Para casos de nao estarem a conseguir fazer activate changes e haver hosts que nao conseguem ser contactados"
echo ""
echo "4) SAIR"
echo "   Sair do programa!"
echo ""
echo "Em caso de duvida, contatar o STAND-BY da Equipa de Monitorizacao"

while read opt
do 
    case $opt in
        "1")
	        clear
            options_startup_1
            ;;
        "2")
            clear
	        options_startup_2
            ;;
        "3")
	        clear
            options_startup_3
            ;;
        "4")
            echo "Adeus....."
            sleep 5
            exit
            ;;
          *)  
            echo "You entered an invalid option!!! Choose [1/2/3/4]"
            ;;
    esac
done
}

startup
