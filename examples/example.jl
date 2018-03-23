using BattleshipSimulator

gr()

# Create a random 10x10 board with the classic ship lengths
ship_lengths = [5,4,3,3,2]
M = layoutBoard(10,10; ships=ship_lengths)

# Create the distribution of all possible ship placements
D = distributionBoard(zeros(Int64,size(M)); ships=ship_lengths)

# Visualize the board and the distribution of possible ships
drawBoardComp(M,D; name1 = "True Hidden Map", name2="Distribution of Possible Ships")
savefig("./Random_Board_Layout_and_Ship_Distribution.png")

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

# Play with the distribution hunter
hits_dist = distHunter(M)

# Animate the random game
anim = animateGame(M,hits_dist)
gif(anim,"./anim_dist.gif", fps = 2) # save animation to gif

# Play the same board 100_000 times with the random hunt strategy (about 5s on my machine)
@time hits_many_rand = playManySingleGames(M, 100_000; hunt=randomHunter)

# Check out the distribution of game lengths
histogram(hits_many_rand, normed=true, xlabel="Hits Needed to Win",ylabel="Probability", legend=(:none),xlim=(0,length(M)))
savefig("./dist_hits_many_rand.png")

# Play the same board 10_000 times with the random hunt strategy (about 5s on my machine)
@time hits_many_target = playManySingleGames(M, 100_000; hunt=targetHunter)

# Check out the distribution of game lengths
histogram(hits_many_target, normed=true, xlabel="Hits Needed to Win",ylabel="Probability", legend=(:none),xlim=(0,length(M)))
savefig("./dist_hits_many_target.png")
