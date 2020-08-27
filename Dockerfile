# 基础镜像
FROM golang:1.15.0

ENV GOPROXY=https://goproxy.cn,direct
ENV GO111MODULE="on"

WORKDIR /go/src/app

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o webserver

# 构建生产镜像，使用最小的linux镜像，只有5M
FROM alpine:latest

WORKDIR /root/

# 从编译阶段复制文件
# 这里使用了阶段索引值，第一个阶段从0开始，如果使用阶段别名则需要写成 COPY --from=build_stage /go/src/app/webserver /
COPY --from=0 /go/src/app/webserver .

# 容器向外提供服务的暴露端口
EXPOSE 9999

# 启动服务
ENTRYPOINT ["./webserver"]