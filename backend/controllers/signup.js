import express from 'express';
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();
const router = express.Router();

const errorHandler = (err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
};

router.post('/', async (req, res, next) => {
  const { fullname, email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10).catch(next);
  const user = await prisma.user.create({
    data: {
      fullname,
      email,
      password: hashedPassword,
    },
  }).catch(next);

  res.json({ user });
});

router.use(errorHandler);

export const signUpController = router;