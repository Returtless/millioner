//
//  QuestionsCaretaker.swift
//  millioner
//
//  Created by Владислав Лихачев on 01.08.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation

final class QuestionsCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "questions"
    
    func save(questions: [Question]) {
        do {
            var oldQuestions = retrieveQuestions()
            oldQuestions.append(contentsOf: questions)
            let data = try self.encoder.encode(oldQuestions)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieveQuestions() -> [Question] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        do {
            return try self.decoder.decode([Question].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
}
