/*
  Warnings:

  - The primary key for the `AuctionItemBidAmount` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `auctionItem_id` on the `AuctionItemBidAmount` table. All the data in the column will be lost.
  - Added the required column `auctionItemBidAmount_id` to the `AuctionItem` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_AuctionItem" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "productId" TEXT NOT NULL,
    "productName" TEXT NOT NULL,
    "productDescription" TEXT NOT NULL,
    "productCategory" TEXT NOT NULL,
    "biddingEndDate" DATETIME NOT NULL,
    "bid_time" DATETIME NOT NULL,
    "bid_amount" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "auctionItemBidAmount_id" TEXT NOT NULL,
    CONSTRAINT "AuctionItem_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "AuctionItem_auctionItemBidAmount_id_fkey" FOREIGN KEY ("auctionItemBidAmount_id") REFERENCES "AuctionItemBidAmount" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_AuctionItem" ("bid_amount", "bid_time", "biddingEndDate", "id", "productCategory", "productDescription", "productId", "productName", "user_id") SELECT "bid_amount", "bid_time", "biddingEndDate", "id", "productCategory", "productDescription", "productId", "productName", "user_id" FROM "AuctionItem";
DROP TABLE "AuctionItem";
ALTER TABLE "new_AuctionItem" RENAME TO "AuctionItem";
CREATE UNIQUE INDEX "AuctionItem_productId_key" ON "AuctionItem"("productId");
CREATE TABLE "new_AuctionItemBidAmount" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "bid_amount" INTEGER NOT NULL,
    "bid_time" DATETIME NOT NULL,
    "user_id" INTEGER NOT NULL,
    CONSTRAINT "AuctionItemBidAmount_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_AuctionItemBidAmount" ("bid_amount", "bid_time", "id", "user_id") SELECT "bid_amount", "bid_time", "id", "user_id" FROM "AuctionItemBidAmount";
DROP TABLE "AuctionItemBidAmount";
ALTER TABLE "new_AuctionItemBidAmount" RENAME TO "AuctionItemBidAmount";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
