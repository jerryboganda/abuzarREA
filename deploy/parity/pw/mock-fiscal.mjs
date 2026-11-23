import net from 'node:net'
import { appendFileSync } from 'node:fs'

const log = 'C:/Projects/Abuzar/deploy/parity/mock-fiscal.log'
const server = net.createServer((socket) => {
  socket.on('data', (buf) => {
    appendFileSync(log, `recv ${JSON.stringify(buf.toString('utf8'))}\n`)
    // The desktop service answers with a fiscal receipt string. The client does
    // not parse it; the service itself writes the invoice number to the DB.
    socket.write('OK')
  })
  socket.on('error', () => {})
})
server.listen(9111, '127.0.0.1', () => appendFileSync(log, 'listening 127.0.0.1:9111\n'))
