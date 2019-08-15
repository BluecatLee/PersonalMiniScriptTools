#!/usr/bin/env bash

PARAM=$1

CURRENT_DIR=`pwd`
OLD_GO_PATH="$GOPATH"  #例如: /usr/local/go
OLD_GO_BIN="$GOBIN"    #例如: /usr/local/go/bin

export GOPATH="$CURRENT_DIR" 
export GOBIN="$CURRENT_DIR/bin"

#指定并整理当前的源码路径
gofmt -w src

go install $PARAM

#echo "测试"

export GOPATH="$OLD_GO_PATH"
export GOBIN="$OLD_GO_BIN"