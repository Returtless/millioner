//
//  Game.swift
//  millioner
//
//  Created by Владислав Лихачев on 28.07.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation

class Game {
    var session: GameSession?
    private(set) var records: [Record] = []

    static let shared = Game()
    
    private init() { }
    
    func addRecord(_ currentCount: Int, _ allCount: Int) {
        self.records.append(Record(date: Date(), score: Double(currentCount/allCount)))
    }
    
    func clearRecords() {
        self.records = []
    }

}

struct Record {
    let date: Date
    let score: Double
}
