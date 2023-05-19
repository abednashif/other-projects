//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Abed Nashif on 07/03/2022.
//

import SwiftUI

struct AlertItem: Identifiable{
    
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext{
   static let humanWin = AlertItem(title: Text("You Win!"),
                             message: Text("Damn!!"),
                             buttonTitle: Text("Try again"))
    
   static  let computerWin = AlertItem(title: Text("You Lost!"),
                             message: Text("This AI is scary."),
                             buttonTitle: Text("Try again"))
    
   static let draw = AlertItem(title: Text("Draw"),
                             message: Text("What a battle that was"),
                             buttonTitle: Text("Try again"))
}
