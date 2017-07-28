![docker hub](https://img.shields.io/docker/pulls/rabaco/nginx-php-fpm.svg?style=flat)
![docker hub](https://img.shields.io/docker/stars/rabaco/nginx-php-fpm.svg?style=flat)
![docker hub](https://img.shields.io/docker/automated/rabaco/nginx-php-fpm.svg?style=flat)
![docker hub](https://img.shields.io/docker/build/rabaco/nginx-php-fpm.svg?style=flat)
[![CircleCI](https://circleci.com/gh/rafaelrabaco/nginx-php-fpm.svg?style=shield)](https://circleci.com/gh/rafaelrabaco/nginx-php-fpm)


### Instalação

Para utilizar é necessário rodar o seguinte comando baixar a imagem do Docker Hub:
```
docker pull rabaco/nginx-php-fpm:latest
```

### Utilização
Para executar o container
```
sudo docker run -d -p 80:80 rabaco/nginx-php-fpm
```

