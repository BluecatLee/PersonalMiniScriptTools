#!/bin/bash
nohup /usr/local/bin/consul agent -server -bootstrap-expect=1 -data-dir=/usr/local/consuldata -client=0.0.0.0 -ui > consul.log &
