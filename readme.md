## Python docker container

#### Build python image

```
docker build -t python - < Dockerfile
```

#### Check image creation (python image in list)

```
docker images
```

#### Create container

```
docker run -d -v pwd:/home/python --name python-container python
docker run --name python -it python
```

#### Login to the container

```
docker exec -it python /bin/bash
```
