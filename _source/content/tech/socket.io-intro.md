---
title: "socket.io 介绍"
date: 2020-01-23T17:22:49+08:00
draft: true
---

## 一、什么是 socket.io

socket.io 是一个基于事件驱动的为实时应用提供跨平台通信的库。socket.io 抹平了不同浏览器之间的差异，可以根据浏览器自动选择合适双向通信协议。
 
### 1.1 socket.io 特点

1. 可靠性 - 即使在以下场景中也可以建立连接：（它依赖在Engine.IO，它首先建立一个长轮询连接，然后尝试升级到更好的传输通道，这些传输在另外一边被tested，比如websocket。）
    - 代理和负载均衡器
    - 个人防火墙和防病毒软件
2. 支持自动重连
    - 除非主动断开连接，否则，断开客户端会无限重试连接，直到服务器再次可以可用。
3. 断连检测
    - 底层(Engine.IO)实现实现心跳机制，允许服务器和客户端保持连接，直到一方停止响应。(TODO)
4. 支持二进制
    - 浏览器中的 ArrayBuffer(数组缓存) 和 Blob(二进制大文件)
    - Node.js 中的 ArrayBuffer 和 Buffer 缓存
5. 支持多路复用
    - Socket.io 允许创建多个 Namespaces (命名空间)，这些命名空间将作为单独的消息通信通道，也可以共享相同的底层连接。
6. 支持房间
    - 在每个 namespace 中，可以建立频道( Room )，客户端可以可以加入或者离开任意频道。也可以广播消息到任何指定的房间，可以发送消息到所有加入房间的客户端。


### 1.2 示例

#### 服务端

    const server = require('http').createServer();
    
    const io = require('socket.io')(server, {
      path: '/test',
      serveClient: false,
      // below are engine.IO options
      pingInterval: 10000,
      pingTimeout: 5000,
      cookie: false
    });
    
    server.listen(3000);
    
#### 客户端
    
    import io from 'socket.io-client';
    
    const socket = io('http://localhost');
    
    socket.on('connect', () => {
      console.log(socket.disconnected); // false
    });
    
    socket.on('disconnect', () => {
      socket.open();
    });
    
    socket.emit('hello', 'world');
    
    socket.on('myevent', () => {
    });
    
## 二、socket.io 应用场景

1. 在线聊天
2. 实时数据通信 & 实时消息通道
3. 文档协同编辑
4. ...


## 三、socket.io 架构介绍

socket.io 主要由以下几个部分构成：

- [socket.io](https://github.com/socketio/socket.io)
- [socket.io-client](https://github.com/socketio/socket.io-client)
- [socket.io-parser](https://github.com/socketio/socket.io-parser)
- [socket.io-adapter](https://github.com/socketio/socket.io-adapter)
- [socket.io-redis](https://github.com/socketio/socket.io-redis)
- [engine.io](https://github.com/socketio/engine.io)
- [engine.io-client](https://github.com/socketio/engine.io-client)
- [engine.io-parser](https://github.com/socketio/engine.io-parser)

下图是各个部分的依赖关系图：

<img src="/image/tech/socket.io-dependencies.jpg" alt="socket.io 依赖关系图" width="1024" />

### 3.1 engine.io

engine.io 是为 socket.io 提供跨浏览器/跨设备的双向通信的底层库，所有建立连接、消息通信都是由这一层来做。engine.io 使用了 Websocket 和 XHR 方式封装了一套协议，在低版本的浏览器中，不支持Websocket，降级为长轮询(polling)方式。

engine.io 支持的连接方式：
- polling: XHR / JSONP polling
- websocket

### 3.2 engine.io-client

engine.io-client 是 socket.io-client 的核心，所有的连接建立、传输方式选择，都在这一层来做。

### 3.3 engine.io-parser

engine.io-parser 是 [engine.io-protocol](https://github.com/socketio/engine.io-protocol) 的实现，为 engine.io packet 提供编码 & 解码功能。

当我们要将消息内容传到前端，或者将消息从前端传到服务端口，都会先使用 engine.io-parser 将消息内容 `encode`，然后收到的一方进行 `decode`。( 使用 encode 目的主要是为了减小传输成本 )

### 3.4 socket.io-parser

socket.io-parser 功能和 engine.io-parser 功能类似，是 [ socket.io-protocol](https://github.com/socketio/socket.io-parser) 的实现，为 socket.io packet 提供编码解码的功能。

### 3.5 socket.io-adapter

默认的 socket.io 内存适配器，可以进行扩展。

### 3.6 socket.io

socket.io 服务端。基于 engine.io 的上层框架，带来了一些语法上的优势，它还引入了两个新的概念，即 root 和 namespace。

### 3.7 socket.io-client

socket.io 的客户端，它依赖于 engine.io-client ，用来处理客户端连接和收发消息处理。

## 四、相关文档

* [官方文档](https://socket.io/docs/)
* [egg-socket.io](https://eggjs.org/zh-cn/tutorials/socketio.html)

