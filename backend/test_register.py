import json
import urllib.request

url = 'http://127.0.0.1:8000/register'
data = json.dumps({'email': 'test@example.com', 'password': 'Password123!'}).encode('utf-8')
req = urllib.request.Request(url, data=data, headers={'Content-Type': 'application/json'})

try:
    with urllib.request.urlopen(req, timeout=10) as r:
        print('CODE', r.status)
        print(r.read().decode())
except Exception as e:
    import traceback
    traceback.print_exc()
