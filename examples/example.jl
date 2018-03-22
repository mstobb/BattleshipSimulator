# Create a random 10x10 board with the classic ship lengths
M = layoutBoard(10,10)

# Visualize the board
drawBoard(M)

# Play the board once with a random hunt strategy
hits_rand = randomHunter(M)

# Animate the random game
anim = animateGame(M,hits_rand)
gif(anim,"./anim_random.gif", fps = 2) # save animation to gif

# Play with the search and destroy strategy
hits_target = targetHunter(M)

# Animate the random game
anim = animateGame(M,hits_target)
gif(anim,"./anim_target.gif", fps = 2) # save animation to gif

# Play the same board 10_000 times with the random hunt strategy
hits_many_rand = playManySingleGames(M, 10_000; hunt=randomHunter)

# Check out the distribution of game lengths
histogram(hits_many_rand, normed=true)

# Play the same board 10_000 times with the random hunt strategy
hits_many_target = playManySingleGames(M, 10_000; hunt=targetHunter)

# Check out the distribution of game lengths
histogram(hits_many_target, normed=true)

# See the distribution of ways to add two more ships (length 2 and 3) to the current board
S = distributionBoard(M; ships=[2,3])


