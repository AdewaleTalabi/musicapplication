#!/usr/bin/env sh

echo 'The following "npm" command runs Node.js application'

set -x
npm start &
sleep 1
echo $! > .pidfile
set +x

echo 'Now you can'
echo 'Visit http://ServerIp:3000 to see your Node.js application'
