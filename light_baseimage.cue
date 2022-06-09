package light_baseimage

import (
    "dagger.io/dagger"
    "dagger.io/dagger/core"
    "universe.dagger.io/docker"
    "universe.dagger.io/docker/cli"
)

#ImageId: {
    name: string
    tag: string
}

#Image: {
    path: string

    imageId: #ImageId
    tagSuffixes: [...string]

    baseimageName: string
    baseimageTag: string
}

#BuildImage: {
    image: #Image

    dockerSocket: dagger.#Socket

    _imageSource: core.#Source & {
        path: image.path
    }

    _build: {
        for idx, tag in image.tagSuffixes {
            "_\(idx)": {

                _fullTagName: *image.imageId.tag | string
                if tag !="" {
                    _fullTagName: image.imageId.tag + "-" + tag
                }

                _buildTag: docker.#Dockerfile & {
                    source: _imageSource.output
                    buildArg: {
                        IMAGE_NAME: image.imageId.name
                        IMAGE_TAG: _fullTagName
                        BASEIMAGE_NAME: image.baseimageName
                        BASEIMAGE_TAG: image.baseimageTag
                    }
                }

                _loadTag: cli.#Load & {
                    "image": _buildTag.output
                    "host":  dockerSocket
                    "tag":   image.imageId.name + ":" + _fullTagName 
                }
            }
        }
    }
}

dagger.#Plan & {
    client: {
        filesystem: ".": read: contents: dagger.#FS
        network: "unix:///var/run/docker.sock": connect: dagger.#Socket
        env: {
            IMAGE_NAME: string | *"osixia/light-baseimage"
            IMAGE_TAG: string | *"local"
        }
    }

    _imageId: #ImageId & {
        name: client.env.IMAGE_NAME
        tag: client.env.IMAGE_TAG
    }

    _debianBullseyeImage: #Image & {
        path: "./debian/bullseye"

        imageId: _imageId
        tagSuffixes: ["", "debian", "debian-bullseye"]

        baseimageName: "debian"
        baseimageTag: "bullseye-slim"
    }

    _alpine315Image: #Image & {
        path: "./alpine/3.15"

        imageId: _imageId
        tagSuffixes: ["alpine", "alpine-3", "alpine-3.15"]

        baseimageName: "alpine"
        baseimageTag: "3.15"
    }
    
    actions: {
        build: {
            debian:
                bullseye:
                    baseimage: #BuildImage & {
                        image: _debianBullseyeImage
                        dockerSocket: client.network."unix:///var/run/docker.sock".connect
                    }
            alpine:
                "3.15":
                    baseimage: #BuildImage & {
                        image: _alpine315Image
                        dockerSocket: client.network."unix:///var/run/docker.sock".connect
                    }
        }
    }
}
