import sqlite3
import os

db_path = os.path.join(os.path.dirname(__file__), '..', 'incorrupto.db')
conn = sqlite3.connect(db_path)
cursor = conn.cursor()
cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
tables = cursor.fetchall()
print('Tables:', tables)
cursor.execute('SELECT * FROM users')
rows = cursor.fetchall()
print('Users:')
for row in rows:
    print(row)
conn.close()