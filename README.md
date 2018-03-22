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

Here are the three currently implemented strategies for the same random board:

- Random hunt: A random square is drawn each step.  This is very slow and generally takes hitting nearly every available square to win.

![random hunt.](https://raw.githubusercontent.com/mstobb/BattleshipSimulator/master/examples/anim_random.gif)

- Search and Destroy: Once a ship is found, it and any connected ships are systemically hunted down and destroyed.  I think of this as the classic strategy used by most people.
![target hunt.](https://raw.githubusercontent.com/mstobb/BattleshipSimulator/master/examples/anim_target.gif)

- Most Likely Square: A distribution is possible ship placements is updated every step.  This is probably the smartest strategy as it directly uses information on previously destroyed ships.
![distribution hunt.](https://raw.githubusercontent.com/mstobb/BattleshipSimulator/master/examples/anim_dist.gif)
