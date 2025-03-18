// Authentication request/response types
export interface SignUpRequest {
  email: string;
  password: string;
  firstName?: string;
  lastName?: string;
}

export interface SignInRequest {
  email: string;
  password: string;
}

export interface ResetPasswordRequest {
  email: string;
}

export interface AuthResponse {
  token?: string;
  user?: {
    id: string;
    email: string;
  };
  message?: string;
}