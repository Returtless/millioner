//
//  GameDifficultyStrategy.swift
//  millioner
//
//  Created by Владислав Лихачев on 29.07.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation
import Alamofire

protocol GameDifficultyStrategy {
    func getQuestions(completion: @escaping (_ array : [Question]?) -> Void)
}

final class EasyGameDifficultyStrategy: GameDifficultyStrategy {
    func getQuestions(completion: @escaping (_ array : [Question]?) -> Void){
      let questionsCaretaker = QuestionsCaretaker()
        completion(questionsCaretaker.retrieveQuestions())
    }
}

final class MediumGameDifficultyStrategy: GameDifficultyStrategy {
    func getQuestions(completion: @escaping (_ array : [Question]?) -> Void){
        let params: Parameters = [
               "qType": 2,
               "count": 5
           ]
           AF.request("https://engine.lifeis.porn/api/millionaire.php",
                      parameters: params).responseJSON{ response in
                       print(response)
                       guard let data = response.data else { return }
                       do {
                           let res = try JSONDecoder().decode(Questions.self, from: data)
                           var array: [Question]? = res.data
                           if let questions = array {
                               for i in 0..<questions.count {
                                   let rightAnswer = questions[i].answers[0]
                                   array![i].answers.shuffle()
                                   array![i].id = array![i].answers.firstIndex(of: rightAnswer)!
                               }
                           }
                           completion(array)
                       } catch let DecodingError.dataCorrupted(context) {
                           print(context)
                       } catch let DecodingError.keyNotFound(key, context) {
                           print("Key '\(key)' not found:", context.debugDescription)
                           print("codingPath:",  context.codingPath)
                       } catch let DecodingError.valueNotFound(value, context) {
                           print("Value '\(value)' not found:", context.debugDescription)
                           print("codingPath:", context.codingPath)
                       } catch let DecodingError.typeMismatch(type, context)  {
                           print("Type '\(type)' mismatch:", context.debugDescription)
                           print("codingPath:", context.codingPath)
                       } catch {
                           print("error: ", error)
                       }
           }
    }
}

final class HardGameDifficultyStrategy: GameDifficultyStrategy {
    func getQuestions(completion: @escaping (_ array : [Question]?) -> Void){
        let params: Parameters = [
               "qType": 3,
               "count": 5
           ]
           AF.request("https://engine.lifeis.porn/api/millionaire.php",
                      parameters: params).responseJSON{ response in
                       print(response)
                       guard let data = response.data else { return }
                       do {
                           let res = try JSONDecoder().decode(Questions.self, from: data)
                           var array: [Question]? = res.data
                           if let questions = array {
                               for i in 0..<questions.count {
                                   let rightAnswer = questions[i].answers[0]
                                   array![i].answers.shuffle()
                                   array![i].id = array![i].answers.firstIndex(of: rightAnswer)!
                               }
                           }
                           completion(array)
                       } catch let DecodingError.dataCorrupted(context) {
                           print(context)
                       } catch let DecodingError.keyNotFound(key, context) {
                           print("Key '\(key)' not found:", context.debugDescription)
                           print("codingPath:",  context.codingPath)
                       } catch let DecodingError.valueNotFound(value, context) {
                           print("Value '\(value)' not found:", context.debugDescription)
                           print("codingPath:", context.codingPath)
                       } catch let DecodingError.typeMismatch(type, context)  {
                           print("Type '\(type)' mismatch:", context.debugDescription)
                           print("codingPath:", context.codingPath)
                       } catch {
                           print("error: ", error)
                       }
           }
    }
}
