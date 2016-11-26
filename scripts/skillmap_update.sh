#!/bin/bash

set -eu

gv2map share/my-skills.gv images/my-skills.svg
gv2map share/books.gv images/books.svg
gv2map share/movies.gv images/movies.svg
gv2map share/games.gv images/games.svg
gv2map share/music.gv images/music.svg

[ "$#" != '0' ] || git add images/*.svg
