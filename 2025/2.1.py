def read(path):
    with open(path) as f:
        ranges = [r.split('-') for r in f.read().split(',')]
    return ranges

def count_digits(ranges):
    return [[len(lim) for lim in r] for r in ranges]

def intify(ranges):
    return [[int(lim) for lim in r] for r in ranges]

def clamp(ranges, n_digits):
    clamped = []
    clamped_n_digits = []
    for r, n in zip(ranges, n_digits):
        if n[0] % 2 == 1:
            if n[1] % 2 == 1:
                if n[0] == n[1]:
                    # Entire range is valid
                    continue
                # Clamping both top and bottom
                clamped.append([10**n[0], 10**(n[1]-1)-1])
                clamped_n_digits.append([n[0]+1, n[1]-1])
            else:
                # Clamping bottom
                clamped.append([10**n[0], r[1]])
                clamped_n_digits.append([n[0]+1, n[1]])
        elif n[1] % 2 == 1:
            # Clamping top
            clamped.append([r[0], 10**(n[1]-1)-1])
            clamped_n_digits.append([n[0], n[1]-1])
        else:
            # No clamping
            clamped.append(r)
            clamped_n_digits.append(n)
    return clamped, clamped_n_digits

def split(ranges, n_digits):
    return [[r[0] // 10**(n//2), r[1] // 10**(n//2)] for r, n in zip(ranges, n_digits)]

def in_range(x, r):
    return r[0] <= x <= r[1]

def check(a, b, n, r):
    global count
    matches = []
    factor = 10**(n//2)
    for x in range(a, b+1):
        count += 1
        xx = x*factor + x
        if in_range(xx, r):
            matches.append(xx)
    return matches

def check_ranges(most_significant, clamped, clamped_n_digits):
    matches = []
    for (a,b), r, n in zip(most_significant, clamped, clamped_n_digits):
        matches += check(a, b, n, r)
    return matches

def length(int_ranges):
    return [r[1] - r[0] for r in int_ranges]


def solve(path):
    ranges = read(path)
    n_digits = count_digits(ranges)
    int_ranges = intify(ranges)
    # We know that the number of digits must be even inorder to contain an invalid id
    clamped, clamped_n_digits = clamp(int_ranges, n_digits)

    assert all((n[0] == n[1] for n in clamped_n_digits))
    clamped_n_digits = [n[0] for n in clamped_n_digits]

    most_significant = split(clamped, clamped_n_digits)
    matches = check_ranges(most_significant, clamped, clamped_n_digits)
    print(sum(length(int_ranges)), 'candidates')
    return sum(matches)

print('Sample')
count = 0
result = solve('inputs/2.sample.txt')
print('Checked', count, 'candidates')
print('Answer:', result, "\n")

print('Real')
count = 0
result = solve('inputs/2.txt')
print('Checked', count, 'candidates')
print('Answer:', result)
