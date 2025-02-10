<script>
import { ref, watch, onMounted, onBeforeUnmount } from "vue";
import { getMessagesPaginated } from '../services/api';
// import io from "socket.io-client";

export default {
  props: {
    chatId: Number,
  },
  setup(props) {
    // const socket = io(process.env.VUE_APP_API_URL);
    const messages = ref([]);
    const currentUserId = ref('');
    const newMessage = ref("");
    const isLoading = ref(true);


    const loadMessages = async () => {
      isLoading.value = true;

      if (props.chatId) {
        const userId = localStorage.getItem('userIdChatVollDevJr');
        const oldMessages = await getMessagesPaginated(userId, props.chatId);

        console.log('user id do storage: ', typeof userId)

        currentUserId.value = userId;  
        messages.value = oldMessages;
      }

      isLoading.value = false;
    };

    const sendMessage = () => {
      if (newMessage.value) {
        // const token = localStorage.getItem('tokenChatVollDevJr');
        // const socketData = { 
        //   message: newMessage.value,
        //   token,
        //   chatId: props.chatId
        // }
        // socket.emit("chatMessage", socketData);
        newMessage.value = "";
      }
    };

    // socket.on("chatMessage", (message) => {
    //   console.log('socket: ', message)
    //   if (message.chat.id !== props.chatId) return;
    //   messages.value.push(message);
    // });

    watch(() => props.chatId, (newValue) => {
      loadMessages(newValue);
    });

    onMounted(() => {
      loadMessages(props.chatId);
    });

    onBeforeUnmount(() => {
      // socket.disconnect();
    });

    return {
      messages,
      newMessage,
      currentUserId,
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
          :class="`message ${ message.user_id === currentUserId ? 'author-message' : 'received-message' }`"
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
