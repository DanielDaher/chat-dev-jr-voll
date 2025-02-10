<script>
import { ref } from 'vue';
import Swal from 'sweetalert2'
import { useRouter } from 'vue-router';
import { loginOrCreateUser } from '../services/api';

export default {
  setup() {
    const newAccount = ref(false);
    const errorMessage = ref('');
    const username = ref('');
    const password = ref('');
    const router = useRouter();

    const submitForm = async () => {
      const endpoint = newAccount.value ? 'users' : 'auths';
      const params = { userName: username.value, password: password.value, endpoint }
      const apiData = await loginOrCreateUser(params);

      // Swal.fire('Isso pode demorar alguns minutos se o servidor estiver inativo')

      if (apiData.token) {
        localStorage.setItem('tokenChatVollDevJr', apiData.token);
        localStorage.setItem('userIdChatVollDevJr', apiData.user_id);
        return router.push('/dashboard');
      } 

      errorMessage.value = apiData.response.data.error || 'Usuário ou senha inválidos';
      Swal.fire({
        title: errorMessage.value,
        timer: 2000,
        showConfirmButton: true,
        timerProgressBar: true,
      });
      errorMessage.value = '';
    };

    return { username, password, errorMessage, newAccount, router, submitForm };
  },

  mounted() {
    const token = localStorage.getItem('tokenChatVollDevJr');
    if (token) return this.router.push('/dashboard');
  }
};
</script>

<template>
  <div class="login-page">
    <div class="box">
      <h2 class="title">Chat Voll-Dev-Jr</h2>
      <form @submit.prevent="submitForm">
        <div>
          <label class="checkbox">
            <input type="checkbox" v-model="newAccount">
            Não tenho uma conta ainda
          </label>
        </div>
        <p class="title is-6">
          Preencha suas informações para {{ newAccount ? 'se cadastrar' : 'logar' }}
        </p>
        <input 
          class="input is-hovered" 
          type="text" 
          placeholder="nome de usuário" 
          v-model="username" 
        />
        <br>
        <input
          class="input is-hovered"
          type="password" 
          placeholder="senha" 
          v-model="password" 
        />
        <div>
          <button class="button is-link" type="submit">Login</button>
        </div>
        <p v-if="errorMessage.length">{{ errorMessage }}</p>
      </form>
    </div>
  </div>
</template>

<style scoped>
  .login-page {
    display: flex;
    align-items: center;
    flex-direction: column;
    justify-content: center;
    height: 90vh;
  }
  .box {
    display: flex;
    flex-direction: column;
    justify-content: center;
    height: 50vh;
    width: 40vw;
  }
  .input {
    margin: 3px;
    width: 300px;
  }
  button {
    margin: 10px;
  }
</style>
