# PhoenixIm

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


## 使用方法

 得益于强大的phoenix，服务器实现一个im服务器非常简单，设计原则，所有的客户端都通个同个topic互通（类似于聊天室的房间），如果不改服务器的实现，客户端只需实现对new_msg 消息的处理就行了，
 如果要实现单对单的聊天，只需保证room id的唯一，这些可由具体的业务实现，
 另外有两个http接口，可以对指定用户发，和指定的房间发送消息
 
### 对指定的用户发送消息

#### Request
**请求url**
- `http://127.0.0.1:4000/api/send/user`  

**Request Method**
- POST

**参数**

|参数名|是否必需|类型|说明|
|:----|:----|:----|----|
|username|是|string|无|
|data|是|json|无|

#### Response
```apacheconfig
{
    "msg": "",
    "data": {},
    "code": 200  //200表示成功，其他表示失败，
}
```


### 对指定的房间发送消息
#### Request
**请求url**
- `http://127.0.0.1:4000/api/send/room`  

**Request Method**
- POST

**参数**

|参数名|是否必需|类型|说明|
|:----|:----|:----|----|
|room|是|string|客户端在链接的时候，是默认加上了room前缀的，所有房间号都是以room:开头的字符串|
|data|是|json|无|

#### Response
```apacheconfig
{
    "msg": "",
    "data": {},
    "code": 200  //200表示成功，其他表示失败，
}
```

### 获取im socket管理表的信息
对单个用户发送消息的实现，使用了ets存储用户的socket
#### Request
**请求url**
- `http://127.0.0.1:4000/api/socket/container/info`  

**Request Method**
- GET

**参数**

无

#### Response
```apacheconfig
{
    "msg": "",
    "data": {},
    "code": 200  //200表示成功，其他表示失败，
}

example

{
    "msg": "",
    "data": {
        "write_concurrency": true,
        "type": "set",
        "size": 2,
        "read_concurrency": true,
        "protection": "protected",
        "owner": "#PID<0.344.0>",
        "node": "nonode@nohost",
        "named_table": "true",
        "name": "users_table",
        "memory": 1500,
        "keypos": 1,
        "heir": "none",
        "compressed": false
    },
    "code": 200
}
```

### 获取连接的所有socket信息
#### Request
**请求url**
- `http://127.0.0.1:4000/api/socket/all`  

**Request Method**
- GET

**参数**

无

#### Response
```apacheconfig
{
    "msg": "",
    "data": {
        "sockets": [
            {
                "vsn": "2.0.0",
                "transport_pid": "#PID<0.926.0>",
                "transport": "Elixir.Phoenix.Transports.WebSocket",
                "topic": "room:999",
                "serializer": "Elixir.Phoenix.Transports.V2.WebSocketSerializer",
                "pubsub_server": "Elixir.PhoenixIm.PubSub",
                "join_ref": "15",
                "handler": "Elixir.PhoenixIm.UserSocket",
                "channel_pid": "#PID<0.943.0>",
                "channel": "Elixir.PhoenixIm.RoomChannel",
                "assigns": {
                    "username": "test1",
                    "room_id": "999" //真实房间是 "room:998",所以向一个房间发送消息时的room为"room:998"
                }
            },
            {
                "vsn": "2.0.0",
                "transport_pid": "#PID<0.780.0>",
                "transport": "Elixir.Phoenix.Transports.WebSocket",
                "topic": "room:998",
                "serializer": "Elixir.Phoenix.Transports.V2.WebSocketSerializer",
                "pubsub_server": "Elixir.PhoenixIm.PubSub",
                "join_ref": "59",
                "handler": "Elixir.PhoenixIm.UserSocket",
                "channel_pid": "#PID<0.945.0>",
                "channel": "Elixir.PhoenixIm.RoomChannel",
                "assigns": {
                    "username": "test2",
                    "room_id": "998"
                }
            }
        ]
    },
    "code": 200
}
```

### 根据username 获取指定socket
#### Request
**请求url**
- `http://127.0.0.1:4000/api/socket/get?username={username}`  

**Request Method**
- GET


#### Response

```apacheconfig
{
    "msg": "",
    "data": {
        "vsn": "2.0.0",
        "transport_pid": "#PID<0.926.0>",
        "transport": "Elixir.Phoenix.Transports.WebSocket",
        "topic": "room:999",
        "serializer": "Elixir.Phoenix.Transports.V2.WebSocketSerializer",
        "pubsub_server": "Elixir.PhoenixIm.PubSub",
        "join_ref": "15",
        "handler": "Elixir.PhoenixIm.UserSocket",
        "channel_pid": "#PID<0.943.0>",
        "channel": "Elixir.PhoenixIm.RoomChannel",
        "assigns": {
            "username": "test1",
            "room_id": "999"
        }
    },
    "code": 200
}
```

### 客户端js
具体可参考，phoenix的js文档
示例中的js，都在web/static/js  目录下
```apacheconfig

let IM = {
    init(socket) {
        socket.connect()
        let usernameEle = document.getElementById("username")
        let roomEle = document.getElementById("room")
        let connEle = document.getElementById("btn_conn")
        let msgContainer = document.getElementById("msg_container")
        connEle.addEventListener("click", e=> {
            let username = usernameEle.value
            let roomId = roomEle.value
            if (username.length == 0 || roomId.length == 0) {
                alert("please input username or room id")
                return
            }
            if (username.indexOf(" ") != -1 || roomId.indexOf(" ") != -1) {
                alert("username or roomID can not contain spaces")
                return
            }
            console.log("conn...")
            console.log("username:" + username)
            console.log("roomId:" + roomId)
            let channel = socket.channel("room:"+roomId, {"username" : username})
            channel.join().receive("ok", resp => console.log("joined this room:" + roomId, resp))
                .receive("error", (resp) => {
                    alert("join failed")
                    console.log("join failed:", resp)
                })
            channel.on("ping", ({}))
            channel.on("new_msg", (resp) => {
                console.log("resp")
                this.receiveMsg(resp, msgContainer)
            })
            this.sendMsg(channel)
        })
    },
    receiveMsg(msg, container) {
        let div = document.createElement("div")
        div.innerHTML = `
        <label>${msg.username}:</label>
        <label>${msg.data}</label><br/>
        `
        container.appendChild(div)
        container.scrollTop = container.scrollHeight

    },
    sendMsg(channel) {
        let msgSubmit = document.getElementById("msg_submit")
        let msgInput = document.getElementById("msg_input")
        msgSubmit.addEventListener("click", e => {
            let msgValue = msgInput.value
            if (msgValue.length == 0) {
                alert("please input msg")
                return
            }
            channel.push("new_msg", msgValue).receive("error", e => console.log(e))
            msgInput.value = ""
        })

    }
}

export default IM
```

### RUN
```apacheconfig
git clone https://github.com/728443778/phoenix_im.git
cd phoenix_im
mix deps.get
npm install
当遇到npm install出错时
mkdir assets
cd assets
npm install 
我是这样解决的

iex -S mix phx.server
```