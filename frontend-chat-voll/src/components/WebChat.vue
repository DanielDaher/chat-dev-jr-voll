<script>
import { ref, watch, onMounted, onBeforeUnmount, computed } from "vue";
import { getMessagesPaginated } from '../services/api';
import io from "socket.io-client";

export default {
  props: {
    chatId: Number,
    myselfId: Number,
    currentToken: String,
  },
  setup(props) {
    const socket = io(process.env.VUE_APP_WEBSOCKET_URL);
    const messages = ref([]);
    const newMessage = ref("");
    const isLoading = ref(true);

    const myselfId = computed(() => props.myselfId);
    const authToken = computed(() => props.currentToken); 


    const loadMessages = async () => {
      isLoading.value = true;

      if (props.chatId) {
        const oldMessages = await getMessagesPaginated(myselfId.value, props.chatId, authToken.value);

        messages.value = oldMessages;
      }

      isLoading.value = false;
    };

    const sendMessage = () => {
      if (newMessage.value) {
        const token = authToken.value;
        const socketData = { 
          text: newMessage.value,
          token,
          userId: myselfId.value,
          sendToId: props.chatId
        }
        socket.emit("message", socketData);
        newMessage.value = "";
      }
    };

    socket.on("message", (message) => {
      const IreceivedAMessageOnThisChat = message.send_to_id === myselfId.value && message.user_id === props.chatId;
      const ISendAMessage = message.user_id === myselfId.value && message.send_to_id === props.chatId;
      if (IreceivedAMessageOnThisChat || ISendAMessage) {
        messages.value.push(message);
      }
    });

    watch(() => props.chatId, (newValue) => {
      loadMessages(newValue);
    });

    onMounted(() => {
      loadMessages(props.chatId);
    });

    onBeforeUnmount(() => {
      socket.disconnect();
    });

    return {
      messages,
      newMessage,
      isLoading,
      sendMessage,
      loadMessages,
    };
  },
};
</script>

<template>
  <main class="box is-responsive">
    <p v-if="!chatId" class="title is-6">Selecione uma conversa</p>

    <div v-else class="chat">

      <div v-if="!isLoading" class="chat-messages">
        <div
          v-for="(message, index) in messages"
          :key="index" 
          :class="`message ${ message.user_id === myselfId ? 'author-message' : 'received-message' }`"
        >
            {{ message.text }}
        </div>
      </div>
      <div v-else class="chat-messages"> Carregando mensagens... </div>

    </div>

    <input
      v-if="chatId" 
      v-model="newMessage" 
      @keyup.enter="sendMessage"
      class="input is-hovered"
      type="text"
      placeholder="Digite sua mensagem e aperte enter..." 
    />
    <button v-if="chatId" @click="sendMessage" class="button is-info">Enviar</button>
  </main>
</template>

<style scoped>
main {
  margin: 35px;
  width: 60vw;
}
.chat {
  max-height: 85vh;
}

.chat-messages {
  height: 75vh;
  overflow-y: scroll;
  display: flex;
  flex-direction: column;
}

.message {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 5px;
  width: 300px;
  min-height: 50px;
  overflow-x: auto;
  border-radius: 10px;
}

.received-message {
  align-self: flex-start;
  background-color: rgb(118,106,200);
  color: white;
}

.author-message {
  align-self: flex-end;
  margin-right: 5px;
}

button {
  margin: 10px;
}

</style>
