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
    var hintUsageFacade : HintUsageFacade?
    
    private var difficulty : Difficulty = .easy
    
    private var difficultyStrategy: GameDifficultyStrategy {
        switch self.difficulty {
        case .easy:
            return EasyGameDifficultyStrategy()
        case .medium:
            return MediumGameDifficultyStrategy()
        case .hard:
            return HardGameDifficultyStrategy()
        }
    }
    
    init(by difficulty: Int) {
        setDifficulty(diff: difficulty)
        difficultyStrategy.getQuestions() { [weak self] array in
            guard let self = self else { return }
            self.questions.value.append(contentsOf: array!)
                        self.currentQuestion.value = 0
        }
        currentQuestion.addObserver(self, options: [.new, .initial], closure: { [weak self] (current, _) in
            if self!.currentQuestion.value < self!.countAllQuestions {
                self!.hintUsageFacade = HintUsageFacade()
                self!.hintUsageFacade?.question = self!.questions.value[self!.currentQuestion.value]
            }
        })
    }
    
    func getCurrentQuestionNumber() -> String{
        return "Вопрос \(currentQuestion.value+1) из \(countAllQuestions)"
    }
    
    func setDifficulty(diff: Int) {
        switch diff {
           case 0:
               self.difficulty = .easy
           case 1:
               self.difficulty = .medium
           case 2:
               self.difficulty = .hard
           default:
               self.difficulty = .easy
           }
    }
}

enum Hints : String{
    case fiftyFifty = "50 на 50"
    case friendsHelp = "Звонок другу"
    case hallHelp = "Помощь зала"
}

enum Difficulty {
    case easy, medium, hard
}

