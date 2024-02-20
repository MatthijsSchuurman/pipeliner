#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/environment.class.sh

PIPELINER_IMAGES_BUILT=""

Docker_Build() {
  local dockerfile=$1
  local tag=$2
  local arguments="$3"

  Log_Group "Docker Build $dockerfile $tag"
  dockerCommand="docker build"
  dockerCommand+=" --file $dockerfile"
  dockerCommand+=" --tag $tag"

  for argument in $arguments; do
    dockerCommand+=" --build-arg $argument"
  done

  dockerCommand+=" ."

  $dockerCommand 2>&1
  result=$?

  Log_Group_End

  return $result
}

Docker_Run() {
  local tag=$1
  local workdir=$2
  local env=$3

  local commands=
  if [ ${#@} -gt 3 ]; then
    shift 3
    commands=("$@")
  fi

  Log_Group "Docker Run $tag $commands"

  dockerCommand="docker run"
  dockerCommand+=" --volume $(realpath "$(Files_Path_Root)"):/work"
  dockerCommand+=" --user $(id -u):$(id -g)"

  if [ $(Environment_Platform) == "local" ]; then
    dockerCommand+=" --interactive --tty"
  fi

  if [ "$workdir" ]; then
    dockerCommand+=" --workdir /work/$workdir"
  fi

  dockerCommand+=" --env HOME=/work"
  for e in $env; do
    dockerCommand+=" --env $e"
  done

  dockerCommand+=" $tag $commands"

  $dockerCommand 2>&1
  result=$?

  Log_Group_End

  return $result
}

Docker_Runner() {
  local image=$1
  local workdir=$2
  local env=$3
  shift 3
  local commands=("$@")

  if [[ "$image" =~ [^a-zA-Z0-9_-] ]] || [ ! -f $(Files_Path_Pipeliner)/$image/Dockerfile ]; then
    Log_Error "Docker image $image not found" >&2
    return 1
  fi

  if ! grep -q "$image" <<< "$PIPELINER_IMAGES_BUILT"; then
    Docker_Build $(Files_Path_Pipeliner)/$image/Dockerfile $image:runner

    if [ $? != 0 ]; then
      Log_Error "Failed to build docker file: $(Files_Path_Pipeliner)/$image/Dockerfile" >&2
      return 1
    fi

    PIPELINER_IMAGES_BUILT="$PIPELINER_IMAGES_BUILT$image
"
  fi

  Docker_Run $image:runner "$workdir" "$env" "$commands"
}

Docker_List() {
  local tag=$1

  images=$(docker images $tag | tail +2)
  images=$(echo $images | sed -E "s/ +/ /g")

  for image in $images; do
    echo $image | cut -d ' ' -f 1,2,3 #only output the first 3 columns
  done
}

Docker_Save() {
  local tag=$1
  local file=$2

  local exitCode=

  Log_Group "Docker Save $tag to $file"
  if [ -f "$file" ]; then
    Log_Warning "Overwriting docker image $file"
    rm "$file"
  fi

  rm -f docker-image.tmp
  docker save --output=docker-image.tmp "$tag"
  if [ $? != 0 ]; then
    Log_Error "Failed to save docker image $tag"
    Log_Group_End
    return 1
  fi

  extension=${file##*.}
  case $extension in
    "gz")
      gzip docker-image.tmp
      if [ $? != 0 ]; then
        Log_Error "Failed to gzip docker image $tag"
        Log_Group_End
        return 1
      fi

      mv docker-image.tmp.gz "$file"
      ;;
    "xz")
      xz docker-image.tmp
      if [ $? != 0 ]; then
        Log_Error "Failed to xz docker image $tag"
        Log_Group_End
        return 1
      fi

      mv docker-image.tmp.xz "$file"
      ;;
    "bz2")
      bzip2 docker-image.tmp
      if [ $? != 0 ]; then
        Log_Error "Failed to bzip2 docker image $tag"
        Log_Group_End
        return 1
      fi

      mv docker-image.tmp.bz2 "$file"
      ;;
    *) #tar
      mv docker-image.tmp "$file"
      ;;
  esac

  Log_Group_End
}