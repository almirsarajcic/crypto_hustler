#!/bin/sh

set -e
set -x

cd /opt/build

MIX_ENV=prod mix do clean, compile, release

echo "Exporting release tarball..."
cd /opt/build/_build/prod/rel/$APP/
tar -czvf /opt/build/releases/$APP.tar.gz .
echo "Success!"
