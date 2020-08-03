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
}

