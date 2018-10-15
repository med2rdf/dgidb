FROM ruby:2.4

ADD . /dgidb/

WORKDIR /dgidb

ADD conf/database.yaml.template conf/database.yaml

RUN rm -rf .bundle && \
  bundle install && \
  rake install

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dgidb", "--help"]
