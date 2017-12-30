#FROM  cyberdojofoundation/gcc-alpine:6.3.0
FROM  alpine:latest
LABEL maintainer=jon@jaggersoft.com

RUN apk update \
 && apk upgrade

RUN apk add \
  bash \
  curl \
  libffi-dev \
  ruby-dev \
  ruby-bigdecimal \
  ruby-bundler

COPY Gemfile .

RUN apk --update --no-cache add --virtual build-dependencies build-base \
 && bundle config --global silence_root_warning 1 \
 && bundle install \
 && apk del build-dependencies build-base \
 && rm -vrf /var/cache/apk/*

COPY . /app
WORKDIR /app

ARG PORT
EXPOSE ${PORT}
ENV PORT=${PORT}

CMD [ "./up.sh" ]
