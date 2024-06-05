<template>
  <nav class="navbar" role="navigation" aria-label="main navigation">
    <div class="navbar-brand">
      <a role="button" :class="['navbar-burger', { 'is-active': isMenuOpen }]" aria-label="menu" aria-expanded="false"
        @click="toggleMenu">
        <span aria-hidden="true" style="height: 2px; width: 20px;"></span>
        <span aria-hidden="true" style="height: 2px; width: 20px;"></span>
        <span aria-hidden="true" style="height: 2px; width: 20px;"></span>
      </a>
    </div>

    <div class="navbar-menu" :class="{ 'is-active': isMenuOpen }" style="position: absolute; top: 100%; right: 0;">
      <div class="navbar-end">
        <div class="navbar-item has-dropdown is-hoverable">
          <div class="navbar-dropdown">
           <!-- Show login and sign-up modals -->
           <a v-if="!isAuthenticated" class="navbar-item" @click="showLoginModal">Login</a>
            <a v-if="!isAuthenticated" class="navbar-item" @click="showSignUpModal">Sign Up</a>
            <!-- Show logout button when authenticated -->
            <a v-if="isAuthenticated" class="navbar-item" @click="logout">Logout</a>
          </div>
        </div>
      </div>
    </div>

    <div class="navbar-menu">
      <div class="navbar-end">
        <div class="navbar-item">
          <div class="buttons">
            <b-button v-if="!isAuthenticated"  @click="showLoginModal" type="is-primary" outlined>Login</b-button>
            <b-button v-if="!isAuthenticated" @click="showSignUpModal" type="is-success" outlined>Sign Up</b-button>
            <b-button v-if="isAuthenticated" @click="logout" type="is-danger" outlined>Logout</b-button>
          </div>
        </div>
      </div>
    </div>
  </nav>
</template>

<script>
import { useAuthStore } from '@/store/auth.js'
import "@/styles/navbar.css";

export default {
  data() {
    return {
      isMenuOpen: false
    };
  },
  computed: {
    isAuthenticated() {
      return useAuthStore().isAuthenticated;
    }
  },
  methods: {
    toggleMenu() {
      this.isMenuOpen = !this.isMenuOpen;
    },
    showLoginModal() {
      console.log("Login button clicked");
      this.$emit("login");
    },
    showSignUpModal() {
      console.log("Sign Up button clicked");
      this.$emit("signup");
    },
    logout() {
      useAuthStore().logout();
    }
  }
};
</script>