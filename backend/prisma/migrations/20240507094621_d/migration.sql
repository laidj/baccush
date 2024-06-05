/*
  Warnings:

  - The primary key for the `AuctionItemBidAmount` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to alter the column `id` on the `AuctionItemBidAmount` table. The data in that column could be lost. The data in that column will be cast from `String` to `Int`.
  - You are about to drop the column `auctionItemBidAmount_id` on the `AuctionItem` table. All the data in the column will be lost.
  - Added the required column `auctionItem_id` to the `AuctionItemBidAmount` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_AuctionItemBidAmount" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "bid_amount" INTEGER NOT NULL,
    "bid_time" DATETIME NOT NULL,
    "auctionItem_id" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    CONSTRAINT "AuctionItemBidAmount_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "AuctionItemBidAmount_auctionItem_id_fkey" FOREIGN KEY ("auctionItem_id") REFERENCES "AuctionItem" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_AuctionItemBidAmount" ("bid_amount", "bid_time", "id", "user_id") SELECT "bid_amount", "bid_time", "id", "user_id" FROM "AuctionItemBidAmount";
DROP TABLE "AuctionItemBidAmount";
ALTER TABLE "new_AuctionItemBidAmount" RENAME TO "AuctionItemBidAmount";
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
    CONSTRAINT "AuctionItem_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_AuctionItem" ("bid_amount", "bid_time", "biddingEndDate", "id", "productCategory", "productDescription", "productId", "productName", "user_id") SELECT "bid_amount", "bid_time", "biddingEndDate", "id", "productCategory", "productDescription", "productId", "productName", "user_id" FROM "AuctionItem";
DROP TABLE "AuctionItem";
ALTER TABLE "new_AuctionItem" RENAME TO "AuctionItem";
CREATE UNIQUE INDEX "AuctionItem_productId_key" ON "AuctionItem"("productId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
