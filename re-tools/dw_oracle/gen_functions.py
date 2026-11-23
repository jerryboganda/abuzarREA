import json, sys

S = sys.argv[1]
E = []
Q = "~'"  # a quote inside the Evaluate string


def add(e):
    E.append(e)


def s(text):
    return Q + text + Q


def D(d):
    return 'Date(%s)' % s(d)


def T(t):
    return 'Time(%s)' % s(t)


for x in ['2.5', '3.5', '-2.5', '-3.5', '1234.5678', '0.005', '1.005', '2.675', '100', '0.125', '0', '-0.5', '99.995', '1e3']:
    for n in ['0', '1', '2', '3']:
        add('round(%s, %s)' % (x, n))
for x in ['2.7', '-2.7', '0', '5', '0.999', '-0.1']:
    add('int(%s)' % x)
    add('abs(%s)' % x)
for x in ['2.789', '-2.789', '1234.5678']:
    for n in ['0', '1', '2']:
        add('truncate(%s, %s)' % (x, n))
for a, b in [('10', '3'), ('-10', '3'), ('10', '-3'), ('5.5', '2'), ('0', '5'), ('7', '7'), ('1000000', '7')]:
    add('mod(%s, %s)' % (a, b))
for x in ['1234.5', '0.1+0.2', '1/3', '100', '-0.5', '1234567890', '12345.6789', '0', '1.50', '10/4', '5*1.1']:
    add('string(%s)' % x)
for d in [D('2026-11-03'), 'DateTime(%s, %s)' % (D('2026-11-03'), T('05:09:13')), T('05:09:13'), T('23:59:59'), T('00:00:00')]:
    add('string(%s)' % d)
strs = [s('abcdef'), s('abc'), s(''), s('  padded  '), s('Hello wORLD')]
for x in strs:
    for f in ['len', 'upper', 'lower', 'trim', 'wordcap']:
        add('%s(%s)' % (f, x))
for n in ['0', '1', '3', '10']:
    add('left(%s, %s)' % (s('abcdef'), n))
    add('right(%s, %s)' % (s('abcdef'), n))
for a, b in [('2', '3'), ('1', '10'), ('5', '2'), ('7', '1'), ('0', '2')]:
    add('mid(%s, %s, %s)' % (s('abcdef'), a, b))
add('mid(%s, 3)' % s('abcdef'))
add('mid(%s, 10)' % s('abcdef'))
for a, b in [('abcabc', 'b'), ('abc', 'z'), ('abcabc', 'bc'), ('ABC', 'b'), ('abc', '')]:
    add('pos(%s, %s)' % (s(a), s(b)))
    add('lastpos(%s, %s)' % (s(a), s(b)))
add('pos(%s, %s, 3)' % (s('abcabc'), s('b')))
add('fill(%s, 5)' % s('ab'))
add('fill(%s, 0)' % s('ab'))
add('space(3) + %s' % s('x'))
add('char(65)')
add('char(97)')
for d in ['2026-11-03', '2000-02-29', '1999-12-31', '2026-01-01']:
    for f in ['year', 'month', 'day', 'dayname', 'daynumber']:
        add('%s(%s)' % (f, D(d)))
for a, b in [('2026-11-03', '2026-12-25'), ('2026-12-25', '2026-11-03'), ('2000-01-01', '2026-11-03'), ('2026-11-03', '2026-11-03')]:
    add('daysafter(%s, %s)' % (D(a), D(b)))
for d in ['2026-11-03', '2026-01-31', '2000-02-28']:
    for n in ['30', '-30', '1', '365']:
        add('string(relativedate(%s, %s), %s)' % (D(d), n, s('dd/mm/yyyy')))
for t in ['05:09:13', '23:59:59', '00:00:00', '12:00:00']:
    for f in ['hour', 'minute', 'second']:
        add('%s(%s)' % (f, T(t)))
add('secondsafter(%s, %s)' % (T('05:09:13'), T('05:10:00')))
add('secondsafter(%s, %s)' % (T('05:10:00'), T('05:09:13')))
for x in ['2026-11-03', '2026-11-3', '11/03/2026', '03/11/2026', '11/3/2026', '2026/11/03', '3-Nov-2026', '2026-13-45', 'abc', '']:
    add('string(Date(%s), %s)' % (s(x), s('yyyy-mm-dd')))
for x in ['5:09:13', '05:09', '5:09 PM', '23:59:59', '25:00:00', 'abc', '']:
    add('string(Time(%s), %s)' % (s(x), s('hh:mm:ss')))
for c, a, b in [('1=1', s('a'), s('b')), ('1=2', s('a'), s('b')), ('IsNull(1)', '1', '2'), ('3 > 2 and 2 > 1', '10', '20'), ('1=2 or 2=2', '10', '20')]:
    add('if(%s, %s, %s)' % (c, a, b))
for x in ['12.5', '12abc', 'abc', '1,234.5', '', ' 7 ', '-3.2', '1e3', '.5']:
    for f in ['double', 'long', 'integer', 'real', 'dec', 'number']:
        add('%s(%s)' % (f, s(x)))
add('case(2 when 1 then %s when 2 then %s else %s)' % (s('one'), s('two'), s('other')))
add('case(5 when 1 then %s else %s)' % (s('one'), s('other')))
for x in ['1+2*3', '10/4', '10/3', '2.5*4', '-7/2', '7 - 10', '1.1+2.2', '(1+2)*3', '5 > 3', '1 = 1', s('a') + ' + ' + s('b'), '3 - 1 - 1', '2 * 3 + 4', '0.1 * 3', '100 * 1.15']:
    add(x)
json.dump(E, open(S + '/exprs_fn.json', 'w'))
json.dump(["Evaluate('%s', 0)" % e for e in E], open(S + '/exprs.json', 'w'))
print(len(E))
