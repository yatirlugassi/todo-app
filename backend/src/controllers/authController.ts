import { Request, Response } from 'express';
import supabase from '../services/supabase';
import { signInUser } from '../services/authService';
import { SignInRequest, AuthResponse } from '../types/authTypes';

export const signUp = async (req: Request, res: Response) => {
  // Auth controller logic for signup
};

export const signIn = async (req: Request, res: Response) => {
    const { email, password }: SignInRequest = req.body;
    try {
        const data = await signInUser(email, password);
        const response: AuthResponse = {
            message: 'User signed in successfully',
            user: data.user,
            token: data.token
        };
        res.status(200).json(response);
    } catch (error: unknown) {
        const errorMessage = error instanceof Error ? error.message : 'An unknown error occurred';
        res.status(500).json({
            message: errorMessage
        });
    }
};

export const signOut = async (req: Request, res: Response) => {
  // Auth controller logic for signout
};

export const resetPassword = async (req: Request, res: Response) => {
  // Auth controller logic for password reset
};