<script>
import { ref, watch, onMounted, onBeforeUnmount, computed, nextTick } from "vue";
import { getMessagesPaginated, uploadFile } from '../services/api';
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
    const messageContainer = ref(null);
    const messagesCurrentPage = ref(1);
    const selectedFile = ref(null);

    const myselfId = computed(() => props.myselfId);
    const authToken = computed(() => props.currentToken);
    
    const resetMessages = () => {
      messages.value = [];
      messagesCurrentPage.value = 1;
    }
    
    const loadMoreMessages = async () => {
      const shouldScrollToBottom = false;

      messagesCurrentPage.value = messagesCurrentPage.value + 1;
      await loadMessages(shouldScrollToBottom);
    }

    const loadMessages = async (shouldScrollToBottom=true) => {
      isLoading.value = true;

      if (props.chatId) {
        const oldMessages = await getMessagesPaginated(
          myselfId.value,
          props.chatId,
          authToken.value,
          messagesCurrentPage.value
        );

        messages.value.unshift(...oldMessages);
      }

      isLoading.value = false;
      if (shouldScrollToBottom) {
        nextTick(() => {
          scrollToBottom();
        });
      }
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
      const IreceivedAMessageOnThisChat = (
        message.send_to_id === myselfId.value &&
        message.user_id === props.chatId
      );

      const ISendAMessage = (
        message.user_id === myselfId.value &&
        message.send_to_id === props.chatId
      );

      if (IreceivedAMessageOnThisChat || ISendAMessage) {
        messages.value.push(message);

        nextTick(() => {
          scrollToBottom();
        });
      }
    });

    const scrollToBottom = () => {
      if (messageContainer.value) {
        messageContainer.value.scrollTop = messageContainer.value.scrollHeight;
      }
    };

    // eslint-disable-next-line no-unused-vars
    watch(() => props.chatId, (newValue) => {
      console.log('waaaaatch');
      resetMessages();
      loadMessages();
      resetSelectedFile();
    });

    onMounted(() => {
      loadMessages();
    });

    onBeforeUnmount(() => {
      socket.disconnect();
    });

    const resetSelectedFile = () => {
      selectedFile.value = null;
    }

    const setFileUpload = (event) => {
      selectedFile.value = event.target.files[0];
    };

    const uploadCurrentFile = async () => {
      if (!selectedFile.value) return;

      const formData = new FormData();
      formData.append("file", selectedFile.value);

      const response = await uploadFile(myselfId.value, props.chatId, authToken.value, formData);

      console.log('response:   ', response)

      const socketData = { 
        text: response.url,
        token: authToken.value,
        userId: myselfId.value,
        sendToId: props.chatId,
        isMedia: true,
      }
        
      socket.emit("message", socketData);

      resetSelectedFile();
    };

    return {
      messages,
      newMessage,
      isLoading,
      messagesCurrentPage,
      sendMessage,
      loadMessages,
      resetMessages,
      loadMoreMessages,
      messageContainer,
      selectedFile,
      setFileUpload,
      uploadCurrentFile,
    };
  },
};
</script>

<template>
  <main class="box is-responsive">
    <p v-if="!chatId" class="title is-6">Selecione uma conversa</p>

    <div v-else class="chat">

      <button
        class="button"
        @click="loadMoreMessages"
        v-if="messages.length >= 30"
      >
          Buscar mais mensagens
      </button>
      <div v-if="!isLoading" class="chat-messages" ref="messageContainer">
        <div
          v-for="(message, index) in messages"
          :key="index" 
          :class="`message ${ message.user_id === myselfId ? 'author-message' : 'received-message' }`"
        >
          <template v-if="message.is_media">
            <a :href="message.text" target="_blank">Abrir mídia</a>
          </template>
          <template v-else>
            {{ message.text }}
          </template>
        </div>
      </div>
      <div v-else class="chat-messages"> Carregando mensagens... </div>

    </div>

    <div class="send-container">
      <div class="file is-primary is-small has-name">
        <label class="file-label">
          <input class="file-input" type="file" name="resume" @change="setFileUpload" />
          <span class="file-cta">
            <span class="file-icon">
              <i class="fas fa-upload"></i>
            </span>
            <span class="file-label">Escolha um arquivo...</span>
          </span>
          <span class="file-name" v-if="selectedFile">{{ selectedFile.name }}</span>
        </label>
      </div>
      <button @click="uploadCurrentFile" :disabled="!selectedFile" class="button is-info">
        Enviar Arquivo
      </button>
      <input
        v-if="chatId" 
        v-model="newMessage" 
        @keyup.enter="sendMessage"
        class="input is-hovered"
        type="text"
        placeholder="Digite sua mensagem e aperte enter..." 
      />
      <button v-if="chatId" @click="sendMessage" class="button is-info">Enviar</button>
    </div>

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

.send-container {
  display: flex;
  align-items: center;
}

button {
  margin: 10px;
}

</style>
