# dast-days

Aiming to build a true local and ephemeral capability to dast scan a zarf package in uds-core with owasp zap.

Will need a uds `k3d-core-slim-dev` deployment - potentially one without keycloak for speed / simplicity.

## Prereqs
- `uds-cli`
- `docker`
- `k3d`


From nothing, 
- deploy uds-core-slim (eventually w/o keycloak)
  -TODO build uds-ozempic (slim-dev without keycloak, auth too much for dash days dasting)
- deploy an app from a zarf package
- run a task that uses a docker in docker based image to run the latest owasp-zap image agianst the deployed apps <app>.uds.dev end point
- collect dast scan results



## Building Docker in Docker image to zap scan in ci...
`docker build -t ephemeral-dast .`




### DAST Task


`docker run --privileged -it --rm --name ephem-dind ephemeral-dast:latest sleep 10 && docker run --network="host" -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t https://podinfo.uds.dev`

Get results from the dind container by mounting local volume:
`docker run --privileged -it --rm --name ephem-dind ephem-dind:latest sleep 10 && docker run --network="host" -v $(pwd):/zap/wrk -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t https://podinfo.uds.dev -r report.html`

<details> <summary>Click to expand old notes</summary>

# DAST via Docker in docker locally

## Magical command TLDR
`docker run --privileged -it --rm --name ephem-dind ephemeral-dast:latest sleep 10 && docker run --network="host" -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t https://podinfo.uds.dev`

## Deploy podinfo
Using the [podinfo repo](https://gitlab.devops.nswccd.navy.mil/project-blue/certificate-to-ship/example-projects/podinfo.git) `@feature/dast-scan`

create for mac book - `zarf package create . -a arm64`
for ci env - `zarf package create . -a amd64`

deploy pod info with the local DOMAIN set `zarf package deploy zarf-package-podinfo-arm64-6.3.5.tar.zst --set=DOMAIN=uds.dev --confirm`

### when in doubt just sleep it out
Apparently not detaching the docker run for the `dind` image doesn't fully let docker initialize properly, BUT by sleeping it works like a champ locally...

To avoid having to run a `-d` detached image you can just sleep the dind container run and then you wont have to `docker kill <image-id>` the detached container and `docker rmi <your-image>`

```docker run --privileged -it --rm --name ephem-dind ephemeral-dast:latest sleep 30 && /bin/sh 

</details>

