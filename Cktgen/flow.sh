#!/bin/bash

SCRIPT=cktgen.py
PORT=8082
TECHDIR=../DetailedRouter/DR_COLLATERAL_Generator/strawman1
TECHFILE=Process.json
INPUTVOL=inputVol
OUTPUTVOL=outputVol
ROUTERVOL=routerStrawman
SKIPROUTER=NO
SKIPGENERATE=NO
SHOWGLOBALROUTES=""
SHOWMETALTEMPLATES=""
ROUTE=" --route"
PLACERJSON=""
GRJSON=""
SOURCE=""
SMALL=""
NO_INTERFACE=""
NETS_TO_ROUTE=""
NETS_NOT_TO_ROUTE=""

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--script)
    SCRIPT="$2"
    shift
    shift
    ;;
    -p|--port)
    PORT="$2"
    shift
    shift
    ;;
    -td|--techdir)
    TECHDIR="$2"
    shift
    shift
    ;;
    -tf|--techfile)
    TECHFILE="$2"
    shift
    shift
    ;;
    -iv|--inputvolume)
    INPUTVOL="$2"
    shift
    shift
    ;;
    -ov|--outputvolume)
    OUTPUTVOL="$2"
    shift
    shift
    ;;
    -rv|--routervolume)
    ROUTERVOL="$2"
    shift
    shift
    ;;
    -sr|--skiprouter)
    SKIPROUTER=YES
    shift
    ;;
    -sg|--skipgenerate)
    SKIPGENERATE=YES
    shift
    ;;
    -sv|--startviewer)
    STARTVIEWER=YES
    shift
    ;;
    -sgr|--show_global_routes)
    SHOWGLOBALROUTES=" --show_global_routes"
    shift
    ;;
    -smt|--show_metal_templates)
    SHOWMETALTEMPLATES=" --show_metal_templates"
    shift
    ;;
    -sar|--skipactualrouting)
    ROUTE=""
    shift
    ;;
    -pj|--placer_json)
    PLACERJSON=" --placer_json $2"
    shift
    shift
    ;;
    -gj|--gr_json)
    GRJSON=" --gr_json $2"
    shift
    shift
    ;;
    -src|--source)
    SOURCE=" --source $2"
    shift
    shift
    ;;
    --small)
    SMALL=" --small"
    shift
    ;;
    --no_interface)
    NO_INTERFACE=" --no_interface"
    shift
    ;;
    --nets_to_route)
    NETS_TO_ROUTE=" --nets_to_route $2"
    shift
    shift
    ;;
    --nets_not_to_route)
    NETS_NOT_TO_ROUTE=" --nets_not_to_route $2"
    shift
    shift
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo SCRIPT  = "${SCRIPT}"
echo PORT    = "${PORT}"
echo TECHDIR = "${TECHDIR}"
echo TECHFILE = "${TECHFILE}"
echo INPUTVOL = "${INPUTVOL}"
echo OUTPUTVOL = "${OUTPUTVOL}"
echo ROUTERVOL = "${ROUTERVOL}"
echo SKIPROUTER = "${SKIPROUTER}"
echo SKIPGENERATE = "${SKIPGENERATE}"
echo STARTVIEWER = "${STARTVIEWER}"
echo PLACERJSON = "${PLACERJSON}"
echo GRJSON = "${GRJSON}"
echo SOURCE = "${SOURCE}"
echo SMALL = "${SMALL}"
echo NETS_TO_ROUTE = "${NETS_TO_ROUTE}"
echo NETS_NOT_TO_ROUTE = "${NETS_NOT_TO_ROUTE}"


M_INPUT="--mount source=${INPUTVOL},target=/Cktgen/INPUT"
M_INPUT_VIEWER="--mount source=${INPUTVOL},target=/public/INPUT"
M_out="--mount source=${OUTPUTVOL},target=/Cktgen/out"
M_DR_COLLATERAL="--mount source=${ROUTERVOL},target=/Cktgen/DR_COLLATERAL"

docker volume rm -f ${ROUTERVOL}
(cd ${TECHDIR} && tar cvf - .) | docker run --rm ${M_DR_COLLATERAL} -i ubuntu bash -c "cd /Cktgen/DR_COLLATERAL && tar xvf -"
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create DR_COLLATERAL"
    exit $?
fi

if [ ${SKIPGENERATE} = "NO" ]; then
    docker volume rm -f ${OUTPUTVOL}
    docker run --rm ${M_INPUT} ${M_DR_COLLATERAL} cktgen bash -c "source /general/bin/activate && cd /Cktgen && python ${SCRIPT} -n mydesign ${ROUTE}${SHOWGLOBALROUTES}${SHOWMETALTEMPLATES}${SOURCE}${PLACERJSON}${GRJSON}${SMALL}${NETS_TO_ROUTE}${NETS_NOT_TO_ROUTE}"
    if [ $? -ne 0 ]; then
	echo "ERROR: Failed to run Cktgen"
	exit $?
    fi
fi

#ROUTER_IMAGE=darpaalign/detailed_router
#ROUTER_IMAGE=stevenmburns/intel_detailed_router
ROUTER_IMAGE=nikolai_router

if [ ${SKIPROUTER} = "NO" ]; then
    docker run --rm ${M_out} ${M_INPUT} ${M_DR_COLLATERAL} ${ROUTER_IMAGE} bash -c "cd /Cktgen && amsr.exe -file INPUT/ctrl.txt"
    if [ $? -ne 0 ]; then
	echo "ERROR: Failed to run detailed_router"
	exit $?
    fi
    docker run --rm ${M_out} ${M_INPUT} ${M_DR_COLLATERAL} cktgen bash -c "source /general/bin/activate; cd /Cktgen && python ${SCRIPT} --consume_results -n mydesign ${SOURCE}${PLACERJSON}${SMALL}${NO_INTERFACE}"
    if [ $? -ne 0 ]; then
	echo "ERROR: Failed to run Cktgen (consume)"
	exit $?
    fi
fi

if [[ -v STARTVIEWER ]] && [[ ${STARTVIEWER} = "YES" ]]; then
    docker run --rm ${M_INPUT_VIEWER} -p${PORT}:8000 -d viewer_image /bin/bash -c "source /sympy/bin/activate && cd /public && python -m http.server"
    if [ $? -ne 0 ]; then
	echo "ERROR: Failed to run viewer_image"
	exit $?
    fi
fi
