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
    private(set) var records: [Record] {
        didSet {
            recordsCaretaker.save(records: self.records)
        }
    }
    private let recordsCaretaker = RecordsCaretaker()
    
    static let shared = Game()
    
    private init() {
        self.records = self.recordsCaretaker.retrieveRecords()
    }
    
    func addRecord(_ currentCount: Int, _ allCount: Int) {
        self.records.append(Record(date: Date(), score: Double(currentCount)/Double(allCount)))
    }
    
    func clearRecords() {
        self.records = []
    }

}
