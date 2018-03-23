# BattleshipSimulator.jl

[![Build Status](https://travis-ci.org/mstobb/BattleshipSimulator.jl.svg?branch=master)](https://travis-ci.org/mstobb/BattleshipSimulator.jl)

[![Coverage Status](https://coveralls.io/repos/mstobb/BattleshipSimulator.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/mstobb/BattleshipSimulator.jl?branch=master)

[![codecov.io](http://codecov.io/github/mstobb/BattleshipSimulator.jl/coverage.svg?branch=master)](http://codecov.io/github/mstobb/BattleshipSimulator.jl?branch=master)

A fun package to create random board layouts and simulate play for the classic game Battleship with arbitrary grid and ship sizes.  This was inspired by the awesome [blog post](http://www.datagenetics.com/blog/december32011/) on Battleship by Nick Berry, but all of the code is original.

To install this package, use the following command in Julia:
```julia
Pkg.clone("git:github.com/mstobb/BattleshipSimulator.jl.git")
```

Typical usage might be:
```julia
using BattleshipSimulator

# Create a random 10x10 board with the classic ship lengths
ship_lengths = [5,4,3,3,2]
M = layoutBoard(10,10; ships=ship_lengths)

# Create the distribution of all possible ship placements
D = distributionBoard(zeros(Int64,size(M)); ships=ship_lengths)

# Visualize the board and the distribution of possible ships
drawBoardComp(M,D; name1 = "True Hidden Map", name2="Distribution of Possible Ships")
```
![Board layout and distribution.](https://raw.githubusercontent.com/mstobb/BattleshipSimulator/master/examples/Random_Board_Layout_and_Ship_Distribution.png)
```julia
# Play the board once with a random hunt strategy
hits_rand = randomHunter(M)

# Animate the random game
anim = animateGame(M,hits_rand)
gif(anim,"./anim_random.gif", fps = 2)
```
![random hunt.](https://raw.githubusercontent.com/mstobb/BattleshipSimulator/master/examples/anim_random.gif)
```julia
# Play with the search and destroy strategy
hits_target = targetHunter(M)

# Animate the random game
anim = animateGame(M,hits_target)
gif(anim,"./anim_target.gif", fps = 2)
```
![target hunt.](https://raw.githubusercontent.com/mstobb/BattleshipSimulator/master/examples/anim_target.gif)
```julia
# Play with the distribution hunter
hits_dist = distHunter(M)

# Animate the random game
anim = animateGame(M,hits_dist)
gif(anim,"./anim_dist.gif", fps = 2)
```
![distribution hunt.](https://raw.githubusercontent.com/mstobb/BattleshipSimulator/master/examples/anim_dist.gif)
```julia
# Play the same board 100_000 times with the random hunt strategy (~5s on my machine)
@time hits_many_rand = playManySingleGames(M, 100_000; hunt=randomHunter)

# Check out the distribution of game lengths
histogram(hits_many_rand, normed=true, xlabel="Hits Needed to Win",
          ylabel="Probability", legend=(:none), xlim=(0,length(M)))
```
![Histogram for random hunter.](https://raw.githubusercontent.com/mstobb/BattleshipSimulator/master/examples/dist_hits_many_rand.png)
```julia
# Play the same board 10_000 times with the random hunt strategy (~5s on my machine)
@time hits_many_target = playManySingleGames(M, 100_000; hunt=targetHunter)

# Check out the distribution of game lengths
histogram(hits_many_target, normed=true, xlabel="Hits Needed to Win",
          ylabel="Probability", legend=(:none), xlim=(0,length(M)))
```
![Histogram for random hunter.](https://raw.githubusercontent.com/mstobb/BattleshipSimulator/master/examples/dist_hits_many_target.png)

The whole point is just exploration, so feel free to add new strategies or try different board layouts.  
