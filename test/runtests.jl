using BattleshipSimulator
using Base.Test

@test typeof(layoutBoard(10,10)) == Array{Int64,2}
