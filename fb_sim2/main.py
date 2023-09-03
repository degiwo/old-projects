from player import Player
from match import Match

p1 = Player()
p2 = Player(95)
match = Match([p1], [p2])
result = match.get_final_result()
print(result)
