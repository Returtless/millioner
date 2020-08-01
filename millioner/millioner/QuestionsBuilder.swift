//
//  QuestionsBuilder.swift
//  millioner
//
//  Created by Владислав Лихачев on 01.08.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation

class QuestionsBuilder {
    private(set) var question: String = ""
    private(set) var rightAnswer: Int = 0
    private(set) var answers: [String] = []
    private(set) var difficulty: Int = 1
    
    func build() -> Question {
        return Question(question: question, answers: answers, id: rightAnswer, difficulty: difficulty)
    }
    
    func setQuestion(_ question: String) {
        self.question = question
    }
    
    func setRightAnswer(_ rightAnswer: Int) {
        self.rightAnswer = rightAnswer
    }
    
    func setDifficulty(_ difficulty: Int) {
        self.difficulty = difficulty
    }
    
    func addAnswer(_ answer: String) {
        answers.append(answer)
    }
}
