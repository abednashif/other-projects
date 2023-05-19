//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Abed Nashif on 09/03/2022.
//

import SwiftUI


final class GameViewModel:ObservableObject{
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem:AlertItem?
    
    
    func processPlayerMove(for position: Int){
        //human move processing
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        
            //check for win condition
        if checkWinCondition(for: .human, in: moves){
            alertItem = AlertContext.humanWin
            return
            
        }
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            return
        }
        isGameBoardDisabled = true
        
        //computer moves processing
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPos = determineComputerMovePos(in: moves)
            moves[computerPos] = Move(player: .computer, boardIndex: computerPos)
            isGameBoardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves){
                alertItem = AlertContext.computerWin
                return
            }
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    
    //if AI can win, then win
    //if AI can't win, then block
    //if AI can't block, then take middle square
    //if AI can't take middle square, take random available square
    
    
    func determineComputerMovePos(in moves: [Move?]) -> Int{
        
        //if AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[8,3,6],
                                          [1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let computerMoves = moves.compactMap{ $0 }.filter{ $0.player == .computer }
        let computerPositions = Set(computerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPos = pattern.subtracting(computerPositions)
            
            if winPos.count == 1{
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPos.first!)
                if isAvailable{ return winPos.first! }
            }
        }
        
        //if AI can't win, then block
        
        let humanMoves = moves.compactMap{ $0 }.filter{ $0.player == .human
        }
        let humanPositions = Set(humanMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPos = pattern.subtracting(humanPositions)
            
            if winPos.count == 1{
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPos.first!)
                if isAvailable{ return winPos.first! }
            }
        }
        
        
        //if AI can't block, then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare){
            return centerSquare
        }
        
        //if AI can't take middle square, take random available square
        var movePos = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePos){
            movePos = Int.random(in: 0..<9)
        }
        return movePos
    }
    
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool{
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[8,3,6],
                                          [1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap{ $0 }.filter{ $0.player == player }
        let playerPositions = Set(playerMoves.map{ $0.boardIndex } )
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){return true }
        
        return false;
    }
    func checkForDraw(in moves: [Move?]) -> Bool{
        return moves.compactMap{ $0 }.count == 9
    }
    
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
}
