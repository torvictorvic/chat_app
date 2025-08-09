import { Socket, Presence } from "phoenix"

const $ = (s) => document.querySelector(s)

const loginForm = $("#login-form")
const chat = $("#chat")
const roomLabel = $("#room_label")
const msgForm = $("#msg-form")
const msgInput = $("#msg")
const messages = $("#messages")
const online = $("#online")

let channel = null
let pres = null

loginForm.addEventListener("submit", (e) => {
  e.preventDefault()
  const userName = $("#user_name").value.trim()
  const roomName = ($("#room_name").value.trim() || "lobby")

  if (!userName) return alert("Enter a name")

  const socket = new Socket("/socket", { params: { user_name: userName } })
  socket.connect()

  channel = socket.channel(`room:${roomName}`)
  channel.join()
    .receive("ok", ({ messages: recent }) => {
      loginForm.classList.add("hidden")
      chat.classList.remove("hidden")
      roomLabel.textContent = roomName
      messages.innerHTML = ""
      for (const m of recent) addMsg(m.user, m.body, m.at)
      channel.push("presence_subscribe", {})
      setupPresence()
    })
    .receive("error", (resp) => alert(`Join error: ${JSON.stringify(resp)}`))

  channel.on("message:created", ({ user, body, at }) => addMsg(user, body, at))
})

msgForm.addEventListener("submit", (e) => {
  e.preventDefault()
  const body = msgInput.value.trim()
  if (!body) return
  channel.push("message:new", { body })
  msgInput.value = ""
})

function addMsg(user, body, at) {
  const li = document.createElement("li")
  const time = typeof at === "string" ? at : new Date(at).toISOString()
  li.textContent = `[${time}] ${user}: ${body}`
  messages.appendChild(li)
  li.scrollIntoView({ behavior: "smooth", block: "end" })
}

function setupPresence() {
  pres = new Presence(channel)
  const render = (list) => {
    online.innerHTML = ""
    list.forEach((u) => {
      const li = document.createElement("li")
      li.textContent = u
      online.appendChild(li)
    })
  }
  pres.onSync(() => render(pres.list((k) => k).sort()))
}
