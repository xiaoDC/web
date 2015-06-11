import pymongo
conn = pymongo.Connection("127.0.0.1")
print conn.database_names()
db = conn.test
db.users.insert({"name":"candy","id":"43ese"})
for doc in db.users.find({}):
    print(doc)
