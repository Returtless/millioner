//
//  Question.swift
//  millioner
//
//  Created by Владислав Лихачев on 28.07.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import Alamofire

struct Questions: Codable {
    var data: [Question]
}

// MARK: - Datum
struct Question: Codable {
    var question: String
    var answers: [String]
    var id: Int
    var difficulty: Int = 1
    
    init(question: String = "", answers: [String] = [], id: Int = 0, difficulty: Int = 1) {
        self.question = question
        self.answers = answers
        self.id = id
        self.difficulty = difficulty
    }
    
    enum CodingKeys: String, CodingKey {
        case question, answers, id
    }
}

