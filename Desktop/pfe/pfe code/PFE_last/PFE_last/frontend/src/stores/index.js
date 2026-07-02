import { defineStore } from 'pinia';

export const useMainStore = defineStore('main', {
  state: () => ({
    email: '',
    resetCode: '',
    user: null,  // Add user state
  }),
  actions: {
    setEmail(email) {
      console.log('Setting email in store:', email); // Add logging
      this.email = email.toLowerCase(); // Ensure email is lowercase
    },
    setCode(code) {
      this.resetCode = code;
    },
    setUser(user) {  // Add setUser action
      console.log('Setting user in store:', user);
      this.user = user;
    },
    logout() {
      // Clear user data
      this.user = null;
      this.email = '';
      this.resetCode = '';
      // Remove token from localStorage
      localStorage.removeItem('token');
      console.log('User logged out');
    }
  },
  persist: true
});