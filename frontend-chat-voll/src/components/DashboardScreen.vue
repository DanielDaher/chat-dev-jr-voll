<script>
import Webchat from './WebChat.vue';
import { ref, onMounted, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';
import { getContacts } from '../services/api';
// import ActionCable from '@rails/actioncable';

export default {
  components: {
    Webchat
  },
  setup() {
    const currentChatId = ref(null);
    // const socket = io(process.env.VUE_APP_API_URL);
    const contacts = ref([]);
    const router = useRouter();
    // let cable = inject('$cable');
    // let subscription = null;

    const makeLogout = () => {
      localStorage.removeItem('tokenChatVollDevJr');
      return router.push('/');
    }

    const loadContacts = async () => {
      const token = localStorage.getItem('tokenChatVollDevJr');
      const userId = localStorage.getItem('userIdChatVollDevJr');

      const apiContacts = await getContacts(userId, token);
      contacts.value = apiContacts;
    }

    const setCurrentChatId = (contact) => {
      console.log(contact);
      currentChatId.value = contact.user_id;
      const currentIndex = contacts.value.indexOf(contact);
      contacts.value[currentIndex] = { ...contact, newMessage: false };
    }

    onUnmounted(() => {
      // cable.unregisterChannels(channels);
      // cable.unsubscribe("ChatChannel");
    });

    onMounted(() => {
      loadContacts();
      // nextTick(() => {
      //   if (cable) {
      //     cable.registerChannels(channels);
      //     cable.subscribe(
      //       {
      //         channel: "ChatChannel",
      //         room: "public"
      //       },
      //       "chat_channel_public"
      //     );
    
      //     cable.subscribe(
      //       {
      //         channel: "ChatChannel",
      //         room: "private"
      //       },
      //       "chat_channel_private"
      //     );
      //   }
      // })
    });

    // const channels = {
    //   chat_channel_public: {
    //     connected() {
    //       console.log("I am connected to the public chat channel.");
    //     },
    //   },
    //   chat_channel_private: {
    //     connected() {
    //       console.log("I am connected to the private chat channel.");
    //     },
    //   },
    // };

    // socket.on("telegramMessage", ({ chat }) => {
    //   const oldContact = contacts.value.find((contact) => contact._id === chat.id);
    //   const newContact = chat;

    //   if (oldContact) {
    //     const currentIndex = contacts.value.indexOf(oldContact);
    //     contacts.value[currentIndex] = { ...oldContact, newMessage: true }
    //   }
      
    //   if (!oldContact) {
    //     contacts.value.push(newContact);
    //   }
    // });

    // const connectToActionCable = () => {
    //   cable = ActionCable.createConsumer(process.env.VUE_APP_CABLE_URL);

    //   subscription = cable.subscriptions.create("ChatChannel", {
    //     received(data) {
    //       const chat = data.chat;
    //       const oldContact = contacts.value.find((contact) => contact._id === chat.id);
    //       const newContact = chat;

    //       if (oldContact) {
    //         const currentIndex = contacts.value.indexOf(oldContact);
    //         contacts.value[currentIndex] = { ...oldContact, newMessage: true };
    //       } else {
    //         contacts.value.push(newContact);
    //       }
    //     }
    //   });
    // };

    return { makeLogout, loadContacts, setCurrentChatId, contacts, currentChatId, router };
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
                {{ contact.user.name }}
              </p>
              <span v-if="contact.newMessage" class="tag is-primary">!!!</span>
            </header>
          </div>
        </div>
      </div>
    </header>
    <webchat :chatId="currentChatId" />
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
