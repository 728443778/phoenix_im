
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