import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import tasksRouter from './routes/tasks';
import authRouter from './routes/authRoutes';
import { protect } from './middlewares/authMiddleware';

// Load environment variables
dotenv.config();

// Create Express app
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.get('/api/health', (req: Request, res: Response) => {
  res.status(200).json({
    status: 'success',
    message: 'Server is running',
    timestamp: new Date().toISOString(),
  });
});

// Auth routes (public)
app.use('/api/auth', authRouter);

// Protected routes
app.use('/api/tasks', protect, tasksRouter);

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});