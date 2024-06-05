-- CreateTable
CREATE TABLE "User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "fullname" TEXT,
    "email" TEXT,
    "password" TEXT
);

-- CreateTable
CREATE TABLE "AuctionItem" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "productId" INTEGER NOT NULL,
    "productName" TEXT NOT NULL,
    "productDescription" TEXT NOT NULL,
    "productCategory" TEXT NOT NULL,
    "biddingEndDate" INTEGER NOT NULL,
    "bid_time" INTEGER NOT NULL,
    "bid_amount" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    CONSTRAINT "AuctionItem_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "AuctionItemBidAmount" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "bid_amount" INTEGER NOT NULL,
    "auctionItem_id" INTEGER NOT NULL,
    CONSTRAINT "AuctionItemBidAmount_auctionItem_id_fkey" FOREIGN KEY ("auctionItem_id") REFERENCES "AuctionItem" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "AuctionItem_productId_key" ON "AuctionItem"("productId");
