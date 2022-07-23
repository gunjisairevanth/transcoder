FROM ubuntu:20.04

RUN apt-get update

RUN apt-get -y install curl

RUN apt-get install ffmpeg -y
# RUN apt-get install apt-utils -y
RUN apt-get install zip -y

RUN mkdir /src

WORKDIR /src

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install



ADD bash.sh /src/bash.sh
RUN chmod +x /src/bash.sh

CMD ["/src/bash.sh"]

