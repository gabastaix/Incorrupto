from typing import Optional
from pydantic import BaseModel, EmailStr, constr, validator

class UserBase(BaseModel):
    email: EmailStr
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    age: Optional[int] = None
    preferences: Optional[dict] = None

class UserCreate(UserBase):
    password: str

    @validator('password')
    def validate_password(cls, v):
        if isinstance(v, str):
            # Truncate to 72 bytes
            v = v.encode('utf-8')[:72].decode('utf-8', errors='ignore')
        return v

class UserRead(UserBase):
    id: int

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None
