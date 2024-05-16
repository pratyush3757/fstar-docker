## fstar-docker
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)  

### Notice: The package may be unstable currently. I've been trying to make it compile the packages statically, and to make the image a little slimmer.

Docker build files for [Fstar](https://www.fstar-lang.org/) language. The build is done through `opam`, and uses the `master` branch of the [Fstar repo](https://github.com/FStarLang/FStar/tree/master).

### Installation
A built package (size: ~3.5G) is also published on `ghcr.io`.
To pull the image using the command line:
```bash
docker pull ghcr.io/pratyush3757/fstar-docker:master
```

### Usage:
The built packages are currently in `/home/docker/.opam/default/bin/`
```bash
docker run --rm -it --entrypoint /home/docker/.opam/default/bin/fstar.exe ghcr.io/pratyush3757/fstar-docker:master

docker run --rm -it --entrypoint /home/docker/.opam/default/bin/fstar.exe ghcr.io/pratyush3757/fstar-docker:master --version
```
