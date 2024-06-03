import express from 'express';
import axios from 'axios';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const router = express.Router();

const errorHandler = (err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
};

router.get('/', async (req, res, next) => {
  const response = await axios.get('http://uptime-auction-api.azurewebsites.net/api/Auction').catch(next);
  res.json(response.data);
});

router.post('/bid', async (req, res, next) => {
  const { productId, bidTime, bid_amount, user_id, productName, productDescription, productCategory, biddingEndDate } = req.body;

  const user = await prisma.user.findUnique({ where: { id: user_id } }).catch(next);
  if (!user) return res.status(400).json({ error: 'User not found' });

  let auctionItem = await prisma.auctionItem.findUnique({ where: { id: productId } }).catch(next);

  if (!auctionItem) {
    auctionItem = await prisma.auctionItem.create({
      data: {
        id: productId,
        productId,
        productName,
        productDescription,
        productCategory,
        biddingEndDate: new Date(biddingEndDate),
        bid_time: bidTime,
        bid_amount,
        user_id
      }
    }).catch(next);
  } else {
    const highestBid = await prisma.auctionItemBidAmount.findFirst({
      where: { auctionItem_id: productId, NOT: { user_id } },
      orderBy: { bid_amount: 'desc' }
    }).catch(next);

    if (!highestBid || bid_amount > highestBid.bid_amount) {
      await prisma.auctionItem.update({
        where: { id: productId },
        data: { bid_time: bidTime, bid_amount, user_id }
      }).catch(next);
    }
  }

  const existingBid = await prisma.auctionItemBidAmount.findFirst({
    where: { auctionItem_id: productId, user_id }
  }).catch(next);

  if (existingBid) {
    const updatedBid = await prisma.auctionItemBidAmount.update({
      where: { id: existingBid.id },
      data: { bid_amount }
    }).catch(next);
    res.json({ message: 'Bid updated successfully', bid: updatedBid });
  } else {
    const newBid = await prisma.auctionItemBidAmount.create({
      data: {
        bid_amount,
        AuctionItem: { connect: { id: productId } },
        User: { connect: { id: user_id } }
      }
    }).catch(next);
    res.json({ message: 'Bid saved successfully', bid: newBid, fullName: user.fullname });
  }
});

router.delete('/removeBid', async (req, res, next) => {
  const { productId, user_id } = req.body;

  const existingBid = await prisma.auctionItemBidAmount.findFirst({
    where: { auctionItem_id: productId, user_id }
  }).catch(next);

  if (!existingBid) return res.status(404).json({ error: 'No existing bid found for removal' });

  await prisma.auctionItemBidAmount.delete({ where: { id: existingBid.id } }).catch(next);

  const otherBids = await prisma.auctionItemBidAmount.findMany({
    where: { auctionItem_id: productId, NOT: { user_id } }
  }).catch(next);

  if (otherBids.length === 0) {
    await prisma.auctionItem.delete({ where: { id: productId } }).catch(next);
  }

  res.json({ message: 'Bid removed successfully' });
});

router.get('/userAuctions', async (req, res, next) => {
  const { userId } = req.query;
  const userAuctions = await prisma.auctionItem.findMany({
    where: { user_id: parseInt(userId) },
    include: { AuctionItemBidAmount: true }
  }).catch(next);
  res.json(userAuctions);
});

router.use(errorHandler);

export const auctionsController = router;