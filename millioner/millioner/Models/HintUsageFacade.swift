//
//  HintUsageFacade.swift
//  millioner
//
//  Created by Владислав Лихачев on 01.08.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation

class HintUsageFacade{
    var question : Question?
    
    func callFriend() -> String {
        return "Альберт считает, что правильный ответ находится под номером \(question!.id+1)"
    }
    
    func useAuditoryHelp() -> String{
        let first = Int.random(in: 1...80)
        let second = Int.random(in: first...85)
        let third = Int.random(in: second...90)
        return "Зал проглосовал следующим образом: 1 - \(first)%, 2 - \(second-first)%, 3 - \(third - second)%, 4 - \(100-third)%"
    }
    
    func use50to50Hint() -> [Int] {
        var shuffledArray =  [0,1,2,3]
        shuffledArray.remove(at: shuffledArray.firstIndex(of: question!.id)!)
        shuffledArray.shuffle()
        shuffledArray.removeLast()
        return shuffledArray
    }
}
