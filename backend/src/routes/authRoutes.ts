import express from 'express';
import * as authController from '../controllers/authController';

const router = express.Router();

// @ts-ignore - Bypassing TypeScript error
router.post('/signup', authController.signUp);

// @ts-ignore - Bypassing TypeScript error
router.post('/signin', authController.signIn);

// @ts-ignore - Bypassing TypeScript error
router.post('/signout', authController.signOut);

// @ts-ignore - Bypassing TypeScript error
router.post('/reset-password', authController.resetPassword);

export default router;