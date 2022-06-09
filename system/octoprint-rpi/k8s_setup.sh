#!/bin/bash

NODE=octoprint-rpi
K8S_API="k8s-main:8080"

TAINT_PRINTER_KEY=3dprinter
TAINT_PRINTER_VALUE=true
TAINT_PRINTER_EFFECT=NoSchedule
TAINT_PRINTER_ARRAY=($TAINT_PRINTER_KEY $TAINT_PRINTER_VALUE $TAINT_PRINTER_EFFECT)

TAINT_CAMERA_KEY=webcam
TAINT_CAMERA_VALUE=true
TAINT_CAMERA_EFFECT=PreferNoSchedule
TAINT_CAMERA_ARRAY=( $TAINT_CAMERA_KEY $TAINT_CAMERA_VALUE $TAINT_CAMERA_EFFECT )

TAINTS=(TAINT_PRINTER_ARRAY TAINT_CAMERA_ARRAY)

declare -n taint_arr

for taint_arr in "${TAINTS[@]}"; do
  echo "Adding taint ${taint_arr[0]}=${taint_arr[1]}:${taint_arr[2]} to node ${NODE}"
  #kubectl taint nodes $NODE ${taint_arr[0]}=${taint_arr[1]}:${taint_arr[2]}

  echo "Adding resource capacity ${taint_arr[0]}: 1 to node ${NODE}"
  echo '[{"op": "add", "path": "/status/capacity/'${taint_arr[0]}'", "value": "1"}]'
  curl --header "Content-Type: application/json-patch+json" \
  --request PATCH \
  --data '[{"op": "add", "path": "/status/capacity/'${taint_arr[0]}'", "value": "1"}]' \
  http://$K8S_API/api/v1/nodes/$NODE/status
done
