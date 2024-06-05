import { defineStore } from 'pinia'
import axios from 'axios'

export const useAuthStore = defineStore('store', {
  state: () => ({
    isAuthenticated: false,
    user: null,
  }),

  actions: {
    async login({ email, password }) {
      try {
        const response = await axios.post("http://localhost:3000/api/login", { email, password });
        if (response.status === 200) {
          const { user } = response.data;
          if (user && user.id) {
            this.isAuthenticated = true;
            this.user = user;
            console.log('Login successful:', user);
          } else {
            console.error('Invalid user data returned from login API:', response.data);
          }
        } else {
          console.error('Failed to log in:', response.statusText);
        }
      } catch (error) {
        console.error('Error:', error);
      }
    },

    logout() {
      this.isAuthenticated = false;
      this.user = null;
      this.userId = null; // Clear userId when logout
    },

    async signup({ fullname, email, password }) {
      try {
        const response = await axios.post("http://localhost:3000/api/signup", { fullname, email, password });
        const { user } = response.data;
        this.isAuthenticated = true;
        this.user = user;
        this.userId = user.id; // Set userId when signup is successful
      } catch (error) {
        console.error('Error:', error);
      }
    },
  },

  afterUpdate() {
    // Emit an event whenever isAuthenticated status is updated
    this.$emit('isAuthenticatedChanged', this.isAuthenticated);
  }
})
