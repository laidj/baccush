import express from 'express';
import { PrismaClient } from '@prisma/client';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();
const router = express.Router();

const errorHandler = (err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
};

router.post('/', async (req, res, next) => {
  const { email, password } = req.body;
  const user = await prisma.user.findUnique({ where: { email } }).catch(next);

  if (!user || !(await bcrypt.compare(password, user.password))) {
    return res.status(400).json({ error: "Invalid email or password" });
  }

  const token = jwt.sign({ userId: user.id }, 'your_secret_key', { expiresIn: '1h' });
  res.json({ user, token });
});

router.use(errorHandler);

export const loginController = router;