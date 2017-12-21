#!/bin/bash

cd /var/lib/dgidb-rdf

bundle install

[ ! -e ./conf/database.yaml ] && cp ./conf/database.yaml{.template,}

rake db:create
rake db:migrate
rake db:seed

./bin/dgidb convert
