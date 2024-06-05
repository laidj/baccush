/*
  Warnings:

  - The primary key for the `AuctionItem` table will be changed. If it partially fails, the table could be left without primary key constraint.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_AuctionItemBidAmount" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "bid_amount" INTEGER NOT NULL,
    "auctionItem_id" TEXT NOT NULL,
    CONSTRAINT "AuctionItemBidAmount_auctionItem_id_fkey" FOREIGN KEY ("auctionItem_id") REFERENCES "AuctionItem" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_AuctionItemBidAmount" ("auctionItem_id", "bid_amount", "id") SELECT "auctionItem_id", "bid_amount", "id" FROM "AuctionItemBidAmount";
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
