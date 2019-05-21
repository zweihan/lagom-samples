#!/bin/bash

setTag() {
    ## Assuming `docker images` sorts in reverse chronological order (and probably it'll be pointing to an 
    ## empty repository anyway) we list all images, filter by non-latest and filter by name. Finally, take 
    ## only the first match (which is the recently built).
    export IMAGE_TAG=`docker images  |grep shopping-cart|grep -v latest | awk -F\  '{print $2}'| head -1`
    echo " - - - "
    echo "Built images shopping-cart:$IMAGE_TAG"
    echo "Built images inventory:$IMAGE_TAG"
    echo " - - - "
}

build() {
    SHOPPING_CART_SOURCES=$1
    BUILD_TOOL=$2
    
    (
        cd $SHOPPING_CART_SOURCES
        
        if [ "$BUILD_TOOL" == "sbt" ]; then
            sbt clean docker:publishLocal 
        elif [ "$BUILD_TOOL" == "maven" ]; then
            mvn package docker:build
        else
            echo "unknown build tool [$BUILD_TOOL]"
            exit 1
        fi
    )

}