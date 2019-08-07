::windows环境下编译成linux可用的二进制文件

set GOARCH=amd64

set GOOS=linux

go build -o {指定编译后的可执行文件的名字} main.go

set GOOS=windows
