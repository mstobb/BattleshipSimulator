# BattleshipSimulator

[![Build Status](https://travis-ci.org/mstobb/BattleshipSimulator.jl.svg?branch=master)](https://travis-ci.org/mstobb/BattleshipSimulator.jl)

[![Coverage Status](https://coveralls.io/repos/mstobb/BattleshipSimulator.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/mstobb/BattleshipSimulator.jl?branch=master)

[![codecov.io](http://codecov.io/github/mstobb/BattleshipSimulator.jl/coverage.svg?branch=master)](http://codecov.io/github/mstobb/BattleshipSimulator.jl?branch=master)

A fun package to create random board layouts and simulate play for the classic game Battleship with arbitrary grid and ship sizes.  

Typical usage might be:
```julia
# Create a random 10x10 board with the classic ship lengths
M = layoutBoard(10,10)

# Visualize the board
drawBoard(M)

# Play the board once with a random hunt strategy
hits_rand = randomHunter(M)

# Animate the random game
anim = animateGame(M,hits_rand)
gif(anim,"./anim_random.gif", fps = 2) # save animation to gif

# Play the same board 10_000 times with the random hunt strategy
hits_many_rand = playManySingleGames(M, 10_000; hunt=randomHunter)

# Check out the distribution of game lengths
histogram(hits_many_rand, normed=true)
```

The whole point is just exploration, so feel free to add new strategies or try different board layouts.  


