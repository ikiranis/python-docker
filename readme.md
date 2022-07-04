## Python docker container

#### Build python image

```
docker build -t python . 
or
docker build -t python - < Dockerfile
or
docker build -t python - < Dockerfile --no-cache
```

#### Check image creation (python image in list)

```
docker images
```

#### Create container

```
docker run -it -v $(pwd)/code:/home/python --name python-container python
or
docker run --name python-container -it python
```

- **python-container**: name of the container
- **python**: name of the image

##### You have to delete container, if you want to run it again

```
docker rm -f docker-container
```

##### Create container and keep it alive. Then, login

```
docker run -d -t --name python-container python
or
docker run -d -t -v $(pwd)/code:/home/python --name python-container python

docker exec -it python-container /bin/bash
```
