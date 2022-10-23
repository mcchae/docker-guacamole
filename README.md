# [Apache Guacamole](https://guacamole.apache.org) on docker

`과카몰레` 또는 `과카몰리`라고 발음되는 [Guacamole](https://ko.wikipedia.org/wiki/과카몰레) 는 멕시코 요리의 소스라 합니다. 아마 첫 개발을 시작한 분이 스페니시를 원어로 하시는 분이 아닐까 싶네요.

아파치 그룹의 프로젝트인데 대문에 나와 있는 내용을 보면,

`Apache Guacamole`는 클라이언트가 따로 필요없는 원격 데스크탑 게이트웨이 입니다. VNC, RDP 그리고 SSH와 같은 표준 프로토콜을 지원합니다.

VNC, RDP 그리고 SSH가 돌고있는 시스템에는 어떠한 에이전트 등을 설치하지 않기 때문에 `clientless` 라고 부릅니다.

`HTML5` 기술 덕분에 웹브라우저만 있으면 여러 시스템들의 데스크탑을 한 곳에서 모두 관리하고 연결하여 사용할 수 있습니다.

## 작업 환경

ESXi 서버 안에 `Photon OS 4` 리눅스를 설치하고 여기에 docker 환경에서 테스트 했습니다. Docker 가 동작하는 모든 시스템에서 거의 잘 실행될 것으로 보입니다.

## 작업 내용

다음과 같은 docker-compose.yaml 을 작성했습니다.

``` yaml
version: '3'
services:

  guacdb:
    image: mysql
    container_name: guacdb
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    volumes:
      - /root/guacdb:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my12#
      MYSQL_DATABASE: guac
    cap_add:
      - SYS_NICE

  guacd:
    image: guacamole/guacd
    container_name: guacd
    restart: always

  guacamole:
    image: guacamole/guacamole
    container_name: guacamole
    restart: always
    ports:
      - 18080:8080
    links:
      - guacd
      - guacdb
    environment:
      WEBAPP_CONTEXT: ROOT
      GUACD_HOSTNAME: guacd
      MYSQL_HOSTNAME: guacdb
      MYSQL_DATABASE: guac
      MYSQL_USER: root
      MYSQL_PASSWORD: my12#
```

> * `WEBAPP_CONTEXT`를 `ROOT`로 지정하면 기본 `http://host/quacamole` 가 `http://host` 로 되어 쉽게 NginX 등에서 이용할 수 있습니다.

또한 다음과 같은 세 가지 쉘 스크립트를 만들었습니다.

* start.sh : docker-compose 시작
* stop.sh : docker-compose 종료
* initdb.sh : 최초 docker-compose 시작 시 데이터베이스 초기화

## 동작 방법

해당 컨테이너 세트를 돌리기 위하여 

``` bash
./start.sh
```
를 실행합니다.

최초 실행했을 경우, mysql 에 해당 테이블과 자료를 초기화 하기 위하여

``` bash
./initdb.sh
```
를 실행합니다. 이후 내리고 올리고 할 때 부터는 필요 없습니다. 모든 데이터는 guacdb 서비스에 마운트되어 있는 /root/guacdb 에 mysql 데이터가 존재합니다.

해당 서비스를 내리려면,

``` bash
./stop.sh
```
을 실행합니다.


어느 분께는 도움이 되셨기를 ..
