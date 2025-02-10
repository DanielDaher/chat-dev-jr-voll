import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import axios from 'axios';
import cors from 'cors';
import 'dotenv/config';

const app = express();
app.use(cors()); 

const server = createServer(app);
const io = new Server(server, {
  cors: {
      origin: [process.env.FRONTEND_URL, `${process.env.FRONTEND_URL}/dashboard`],
      methods: ['GET', 'POST']
  }
});

io.on('connection', (socket) => {
  console.log('Novo usuário conectado:', socket.id);

  socket.on('message', async (data) => {
    console.log('Mensagem recebida:', data);

    try {
      const response = await axios.post('http://localhost:3000/messages', { 
          text: data.text,
          user_id: data.userId,
          send_to_id: data.sendToId,
      }, {
        headers: {
          'Authorization': `Bearer ${data.token}`,
          'Content-Type': 'application/json',
        },
      });

      console.log('Rails respondeu:', response);

      io.emit('message', response.data);
    } catch (error) {
      console.error('Erro ao enviar para Rails:', error.message);
    }
  });

  socket.on('disconnect', () => {
      console.log('Usuário desconectado:', socket.id);
  });
});

const PORT = 3001;
server.listen(PORT, () => {
  console.log(`Servidor WebSocket rodando em http://localhost:${PORT}`);
});
