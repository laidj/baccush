import request from 'supertest';
import express from 'express';
import { auctionsController } from '../controllers/auctions.js';

// Mock Prisma
jest.mock('@prisma/client', () => {
  const mockAuctionItemFindUnique = jest.fn();
  const mockAuctionItemCreate = jest.fn();
  const mockAuctionItemUpdate = jest.fn();
  const mockAuctionItemDelete = jest.fn();
  return {
    PrismaClient: jest.fn(() => ({
      auctionItem: {
        findUnique: mockAuctionItemFindUnique,
        create: mockAuctionItemCreate,
        update: mockAuctionItemUpdate,
        delete: mockAuctionItemDelete,
      },
    })),
  };
});

const { PrismaClient } = require('@prisma/client'); // Import after mocking

// Create an instance of Express app and use the auctionsController
const app = express();
app.use(express.json());
app.use('/api/auctions', auctionsController);

describe('Auctions Controller', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('GET /api/auctions/:id', () => {
    it('should respond with a single auction', async () => {
      const mockAuction = {
        productId: 'c740aa6b-edeb-4ed0-a8be-2efcbe6b44bf',
        productName: 'CORSAIR Vengeance LPX 16GB',
        productDescription: 'Inspiring CORSAIR Vengeance LPX 16GB',
        productCategory: 'Computer hardware',
        biddingEndDate: '2024-05-29T19:10:56Z',
        bid_time: '2024-05-29T19:10:56Z',
        bid_amount: 100,
        user_id: 1,
      };

      const prisma = new PrismaClient();
      prisma.auctionItem.findUnique.mockResolvedValue(mockAuction);

      const response = await request(app).get('/api/auctions/c740aa6b-edeb-4ed0-a8be-2efcbe6b44bf');

      console.log('GET /api/auctions/:id response status:', response.status);
      console.log('GET /api/auctions/:id response body:', response.body);

      expect(response.status).toBe(200);
      expect(response.body).toEqual(mockAuction);
    });
  });

  describe('POST /api/auctions', () => {
    it('should create a new auction', async () => {
      const newAuction = {
        productId: 'new-product-id',
        productName: 'New Product',
        productDescription: 'New Product Description',
        productCategory: 'New Category',
        biddingEndDate: '2024-06-01T19:10:56Z',
        bid_time: '2024-06-01T19:10:56Z',
        bid_amount: 150,
        user_id: 1,
      };

      const prisma = new PrismaClient();
      prisma.auctionItem.create.mockResolvedValue(newAuction);

      const response = await request(app)
        .post('/api/auctions')
        .send(newAuction);

      console.log('POST /api/auctions response status:', response.status);
      console.log('POST /api/auctions response body:', response.body);

      expect(response.status).toBe(201);
      expect(response.body).toEqual(newAuction);
    });
  });

  describe('PUT /api/auctions/:id', () => {
    it('should update an auction', async () => {
      const updatedAuction = {
        productId: 'existing-product-id',
        productName: 'Updated Product',
        productDescription: 'Updated Product Description',
        productCategory: 'Updated Category',
        biddingEndDate: '2024-06-01T19:10:56Z',
        bid_time: '2024-06-01T19:10:56Z',
        bid_amount: 200,
        user_id: 1,
      };

      const prisma = new PrismaClient();
      prisma.auctionItem.update.mockResolvedValue(updatedAuction);

      const response = await request(app)
        .put('/api/auctions/existing-product-id')
        .send(updatedAuction);

      console.log('PUT /api/auctions/:id response status:', response.status);
      console.log('PUT /api/auctions/:id response body:', response.body);

      expect(response.status).toBe(200);
      expect(response.body).toEqual(updatedAuction);
    });
  });

  describe('DELETE /api/auctions/:id', () => {
    it('should delete an auction', async () => {
      const deletedAuction = {
        productId: 'existing-product-id',
        productName: 'Deleted Product',
        productDescription: 'Deleted Product Description',
        productCategory: 'Deleted Category',
        biddingEndDate: '2024-06-01T19:10:56Z',
        bid_time: '2024-06-01T19:10:56Z',
        bid_amount: 100,
        user_id: 1,
      };

      const prisma = new PrismaClient();
      prisma.auctionItem.delete.mockResolvedValue(deletedAuction);

      const response = await request(app)
        .delete('/api/auctions/existing-product-id');

      console.log('DELETE /api/auctions/:id response status:', response.status);
      console.log('DELETE /api/auctions/:id response body:', response.body);

      expect(response.status).toBe(200);
      expect(response.body).toEqual(deletedAuction);
    });
  });
});
