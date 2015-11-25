import urllib2
import json

def check_exist_user_data (users_data, user_name):
  for x in users_data:
    if x['name'] == user_name:
      return 1
  return 0

url = 'http://localhost:3000/users/5654b7617472613e56000000.json'
username = 'pophealth'
password = 'pophealth'
p = urllib2.HTTPPasswordMgrWithDefaultRealm()
p.add_password(None, url, username, password)
handler = urllib2.HTTPBasicAuthHandler(p)

opener = urllib2.build_opener(handler)
urllib2.install_opener(opener)
page = urllib2.urlopen(url).read()

user_data = json.loads(page)
user_name = user_data['name']
user_file = '/home/trantube94/workspace/hGraph/examples/multiuser/data/user-data/' + user_name + '.json'
with open(user_file, 'w') as f1:
  json.dump(user_data, f1, ensure_ascii=False)

with open("/home/trantube94/workspace/hGraph/examples/multiuser/data/users1.json") as users_file:    
  users_data = json.load(users_file)

if check_exist_user_data(users_data, user_name):
  print "Exist user data"
else:
  users_data.append(dict(name=user_name, id=user_name, intro="hehehe"))

with open('/home/trantube94/workspace/hGraph/examples/multiuser/data/users1.json', 'w') as f2:
  json.dump(users_data, f2, ensure_ascii=False)
