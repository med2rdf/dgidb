FROM ruby:2.4

ENV RELEASE v0.1.0-rc1

ENV LANG en_US.utf8
ENV RUBYOPT -EUTF-8

ENV GOSU_VERSION 1.10
ENV PG_VERSION 9.6

ENV DGIDB_SRC /usr/local/src/dgidb
ENV PGDATA /var/lib/postgresql/data
ENV PATH $PATH:/usr/lib/postgresql/"$PG_VERSION"/bin/

RUN groupadd -r postgres --gid=999 && \
    useradd -r -g postgres --uid=999 postgres

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates locales wget && \
    # install gosu
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    # install PostgreSQL
    echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main $PG_VERSION" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && apt-get install -y postgresql-"$PG_VERSION" && \
    # set locale
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    # clean
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p "$PGDATA" /var/run/postgresql && \
    chown -R postgres:postgres "$PGDATA" /var/run/postgresql && \
    chmod 700 "$PGDATA" && \
    chmod 775 /var/run/postgresql

RUN wget -O dgidb.tar.gz https://github.com/med2rdf/dgidb/archive/"$RELEASE".tar.gz && \
    mkdir -p /usr/local/src/dgidb && \
    tar xf dgidb.tar.gz --strip-components=1 -C "$DGIDB_SRC" && \
    rm -f dgidb.tar.gz && \
    cd "$DGIDB_SRC" && \
    cp conf/database.yaml.template conf/database.yaml && \
    bundle install && \
    rake install

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh

VOLUME ["$PGDATA", "/work"]

WORKDIR "/work"

EXPOSE 5432

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["dgidb", "--help"]
