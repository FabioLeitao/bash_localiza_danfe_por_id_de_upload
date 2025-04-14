#"/bin/bash
COMANDO=$0
ARGUMENTO=$1
FLAG=$2
QUANTOS=$#
TIMESTAMP=`date +"%Y-%m-%d %T"`
CONTADOR=0
ACHADOS=0
DEBUG="TRUE"

PASTA_HOME="${HOME}"
PASTA_LOG="${PASTA_HOME}/log"
ARQUIVO_LOG="${PASTA_LOG}/busca_danfe_por_id_de_upload.log"
PASTA_BKP_CHKIN="/var/lib/danfe-checkin-backup/bkp/checkin"
PASTA_DESTINO="evidencia/checkin"
ARQUIVO_BUSCA="${FLAG}"
PASTA_DATA="${ARGUMENTO}"
PASTA_BUSCA="${PASTA_BKP_CHKIN}/${PASTA_DATA}"
PASTA_RESULTADO="${PASTA_BKP_CHKIN}/${PASTA_DESTINO}"

FILETYPE=`/usr/bin/which file`
COPY=`/usr/bin/which cp`
GREP=`/usr/bin/which grep`
PDF2TXT=`/usr/bin/which pdftotext`
WHOAMI=`/usr/bin/which whoami`
HOSTNAME=`/usr/bin/which hostname`
TOUCH=`/usr/bin/which touch`
SFTP=`/usr/bin/which sftp`
SCP=`/usr/bin/which scp`
SUM=`/usr/bin/which sha256sum`
DIFF=`/usr/bin/which diff`
EXPR=`/usr/bin/which expr`
FIND=`/usr/bin/which find`
CAT=`/usr/bin/which cat`
CUT=`/usr/bin/which cut`
AWK=`/usr/bin/which awk`
SED=`/usr/bin/which sed`
UNZIP=`/usr/bin/which unzip`
WC=`/usr/bin/which wc`
NC=`/usr/bin/which nc`
ID=`/usr/bin/which id`
QUAL=`${HOSTNAME} -s`
QUEM=`${WHOAMI}`

LANG=en_US.UTF-8
#LC_ALL=C.UTF-8
export LANG=en_US.UTF-8
#export LC_ALL=C.UTF-8


function ajuda_(){
        echo "Usage: $COMANDO <AAAA> <nome do arquivo txt> [-h|--help]" >&2 ;
}

die_(){
        exit 999
}

is_usr_(){
        local id=$(${ID} -u)
        if [ $id -ne 1000 ] ; then
                echo "4:500:ERROR - You have to be usr sc-tos-app reload to run $0."    # returncode 4 = Protocol Error - put sensor in DOWN status
                do_log_ ERROR - You have to be usr sc-tos-app to run $0.
                die_ ;
        fi
}

do_log_(){
        # Aceitaria qualquer string para ser anotada no arquivo de evidencias configurado
        LOG_=$@
        TIMESTAMP=`date +"%Y-%m-%d %T"`
        if [ ! -d ${PASTA_LOG} ] ; then
                mkdir -p ${PASTA_LOG}
                do_log_ WARN - Recriada pasta de logs
        fi
        touch ${ARQUIVO_LOG}
        if [ ${DEBUG} = "TRUE" ] ; then
                echo "${TIMESTAMP} - ${LOG_}" | tee -a ${ARQUIVO_LOG}
        else
                echo "${TIMESTAMP} - ${LOG_}" >> ${ARQUIVO_LOG}
        fi
}

function busca_danfe_id_(){
#	cat peptides.txt | while read line; do something_with_$line_here; done
#	cat busca.txt | while read line ; do echo $line ; done
	ARRAY=`${CAT} ${ARQUIVO_BUSCA}`
	for ID_ARQUIVO in ${ARRAY} ; do 
		${FIND} ${PASTA_BUSCA} -name ${ID_ARQUIVO} | $GREP -q ${ID_ARQUIVO}
		ULTIMA=${?}
		if [ ${ULTIMA} -eq 0 ] ; then # testa se achou mesmo um arquivo com nome id
			ACHADO=`${EXPR} ${ACHADO} + 1`
			DOCUMENTO=`find ${PASTA_BUSCA} -name ${ID_ARQUIVO} | $GREP ${ID_ARQUIVO}`
			do_log_ OK - "${ID_ARQUIVO}" existe - Nº ${ACHADO};
			${FILETYPE} "${DOCUMENTO}" | ${GREP} -q -i pdf 
			ULTIMA=${?}
			if [ ${ULTIMA} -eq 0 ] ; then # testa se arquivo é pdf
				do_log_ OK - "${ID_ARQUIVO}" é PDF ;
				${PDF2TXT} "${DOCUMENTO}"
				ULTIMA=${?}
				if [ ${ULTIMA} -eq 0 ] ; then # testa se converteu pra TXT
					do_log_ OK - "${ID_ARQUIVO}" convertido pra TXT ;
					${GREP} -q DANFE "${DOCUMENTO}.txt"
					ULTIMA=${?}
					if [ ${ULTIMA} -eq 0 ] ; then # testa se contem a string DANFE
						do_log_ OK - "${ID_ARQUIVO}".txt tem string DANFE ;
						${COPY} -prv "${DOCUMENTO}" "${PASTA_RESULTADO}/${ID_ARQUIVO}.pdf"
						CONTADOR=`${EXPR} ${CONTADOR} + 1`
						do_log_ OK - ${ID_ARQUIVO}.pdf guardado - Nº ${CONTADOR};
					else
			    			do_log_ WARN - "${ID_ARQUIVO}" não tem string DANFE ;
						rm -f "${DOCUMENTO}.txt"
					fi
				else
			    		do_log_ WARN - "${ID_ARQUIVO}" não convertido pra TXT ;
				fi
			else 
			    	do_log_ WARN - "${ID_ARQUIVO}" não é PDF ;
			fi
		else
			do_log_ WARN - "${ID_ARQUIVO}" não existe  ;
		fi
	done 
	cd ${PASTA_RESULTADO}
	pwd
	do_log_ INFO - Achados ${ACHADO} arquivos, destes ${CONTADOR} são DANFE e foram guardados na pasta acima
}

function arruma_casa_(){
	is_usr_;
	if [ -d ${PASTA_BUSCA} ] ; then
		do_log_ OK - "${PASTA_BUSCA}" existe ;
	else
		do_log_ ERROR - "${PASTA_BUSCA}" não existe ;
		die_;
	fi
	
	if [ ! -d ${PASTA_RESULTADO} ] ; then
		mkdir -p ${PASTA_RESULTADO}
		do_log_ WARN - "${PASTA_RESULTADO}" recriada;
	fi

	if [ -f ${ARQUIVO_BUSCA} ] ; then
		busca_danfe_id_;
	else	
		do_log_ ERROR - "${ARQIUVO_BUSCA}" não existe;
		die_;
	fi
}

function atua_no_flag_(){
        if [ ${QUANTOS} -gt 3 ]; then
                ajuda_;
        else
          case "${FLAG}" in
                -h|--help)
                        ajuda_ ;
                        ;;
                *)
        		arruma_casa_   ;
                        ;;
          esac
        fi
}

function main_(){
	atua_no_flag_;
}

if [ ${QUANTOS} -lt 2 ]; then
                ajuda_;
else
  case "${ARGUMENTO}" in
        -h|--help)
                ajuda_ ;
                exit 1
                ;;
        *)
                main_;
                ;;
  esac
fi
exit 0

