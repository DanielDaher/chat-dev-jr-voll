<script>
import io from 'socket.io-client';
import Webchat from './WebChat.vue';
import { useRouter } from 'vue-router';
import { getContacts } from '../services/api';
import { ref, onMounted, onBeforeUnmount } from 'vue';

export default {
  components: {
    Webchat
  },
  setup() {
    const currentChatId = ref(null);
    const socket = io(process.env.VUE_APP_WEBSOCKET_URL);
    const contacts = ref([]);
    const router = useRouter();
    const myselfId = ref(null);
    const currentToken = ref(null);

    const makeLogout = () => {
      localStorage.removeItem('tokenChatVollDevJr');
      return router.push('/');
    }

    const setMyselfId = () => {
      const userId = localStorage.getItem('userIdChatVollDevJr');
      console.log('user id : ', userId)
      myselfId.value = Number(userId);
    }

    const loadContacts = async () => {
      const token = localStorage.getItem('tokenChatVollDevJr');
      currentToken.value = token;

      const apiContacts = await getContacts(token);
      contacts.value = apiContacts;
    }

    const setCurrentChatId = (contact) => {
      currentChatId.value = contact.id;
      const currentIndex = contacts.value.indexOf(contact);
      contacts.value[currentIndex] = { ...contact, newMessage: false };
    }

    onBeforeUnmount(() => {
      socket.disconnect();
    });

    onMounted(() => {
      setMyselfId();
      loadContacts();
    });

    socket.on("message", ({ user, send_to }) => {
      const IBelongToChat = myselfId.value === user.id || myselfId.value === send_to.id;

      if (IBelongToChat) {
        const socketContact = user.id === myselfId.value ? send_to : user;
  
        const oldContact = contacts.value.find((contact) => contact.name === socketContact.name);
        const newContact = { user };
  
        if (oldContact) {
          const currentIndex = contacts.value.indexOf(oldContact);
          contacts.value[currentIndex] = { ...oldContact, newMessage: true }
        }
        
        if (!oldContact) {
          contacts.value.push(newContact);
        }
      }

    });

    return {
      makeLogout,
      loadContacts,
      setCurrentChatId,
      setMyselfId,
      currentToken,
      myselfId,
      contacts,
      currentChatId,
      router
    };
  },
};

</script>

<template>
  <div class="dashboard-div">
    <header class="dashboard-header" >
      <button 
        title="Clique aqui para fazer logout" 
        class="button is-dark is-responsive is-hovered logout-button"
        @click="makeLogout"
      >
        Sair
      </button>
      <div class="dashboard-chats box" v-if="contacts && contacts.length">
        <p class="title is-6">Conversas</p>
        <div v-for="contact in contacts" :key="contact.id">
          <div
            class="pointer"
            :title="contact.newMessage ? 'Nova mensagem' : 'Clique para iniciar conversa'"
            @click="setCurrentChatId(contact)"
          >
            <header class="card-header contact-chat">
              <p class="card-header-title" style="width: 180px">
                {{ contact.name }}
              </p>
              <span v-if="contact.newMessage" class="tag is-primary">!!!</span>
            </header>
          </div>
        </div>
      </div>
    </header>
    <webchat v-if="myselfId" :chatId="currentChatId" :myselfId="myselfId" :currentToken="currentToken" />
  </div>
</template>

<style scoped>
  a {
    text-decoration: none;
    color: white;
  }
  .dashboard-div {
    display: flex;
    height: 100vh;
  }

  .dashboard-header {
    display: flex;
    flex-direction: column;
    margin: 35px;
    width: 500px;
  }

  .dashboard-chats {
    max-height: 70vh;
    overflow: auto;
    overflow-x: hidden;
  }

  .contact-chat {
    display: flex;
    justify-content: space-between;
  }

  .logout-button, .telegram-button {
    margin: 5px;
    width: 120px;
  }

  .pointer {
    cursor: pointer
  }
</style>
