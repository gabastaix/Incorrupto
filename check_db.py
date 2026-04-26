import sqlite3

conn = sqlite3.connect('incorrupto.db')
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