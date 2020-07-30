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

class DataService {
    static func getServerData(qType:Int, count:Int) {
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
                                        let array: [Question]? = res.data
   
                                       } catch {
                                           print("error")
                                       }
        }
    }
}
