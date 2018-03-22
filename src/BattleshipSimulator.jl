using Plots


module BattleshipSimulator

using Plots

export layoutBoard, layoutBoard!, distributionBoard, distributionBoardHit
export drawBoard, drawBoardComp, drawHit, animateGame
export playManyUniqueGames, playManySingleGames, playManyGames
export randomHunter, targetHunter, distHunter

###############################################
#######  Board Layout and Placement  ##########
###############################################

# Create board positions
function layoutBoard(x::Int64,y::Int64; ships=[5,4,3,3,2])
    # Reset the matrix to all zeros
    M = zeros(Int64,x,y)
    Msize = (x,y)
    ship_counter = 0
    # Loop through ships and place on board
    for ship in ships
        placed = 0
        fit = [0, 0, 0, 0]
        ship_counter += 1
        while placed == 0
            trial = rand(find(.~M))
            checkShipFit!(fit,M,Msize,ship,trial)
            pickFit = rand([1 2 3 4]) # Pick a random orientation
            if fit[pickFit] > 0
                placeShip!(M,ship,ship_counter,trial,pickFit)
                placed = 1; #show(STDOUT, "text/plain", M); #println(" ")
            end
        end
    end
    return M
end


# Create board positions (reusing the same matrix)
function layoutBoard!(M::Array{Int64,2} ; ships=[5,4,3,3,2])
    # Reset the matrix to all zeros
    M[:] = 0
    Msize = size(M)
    ship_counter = 0
    # Loop through ships and place on board
    for ship in ships
        placed = 0
        fit = [0, 0, 0, 0]
        ship_counter += 1
        while placed == 0
            trial = rand(find(.~M))
            checkShipFit!(fit,M,Msize,ship,trial)
            pickFit = rand([1 2 3 4]) # Pick a random orientation
            if fit[pickFit] > 0
                placeShip!(M,ship,ship_counter,trial,pickFit)
                placed = 1; #show(STDOUT, "text/plain", M); #println(" ")
            end
        end
    end
end

# Check to see if the ship fits
function checkShipFit!(fit::Array{Int64,1},M::Array{Int64,2},Msize,ship::Int64,target::Int64)
    targetSub = ind2sub(M,target)
    fit[:] = 0
    (targetSub[2] + ship - 1) > Msize[2] ? fit[1] = 0 : (sum(M[targetSub[1],targetSub[2]:targetSub[2]+ship-1])    != 0 ? fit[1] = 0 : fit[1] = 1)
    (targetSub[1] - ship + 1) < 1        ? fit[2] = 0 : (sum(M[targetSub[1]:-1:(targetSub[1]-ship+1),targetSub[2]]) != 0 ? fit[2] = 0 : fit[2] = 1)
    (targetSub[2] - ship + 1) < 1        ? fit[3] = 0 : (sum(M[targetSub[1],targetSub[2]:-1:(targetSub[2]-ship+1)]) != 0 ? fit[3] = 0 : fit[3] = 1)
    (targetSub[1] + ship - 1) > Msize[1] ? fit[4] = 0 : (sum(M[targetSub[1]:targetSub[1]+ship-1,targetSub[2]])    != 0 ? fit[4] = 0 : fit[4] = 1)
end

# Check to see if the ship fits, but only in the vertical and horizontal directions
function checkShipFitVH!(fit::Array{Int64,1}, M::Array{Int64,2}, Msize, ship::Int64, target::Int64)
    targetSub = ind2sub(M,target)
    fit[:] = 0
    (targetSub[2] + ship - 1) > Msize[2] ? fit[1] = 0 : (sum(M[targetSub[1],targetSub[2]:targetSub[2]+ship-1])    != 0 ? fit[1] = 0 : fit[1] = 1)
    (targetSub[1] + ship - 1) > Msize[1] ? fit[2] = 0 : (sum(M[targetSub[1]:targetSub[1]+ship-1,targetSub[2]])    != 0 ? fit[2] = 0 : fit[2] = 1)
end
# Check to see if the ship fits given a hit has occured, but only in the vertical and horizontal directions
function checkShipFitHitVH!(fit::Array{Int64,1}, M::Array{Int64,2}, Msize, ship::Int64, target::Int64)
    targetSub = ind2sub(M,target)
    fit[:] = 0
    hits = find(M==-1)
    M[hits] = 0
    if !((targetSub[2] + ship - 1) > Msize[2])
        M[hits] = -1
        sum(M[targetSub[1],targetSub[2]:targetSub[2]+ship-1]) < 0 ? fit[1] = 1 : fit[1] = 0
        M[hits] = 0
    end
    if !((targetSub[1] + ship - 1) > Msize[1])
        M[hits] = -1
        sum(M[targetSub[1]:targetSub[1]+ship-1,targetSub[2]]) < 0 ? fit[2] = 1 : fit[2] = 0
    end
    M[hits] = -1
end

# Update the grid to place the ship
function placeShip!(M::Array{Int64,2},ship::Int64,shipVal::Int64,target::Int64,orientation::Int64)
    targetSub = ind2sub(M,target)
    if orientation == 1
       M[targetSub[1],targetSub[2]:targetSub[2]+ship-1] += shipVal
    elseif orientation == 2
        M[targetSub[1]:-1:targetSub[1]-ship+1,targetSub[2]] += shipVal
    elseif orientation == 3
        M[targetSub[1],targetSub[2]:-1:targetSub[2]-ship+1] += shipVal
    elseif orientation == 4
        M[targetSub[1]:targetSub[1]+ship-1,targetSub[2]] += shipVal
    end
end


###############################################
##########  Board Distributions  ##############
###############################################

# Create board distribution
function distributionBoard(S::Array{Int64,2} ; ships=[5,4,3,3,2])
    Ssize = size(S)
    D = zeros(Int64,Ssize)
    # Loop through ships and place on board
    for ship in ships
        fit = [0, 0]
        for i = 1:length(S)
            checkShipFitVH!(fit,S,Ssize,ship,i)
            if fit[1] == 1; placeShip!(D,ship,1,i,1); end
            if fit[2] == 1; placeShip!(D,ship,1,i,4); end
        end
    end
    return D
end

# Create board distribution (reuse the same distribution matrix)
function distributionBoard!(D::Array{Int64,2},S::Array{Int64,2} ; ships=[5,4,3,3,2])
    # Reset the matrix to all zeros
    D[:] = 0
    Ssize = size(S)
    # Loop through ships and place on board
    for ship in ships
        fit = [0, 0]
        for i = 1:length(S)
            checkShipFitVH!(fit,S,Ssize,ship,i)
            if fit[1] == 1; placeShip!(D,ship,1,i,1); end
            if fit[2] == 1; placeShip!(D,ship,1,i,4); end
        end
    end
end

# Create board distribution for when a hit has occurred
function distributionBoardHit(S::Array{Int64,2}; ships=[5,4,3,3,2], shipsAvail=[5,4,3,3,2])
    Ssize = size(S)
    D = zeros(Int64,Ssize)
    # Loop through ships and place on board
    for ship in shipsAvail
        fit = [0, 0]
        for i = 1:length(S)
            checkShipFitHitVH!(fit,S,Ssize,ship,i)
            if fit[1] == 1; placeShip!(D,ship,1,i,1); end
            if fit[2] == 1; placeShip!(D,ship,1,i,4); end
        end
    end
    return D
end

# Create board distribution for when a hit has occurred (reuse matrix)
function distributionBoardHit!(D::Array{Int64,2}, S::Array{Int64,2}; ships=[5,4,3,3,2], shipsAvail=[5,4,3,3,2])
    # Reset the matrix to all zeros
    D[:] = 0
    Ssize = size(S)
    # Loop through ships and place on board
    for ship in shipsAvail
        fit = [0, 0]
        for i = 1:length(S)
            checkShipFitHitVH!(fit,S,Ssize,ship,i)
            if fit[1] == 1; placeShip!(D,ship,1,i,1); end
            if fit[2] == 1; placeShip!(D,ship,1,i,4); end
        end
    end
end



###############################################
#########  Draw Boards and Hits  ##############
###############################################

function drawBoard(M; flatten=false)
    if flatten == true
        plt = heatmap(M.>0,colorbar=false,aspectratio=:equal,axis=false,dpi=20,grid=true,gridcolor=:white,color=:blues)
    else
        plt = heatmap(M,colorbar=false,aspectratio=:equal,axis=false,dpi=20,grid=true,gridcolor=:white,color=:blues)
    end
    return plt
end

function drawBoardComp(M, D; name1="First", name2="Second", flatten=false)
    if flatten == true
        p1 = heatmap(M.>0,colorbar=false,aspectratio=:equal,axis=false,dpi=20,title=name1)
        p2 = heatmap(D.>0,colorbar=false,aspectratio=:equal,axis=false,dpi=20,title=name2)
    else
        p1 = heatmap(M,colorbar=false,aspectratio=:equal,axis=false,dpi=20,title=name1)
        p2 = heatmap(D,colorbar=false,aspectratio=:equal,axis=false,dpi=20,title=name2)
    end
    plt = plot(p1,p2, layout=(1,2), legend=false)
    return plt
end

function drawHit(target,M)
    targetSub = ind2sub(M,target)
    if M[target] > 0
        plot!([targetSub[2]],[targetSub[1]],seriestype=:scatter, markersize = 15, markershape = :circle, c=RGB(1,0,0),legend=false,alpha=1)
    else
        plot!([targetSub[2]],[targetSub[1]],seriestype=:scatter, markersize = 10, markershape = :xcross, c=RGB(1,0,0),legend=false,alpha=1)
    end
end

function animateGame(M,hits)
    drawBoard(M)
    drawHit(hits[1],M)
    anim = @animate for i = 1:length(hits)
            drawHit(hits[i],M)
        end
    return anim
end

###############################################
############  Play Many Games  ################
###############################################

# Create a new board every time you simulate, but only play the board once
function playManyUniqueGames(M,N,; hunt=randomHunter, ships=[5,4,3,3,2])
    winTime = zeros(Int64,N)
    for i = 1:N
        layoutBoard!(M; ships = ships)
        output = hunt(M; ships = ships)
        winTime[i] = length(output)
    end
    return winTime
end

# Simulate many games with a single board layout
function playManySingleGames(M,N,; hunt=randomHunter, ships=[5,4,3,3,2])
    winTime = zeros(Int64,N)
    for i = 1:N
        output = hunt(M; ships = ships)
        winTime[i] = length(output)
    end
    return winTime
end

# Create a new board and simulate many games with it
function playManyGames(M,N,P; hunt=randomHunter, ships=[5,4,3,3,2])
    winTime = zeros(Int64,P,N)
    for i = 1:N
        layoutBoard!(M; ships = ships)
        winTime[:,i] = playManySingleGames(M,N; hunt = hunt, ships = ships)
    end
    return winTime
end


###############################################
###########  Hunting Strategies  ##############
###############################################

# A simple but dumb random hunter
function randomHunter(M; ships = [5,4,3,3,2])
    numTargets = sum(M[:].>0)  # This is always known information
    availSpots = collect(1:length(M))
    hitSpots = Array{Int64,1}()
    numHitTargets = 0
    while numHitTargets != numTargets
        targ = rand(find(availSpots))
        availSpots[targ] = 0
        if M[targ] > 0; numHitTargets += 1; end
        append!(hitSpots,targ)
    end
    return hitSpots
end

# A slightly more sophisticated hunter, which eliminates a ship once found
# This strategy does not use ship information explicitly
function targetHunter(M;  ships = [5,4,3,3,2])
    numTargets = sum(M[:].>0)  # This is always known information
    availSpots = collect(1:length(M))
    hitSpots = Array{Int64,1}()
    toHit = Array{Int64,1}()
    numHitTargets = 0
    Msize = size(M)
    while numHitTargets != numTargets
        if length(toHit) == 0
            targ = rand(find(availSpots))
        else
            targ = pop!(toHit)
        end
        targSub = ind2sub(M,targ)
        availSpots[targ] = 0
        append!(hitSpots,targ)
        if M[targ] > 0
            numHitTargets += 1
            targSub = ind2sub(M,targ)
            if ((targSub[2] + 1) <= Msize[2]) && ~(in(sub2ind(Msize,targSub[1],targSub[2]+1),hitSpots))
                append!(toHit,sub2ind(Msize,targSub[1],targSub[2]+1))
            end
            if ((targSub[1] - 1) > 0) && ~(in(sub2ind(Msize,targSub[1]-1,targSub[2]),hitSpots))
                append!(toHit,sub2ind(Msize,targSub[1]-1,targSub[2]))
            end
            if ((targSub[2] - 1) > 0) && ~(in(sub2ind(Msize,targSub[1],targSub[2]-1),hitSpots))
                append!(toHit,sub2ind(Msize,targSub[1],targSub[2]-1))
            end
            if ((targSub[1] + 1) <= Msize[1]) && ~(in(sub2ind(Msize,targSub[1]+1,targSub[2]),hitSpots))
                append!(toHit,sub2ind(Msize,targSub[1]+1,targSub[2]))
            end
            toHit = unique(toHit)
        end
    end
    return hitSpots
end

# Use distribution of possible remaining ships to identify the most likely spots
# in grid to target.  This function DOES use ship information explicitly
# This function is not currently working correctly.
function distHunter(M;  ships = [5,4,3,3,2])
    numTargets = sum(M[:].>0)  # This is always known information
    hitSpots = Array{Int64,1}()
    stuck_counter = 0
    numHitTargets = 0
    shipsAvail = deepcopy(ships)
    Msize = size(M)
    S = zeros(Int64,Msize)
    D = zeros(Int64,Msize)
    while numHitTargets != numTargets
        distributionBoard!(D,S; ships=[5,4,3,3,2])
        temp = findmax(D)
        targ = temp[2]
        append!(hitSpots,targ)
        if M[targ] == 0
            S[targ] = 1
        else
            numHitTargets += 1
            shipTypes_orig = setdiff(unique(M[S.==0]),[0])
            numShipsLeft_orig = length(shipTypes_orig)
            S[targ] = -1;
            (length(setdiff(unique(M[S.==0]),[0]))) < numShipsLeft_orig ? sunk = 1 : sunk = 0
            while (sunk == 0) && (numHitTargets != numTargets)
                distributionBoardHit!(D, S; ships=ships, shipsAvail=shipsAvail)
                D[S.==-1] = 0; D[S.==1] = 0;
                temp = findmax(D)
                targ = temp[2]
                #println(targ)
                append!(hitSpots,targ)
                M[targ] > 0 ? (S[targ] = -1; numHitTargets += 1) : S[targ] = 1
                if ((length(unique(M[S.==0])) - 1) < numShipsLeft_orig)
                    sunk = 1
                end
                #show(STDOUT, "text/plain", S); println(" ")
                #println("STUCK! - ",stuck_counter); stuck_counter += 1
            end
            S[find(S.==-1)] = 1
            shipTypes = setdiff(unique(M[S.==0]),[0])
            shipsAvail = ships[shipTypes]
        end
        #show(STDOUT, "text/plain", S); println(" ")
        #println("STUCK! - ",stuck_counter); stuck_counter += 1
    end
    return hitSpots
end



end # module
