docker-storm
=============
A Dockerfile for deploying a [Storm](http://storm.apache.org/) using [Docker](https://www.docker.io/)
 containers. 

The image is registered to the [Quai.io Index](https://quay.io/repository/xeizmendi/docker-storm)

Installation
------------
1. Install [Docker](https://www.docker.com/)
2. Pull the Docker image : ```docker pull quay.io/xeizmendi/docker-storm```

Usage
-----

You can override storm default configuration by passing environment variables to the running container as follows : 

```
 --env "CONFIG_WORKER_CHILDOPTS=-Xmx512m"
```

`CONFIG_WORKER_CHILDOPTS` will be add to storm.yaml as `worker.childopts`.
