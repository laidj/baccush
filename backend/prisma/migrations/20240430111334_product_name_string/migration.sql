/*
  Warnings:

  - You are about to alter the column `biddingEndDate` on the `AuctionItem` table. The data in that column could be lost. The data in that column will be cast from `Int` to `DateTime`.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_AuctionItem" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
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
