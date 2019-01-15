FROM ubuntu:bionic
LABEL maintainer wangkexiong<wangkexiong@gmail.com>

ARG GITBOOK_VER=3.2.3

RUN apt update -y && \
    apt install -y ca-certificates wget xdg-utils && \
    apt install -y nodejs npm && \
    npm install gitbook-cli -g && \
    npm install svgexport -g && \
    gitbook fetch ${GITBOOK_VER} && \
    wget --no-check-certificate -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()" && \
    apt purge -y && \
    apt autoremove -y && \
    rm -rf /root/.npm /root/.wget-hsts && \
    rm -rf /var/cache/* /var/log/* && \
    rm -rf /tmp/*

VOLUME /gitbook
WORKDIR /gitbook

EXPOSE 4000

CMD cp -r /gitbook /root/. && cd /root/gitbook/ && gitbook install && gitbook pdf && cp *.pdf /gitbook/.
