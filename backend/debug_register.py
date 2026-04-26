import json
import urllib.request
import urllib.error

url = 'http://127.0.0.1:8000/register'
data = json.dumps({'email': 'user@example.com', 'password': 'string'}).encode('utf-8')
req = urllib.request.Request(url, data=data, headers={'Content-Type': 'application/json'})

try:
    with urllib.request.urlopen(req, timeout=10) as r:
        print('status', r.status)
        print(r.read().decode())
except urllib.error.HTTPError as e:
    print('status', e.code)
    print(e.read().decode())
except Exception:
    import traceback
    traceback.print_exc()
