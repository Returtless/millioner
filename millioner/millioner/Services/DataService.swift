//
//  DataService.swift
//  millioner
//
//  Created by Владислав Лихачев on 29.07.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation
import Alamofire

class DataService {
    static func getServerData(qType:Int, count:Int, completion: @escaping (_ array : [Question]?) -> Void) {
        let params: Parameters = [
            "qType": qType,
            "count": count
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
                    } catch {
                        print("error")
                    }
        }
    }
}
