<template>
    <div>
        <div>
            <MainNav @login="showLoginModal" @signup="showSignUpModal" @logout="closeModals" />
            <b-modal v-model="modalActive" :can-cancel="['escape', 'click', 'outside']">
                <div class="modal-container">
                    <div class="modal-card">
                        <header class="modal-card-head">
                            <h1 class="modal-card-title">{{ modalTitle }}</h1>
                            <button class="delete" aria-label="close" @click="closeModals"></button>
                        </header>
                        <section class="modal-card-body">
                            <LoginSignUpForm :is-sign-up="isSignUp" @toggle-form="toggleForm"
                                @login-success="closeModals" />
                        </section>
                    </div>
                </div>
            </b-modal>
        </div>
        <div class="field has-addons">
            <p class="control">
                <b-dropdown aria-role="list" v-model="currentCategory">
                    <template #trigger>
                        <b-button :label="selectedCategoryLabel" :icon-right="dropdownActive ? 'menu-up' : 'menu-down'"
                            type="is-info" />
                    </template>

                    <b-dropdown-item aria-role="listitem" value="">All Categories</b-dropdown-item>
                    <b-dropdown-item aria-role="listitem" v-for="category in categories" :key="category"
                        :value="category">
                        {{ category }}
                    </b-dropdown-item>
                </b-dropdown>
            </p>
        </div>
        <div>
            <transition-group tag="div" class="columns is-multiline is-mobile mt-4">
                <div v-for="auction in filteredAuctions" :key="auction.productId" class="column is-one-quarter">
                    <div class="card" :id="'card-' + auction.productId" @mouseenter="showBidButton(auction)"
                        @mouseleave="hideBidButton(auction)">
                        <button v-if="auction.showBidButton && isAuthenticated" class="button is-primary bid-button"
                            @click="flipCard(auction)">
                            Bid
                        </button>
                        <button v-else-if="auction.showBidButton && !isAuthenticated"
                            class="button is-primary bid-button" @click="showLoginModal">
                            Bid
                        </button>
                        <div v-if="!auction.isFlipped" class="card-content"
                            :class="{ 'card-blur': auction.showBidButton }">
                            <div class="media">
                                <div class="media-content">
                                    <p class="title is-5">{{ auction.productName }}</p>
                                    <p class="subtitle is-6">{{ auction.productDescription }}</p>
                                </div>
                            </div>
                            <div class="content">
                                <p>Remaining Time: {{ getRemainingTime(auction) }}</p>
                            </div>
                        </div>
                        <div v-else class="card-content">
                            <div class="media">
                                <div class="media-content">
                                    <p class="title is-5">{{ auction.productName }}</p>
                                    <p class="subtitle is-6">{{ auction.productDescription }}</p>
                                </div>
                                <button class="delete"  aria-label="close" @click="closeBid(auction)"></button>
                            </div>
                            <div class="content">
                                <p>Remaining Time: {{ getRemainingTime(auction) }}</p>
                                <div class="field">
                                    <label class="label">EUR</label>
                                    <div class="control">
                                        <!-- Bind the input to the bid amount specific to the current auction -->
                                        <input class="input" type="number" v-model="auctionBidAmount[auction.productId]"
                                        placeholder="Enter your bid amount"
                                        :disabled="auction.previousBidAmount !== null && auctionBidAmount[auction.productId] < auction.previousBidAmount" />
                                    </div>
                                </div>
                                <button v-if="!userHasBid(auction)"class="button is-success" @click="confirmBid(auction)">Place bid</button>
                                <button v-if="userHasBid(auction)"class="button is-warning" @click="confirmBid(auction)">Update bid</button>
                                <button v-if="userHasBid(auction)" class="button is-danger" @click="removeBid(auction)">Remove Bid</button>
                            </div>
                        </div>
                    </div>
                </div>
            </transition-group>
        </div>
    </div>
</template>

<script>

import axios from "axios";
import MainNav from "@/components/MainNav.vue";
import LoginSignUpForm from "@/components/LoginSignUpForm.vue";
import { useAuthStore } from '../store/auth.js'
import "@/styles/home.css";

export default {
    name: "Home",
    components: {
        MainNav,
        LoginSignUpForm
    },
    data() {
        return {
            auctions: [],
            categories: [],
            currentCategory: null,
            modalActive: false,
            modalTitle: "Sign Up",
            isSignUp: false,
            isFormVisible: false,
            dropdownActive: false,
            bid_amount: null,
            showWarning: false,
            userAuctions: [],
            auctionBidAmount: {}
        };
    },
    methods: {
        async fetchAuctions() {
            try {
                const response = await axios.get("http://localhost:3000/api/auctions");
                if (!Array.isArray(response.data)) {
                    console.error("Error fetching auctions:", response.data);
                    return;
                }
                const newAuctions = response.data.filter(
                    (newAuction) => !this.auctions.some((auction) => auction.productId === newAuction.productId)
                );
                this.auctions = [...this.auctions, ...newAuctions];
                this.extractCategories();
            } catch (error) {
                console.error("Error fetching auctions:", error);
            }
        },
        extractCategories() {
            const categoriesSet = new Set();
            this.auctions.forEach((auction) => {
                categoriesSet.add(auction.productCategory);
            });
            this.categories = Array.from(categoriesSet);
        },
        filterByCategory(category) {
            this.currentCategory = category;
        },
        resetFilter() {
            this.currentCategory = null;
        },
        getRemainingTime(auction) {
            const endDate = new Date(auction.biddingEndDate);
            const now = new Date();
            if (endDate <= now) {
                return "Auction ended";
            } else {
                const diff = endDate - now;
                const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((diff % (1000 * 60)) / 1000);
                return `${minutes} minutes ${seconds} seconds`;
            }
        },
        flipCard(auction) {
            auction.isFlipped = !auction.isFlipped;
            auction.showBidButton = false; 
        },
        async confirmBid(auction) {
            try {
                if (!this.auctionBidAmount[auction.productId]) {
                    console.error("Bid amount is empty");
                    return;
                }

                const user = useAuthStore().user;
                const response = await axios.post("http://localhost:3000/api/auctions/bid", {
                    productId: auction.productId,
                    bid_amount: this.auctionBidAmount[auction.productId],
                    user_id: user.id,
                    productName: auction.productName,
                    productDescription: auction.productDescription,
                    productCategory: auction.productCategory,
                    biddingEndDate: auction.biddingEndDate
                });


                auction.isFlipped = false;
                this.fetchUserAuctions()
            } catch (error) {
                console.error("Error placing bid:", error);
            }
        },
        async removeBid(auction) {
            try {
                const user = useAuthStore().user;
                const response = await axios.delete("http://localhost:3000/api/auctions/removeBid", {
                    data: {
                        productId: auction.productId,
                        user_id: user.id
                    }
                });

                console.log(response.data);

                auction.bid_amount = 0;
                auction.isFlipped = false;

                // After successful bid removal, fetch updated user auctions
                await this.fetchUserAuctions();

            } catch (error) {
                console.error("Error removing bid:", error);
            }
        },
        async fetchUserAuctions() {
            try {
                const user = useAuthStore().user;
                if (!user) {
                    console.error('User is not authenticated');
                    return;
                }
                const response = await axios.get(`http://localhost:3000/api/auctions/userAuctions?userId=${user.id}`);
                if (!Array.isArray(response.data)) {
                    console.error('Error fetching user auctions:', response.data);
                    return;
                }

                this.userAuctions = response.data;
            } catch (error) {
                console.error('Error fetching user auctions:', error);
            }
        },
        userHasBid(auction) {
            console.log('Checking if user has bid:', this.userAuctions);
            const hasBid = this.userAuctions.some(item => item.productId === auction.productId);
            console.log('User has bid:', hasBid);
            return hasBid;
        },
        closeBid(auction) {
            auction.isFlipped = false;
        },
        updateAuctionEndDates() {
            const now = new Date();
            this.auctions = this.auctions.filter((auction) => {
                const endDate = new Date(auction.biddingEndDate);
                return endDate > now;
            });
        },
        updateRemainingTime() {
            this.auctions.forEach((auction) => {
                auction.remainingTime = this.getRemainingTime(auction);
            });
        },
        showSignUpModal() {
            this.isSignUp = true;
            this.modalTitle = "Sign Up";
            this.modalActive = true;
        },

        showLoginModal() {
            this.$emit("login");
            this.isSignUp = false;
            this.modalTitle = "Login";
            this.modalActive = true;
        },
        closeModals() {
            this.isFormVisible = false;
            this.modalActive = false;
        },
        toggleForm(isSignUp) {
            this.isSignUp = isSignUp;
            this.modalTitle = isSignUp ? "Sign Up" : "Login";
        },
        showBidButton(auction) {
            auction.showBidButton = !auction.isFlipped;
        },
        hideBidButton(auction) {
            auction.showBidButton = false;
        },
        closeWarning() {
            this.showWarning = false;
        }
    },

    computed: {
        filteredAuctions() {
            if (!this.currentCategory) return this.auctions;
            return this.auctions.filter((auction) => auction.productCategory === this.currentCategory);
        },
        selectedCategoryLabel() {
            return this.currentCategory ? this.currentCategory : 'All Categories';
        },
        isAuthenticated() {
            return useAuthStore().isAuthenticated;
        },
    },

    created() {
        this.fetchAuctions();
        setInterval(() => {
            this.updateAuctionEndDates();
        }, 1000);
        setInterval(() => {
            this.fetchAuctions();
        }, 5000);
    },
};
</script>