/*
  Warnings:

  - Added the required column `user_id` to the `AuctionItemBidAmount` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_AuctionItemBidAmount" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "bid_amount" INTEGER NOT NULL,
    "auctionItem_id" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    CONSTRAINT "AuctionItemBidAmount_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "AuctionItemBidAmount_auctionItem_id_fkey" FOREIGN KEY ("auctionItem_id") REFERENCES "AuctionItem" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_AuctionItemBidAmount" ("auctionItem_id", "bid_amount", "id") SELECT "auctionItem_id", "bid_amount", "id" FROM "AuctionItemBidAmount";
DROP TABLE "AuctionItemBidAmount";
ALTER TABLE "new_AuctionItemBidAmount" RENAME TO "AuctionItemBidAmount";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
