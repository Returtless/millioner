//
//  GameSession.swift
//  millioner
//
//  Created by Владислав Лихачев on 28.07.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation

class GameSession{
    var questions = Observable<[Question]>([])
    var currentQuestion = Observable<Int>(0)
    var countRightAnswers: Int = 0
    var countAllQuestions : Int {
        questions.value.count
    }
    var hints : [Hints] = [.fiftyFifty, .hallHelp, .friendsHelp]
    
    init() {
        DataService.getServerData(qType: 2,count: 5) { [weak self] array in
            guard let self = self else { return }
            self.questions.value.append(contentsOf: array!)
        }
    }
    
    func getCurrentQuestionNumber() -> String{
        return "Вопрос \(currentQuestion.value+1) из \(countAllQuestions)"
    }
}

enum Hints : String{
    case fiftyFifty = "50 на 50"
    case friendsHelp = "Звонок другу"
    case hallHelp = "Помощь зала"
}
