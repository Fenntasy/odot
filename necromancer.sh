#!/bin/sh
# see https://hexdocs.pm/elixir/Port.html#module-zombie-processes
exec $1 &
pid=$!
while read line ; do
  :
done
kill -KILL $pid
