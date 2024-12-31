import { Request } from "express";

export interface UserLoginRequest extends Request {
  body: {
    username: String;
    password: String;
  };
}

export interface UserRegisterRequest extends Request {
  body: {
    username: String;
    password: String;
    macAddress: String;
  };
}

export interface UserUpdatePreferencesRequest extends Request {
  body: {
    username: String;
    minLevel: number;
    minQuality: number;
  };
}

export interface UserUpdatePasswordRequest extends Request {
  body: {
    username: String;
    password: String;
    newPassword: String;
  };
}
