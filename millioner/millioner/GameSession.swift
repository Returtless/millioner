//
//  GameSession.swift
//  millioner
//
//  Created by Владислав Лихачев on 28.07.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation

class GameSession{
    var currentQuestion : Int = 0
    var countRightAnswers: Int = 0
    var countAllQuestions : Int = 10
    var hints : [Hints] = [.fiftyFifty, .friendsHelp, .hallHelp]
}

enum Hints : String{
    case fiftyFifty = "50 на 50"
    case friendsHelp = "Звонок другу"
    case hallHelp = "Помощь зала"
}
