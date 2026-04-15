#!/usr/bin/env bash

cd "$HOME/work/psicostat/psicostat-teaching"
git pull
#manage_env set .Renviron QUARTO_PROJECT_RENDER_ALL 1
quarto render
git add .
git commit --no-verify -m "updating"
git push
