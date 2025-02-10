import axios from 'axios';

axios.defaults.baseURL = process.env.VUE_APP_API_URL;
const authToken = localStorage.getItem('tokenChatVollDevJr');

const validateFields = ({ userName, password }) => {
  if (userName.length < 2 || password.length < 4) return false;
  return true;
};

async function loginOrCreateUser({ userName, password, endpoint }) {
  const userError = 'Usuário inválido ou senha curta';
  try {
    if (!validateFields({ userName, password })) return { response: { data: { error: userError } } };

    const APIResponse = await axios.post(`${axios.defaults.baseURL}/${endpoint}`, {
      name: userName,
      password
    });

    return APIResponse.data;
  } catch (error) {
    console.error('Erro na requisição: ', error);
    return error;
  }
}

async function getContacts(userId, token) {
  const axiosConfig = {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  };
  const apiUrl = `${axios.defaults.baseURL}/messages/${userId}`;
  console.log('api url: ', apiUrl)

  try {
    const APIResponse = await axios.get(apiUrl, axiosConfig);
    return APIResponse.data;
  } catch (error) {
    console.error('Erro na requisição: ', error);
    return { apiContacts: [] }
  }
}

async function getMessagesPaginated(user_id, send_to_id) {
  const axiosConfig = {
    params: { send_to_id },
    headers: {
      'Authorization': `Bearer ${authToken}`
    }
  };
  const apiUrl = `${axios.defaults.baseURL}/messages/${user_id}`;

  try {
    const APIResponse = await axios.get(apiUrl, axiosConfig);
    return APIResponse.data;
  } catch (error) {
    console.error('Erro na requisição: ', error);
    return null;
  }
}

export { loginOrCreateUser, getContacts, getMessagesPaginated };
