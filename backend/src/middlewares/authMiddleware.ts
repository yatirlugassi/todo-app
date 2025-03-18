import { Request, Response, NextFunction } from 'express';
import supabase from '../services/supabase';

export const protect = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // Get token from authorization header
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      res.status(401).json({
        message: 'Not authorized, no token provided'
      });
      return;
    }
    
    // Extract the token
    const token = authHeader.split(' ')[1];
    
    // Verify the JWT with Supabase
    const { data, error } = await supabase.auth.getUser(token);
    
    if (error || !data.user) {
      res.status(401).json({
        message: 'Not authorized, token invalid'
      });
      return;
    }
    
    // Instead of adding to req.user, pass the user to locals which is meant for this purpose
    res.locals.user = data.user;
    
    next();
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Authentication error';
    res.status(401).json({
      message: errorMessage
    });
  }
};