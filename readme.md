## Python docker container

- pharmcat: https://pharmcat.org/technical-docs/docker
- whatshap: https://pypi.org/project/whatshap/

#### Build python image

```
docker build . -t python 
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
docker run -it --rm -v $(pwd)/code:/home/python --name python-container python
or
docker run -it --rm --name python-container  python
```

- **python-container**: name of the container
- **python**: name of the image

##### You have to delete container, if you want to run it again

```
docker rm -f docker-container
```

##### Running the VCF preprocessor

```
docker run -it --rm --name python-container python /pharmcat/PharmCAT_VCF_Preprocess.py --input_vcf data/sample.vcf
```

##### Create container and keep it alive. Then, login

```
docker run -d -t --name python-container python
or
docker run -d -t -v $(pwd)/code:/home/python --name python-container python

docker exec -it python-container /bin/bash
```

##### Running PharmCAT

```
docker run -it --rm -v $(pwd)/data:/pharmcat/data --name python-container python ./PharmCAT_VCF_Preprocess.py --input_vcf data/sample.vcf

docker run -it --rm -v $(pwd)/data:/pharmcat/data --name python-container python ./pharmcat -vcf data/pharmcat_ready_vcf.SAMPLE1.vcf

```
