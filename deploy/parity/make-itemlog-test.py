import json

j = json.load(open('changeitemprice-crud5.log', encoding='utf-8-sig'))
o = json.loads(j['net'][0]['body'])
s = o['sql']
p = o['params']
s = s.replace('$1', "'" + str(p[0]) + "'::timestamp").replace('$2', str(p[1])).replace('$3', str(p[2]))
open('itemlog-test.sql', 'w', encoding='utf-8').write('BEGIN;\n' + s + ';\nROLLBACK;\n')
print('len', len(s))
print(s[:220])
print('...')
print(s[-220:])
