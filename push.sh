#!/bin/bash
set -ev
export TZ='Asia/Shanghai'

git add .
git commit -S -m "Update: `date +"%Y-%m-%d %H:%M:%S"`"
git push origin source:source

