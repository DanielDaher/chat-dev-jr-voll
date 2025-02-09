import axios from 'axios';

axios.defaults.baseURL = process.env.VUE_APP_API_URL;

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



export { loginOrCreateUser };
