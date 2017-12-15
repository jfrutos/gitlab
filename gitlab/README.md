Gitlab custom instalation.


RUNNER: https://hub.docker.com/r/sameersbn/gitlab-ci-multi-runner/#trusting-ssl-server-certificates


En este proyecto hemos montado un gitlab con las siguientes características:
    - Gitlab completo (repositorio + CI/CD + runner)
    - BBDD postgresql.
    - redis como key-value store.
    - El registro de gitlab-runner es manual de momento.

En este entorno se ha creado un repositorio, se ha subido una applicación
(aplicación simple con node.js) y se ha pasado los test y creado una imagen
docker de la aplicación.

Artículo base para gitlab: https://github.com/sameersbn/docker-gitlab

Artículo para aplicación: https://blog.lwolf.org/post/how-to-build-tiny-golang-docker-images-with-gitlab-ci/


Para el tema de registro y dokcers: https://docs.gitlab.com/ce/ci/docker/using_docker_images.html#define-an-image-from-a-private-docker-registry

Artículo base para registro: https://blog.irontec.com/montando-un-docker-registry-como-dios-manda/
https://github.com/sameersbn/docker-gitlab/blob/master/docs/container_registry.md

URL apoyo:
https://stackoverflow.com/questions/47253978/auto-register-gitlab-runner
https://blog.lwolf.org/post/fully-automated-gitlab-installation-on-kubernetes-including-runner-and-registry/#runner
https://gitlab.com/gitlab-examples

Importante para variables de entorno de gitlab:
https://github.com/sameersbn/docker-gitlab/blob/master/assets/runtime/env-defaults

Importante:  
  - El runner es capaz de levantar dockers con una imagen para compilar o hacer
  lo que sea.
  - Hay problemas de que el contenedor de que levanta el runner acceda a la red
  interna del docker-compose, aunque no debería haber problemas si se accede por
  la ip del host.
  - Se crea un certificado con las instrucciones:
      - openssl genrsa 2048 > wildcard.key
      - openssl req -new -x509 -nodes -sha1 -days 3650 -key wildcard.key > wildcard.crt
  - En el entorno de ejemplo lo hemos creado como "*.shl.com".
  - Poner las URL bajo el dominio shl.com y poner dicha entrada en /etc/host para resolver.
  - Para las claves se pueden genera con "pwgen -Bsv1 64"
