import sys
sys.path.insert(0, r'c:\Users\alexb\OneDrive\Bureau\Incorrupto\backend')
from auth import get_password_hash, verify_password

hashed = get_password_hash('string')
print('hash', hashed)
print('verify correct', verify_password('string', hashed))
print('verify wrong', verify_password('wrong', hashed))
