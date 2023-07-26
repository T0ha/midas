#!/bin/sh

echo "Test"
while true; do
  printf 'HTTP/1.1 200 OK\n\n%s' "pong\n\n" | nc -l 5000
done
