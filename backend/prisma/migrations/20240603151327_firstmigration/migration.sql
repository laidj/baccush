-- CreateTable
CREATE TABLE "User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "fullname" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "AuctionItem" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "productId" TEXT NOT NULL,
    "productName" TEXT NOT NULL,
    "productDescription" TEXT NOT NULL,
    "productCategory" TEXT NOT NULL,
    "biddingEndDate" DATETIME NOT NULL,
    "bid_time" DATETIME NOT NULL,
    "bid_amount" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    CONSTRAINT "AuctionItem_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "AuctionItemBidAmount" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "bid_amount" INTEGER NOT NULL,
    "bid_time" DATETIME NOT NULL,
    "auctionItem_id" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    CONSTRAINT "AuctionItemBidAmount_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "AuctionItemBidAmount_auctionItem_id_fkey" FOREIGN KEY ("auctionItem_id") REFERENCES "AuctionItem" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "AuctionItem_productId_key" ON "AuctionItem"("productId");
