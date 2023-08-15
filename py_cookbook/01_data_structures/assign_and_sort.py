data = ['xyz', 'abc', 2, 9.8]

# Unpacking
w, x, y, z = data
print(w, x, y, z)

# Arbitrary Length
_, *tail = data
print(tail)

# Fixed length list
from collections import deque

l = deque(maxlen=3)
l.append(0)
l.append(1)
l.append(2)
l.append(3)
print(l)

# The largest N elements
import heapq

num = [0, 1, 8, 4.5, 3, 10]
print(heapq.nlargest(2, num))

num.sort()
print(num[-2:])
