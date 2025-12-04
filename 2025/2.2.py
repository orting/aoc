def read(path):
    with open(path) as f:
        ranges = [r.split('-') for r in f.read().split(',')]
    return ranges

def intify(ranges):
    return [[int(lim) for lim in r] for r in ranges]

def length(int_ranges):
    return [r[1] - r[0] for r in int_ranges]

def check_number(x):
    t = str(x)
    n = len(t) // 2
    for i in range(1, n+1):
        if is_repeated(t[:i], t[i:]):
            return True
    return False

def is_repeated(s, t):
    n = len(s)
    m = len(t)
    if m % n != 0:
        # length of s must divide length of t
        return False
    return all([s == t[i:i+n] for i in range(0, m, n)])

def check_range(r):
    matches = []
    for x in range(r[0], r[1]+1):
        if check_number(x):
            matches.append(x)
    return matches

def solve(path):
    ranges = read(path)
    int_ranges = intify(ranges)
    matches = []
    for r in int_ranges:
        matches += check_range(r)
    return sum(matches)

print('Sample:', solve('inputs/2.sample.txt'))
print('Real:', solve('inputs/2.txt'))
