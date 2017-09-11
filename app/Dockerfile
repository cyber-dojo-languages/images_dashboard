FROM  cyberdojofoundation/gcc-alpine:6.3.0
LABEL maintainer=jon@jaggersoft.com

RUN apk update \
 && apk upgrade

RUN apk add ruby-dev ruby libffi-dev curl bash \
    && gem install bundler --no-rdoc --no-ri

COPY Gemfile .
RUN bundle install

COPY . /app
WORKDIR /app

ARG PORT
EXPOSE ${PORT}
ENV PORT=${PORT}

CMD [ "./up.sh" ]
