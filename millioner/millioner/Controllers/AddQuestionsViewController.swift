//
//  AddQuestionsViewController.swift
//  millioner
//
//  Created by Владислав Лихачев on 01.08.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class AddQuestionsViewController: UIViewController {
    var questionsCount : Int = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addCellButton: UIButton!
    
    @IBOutlet weak var addAllQuestionsButton: UIButton!
    
    weak var delegate: AddQuestionsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func addCell(_ sender: UIButton) {
        questionsCount+=1
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: questionsCount-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    @IBAction func addAllQuestions(_ sender: UIButton) {
        var questions : [Question] = []
        for i in 0..<questionsCount {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! AddQuestionsTableViewCell
            if let question = cell.buildQuestion() {
                questions.append(question)
            }
        }
        delegate?.saveQuestions(with: questions)
    }
}


extension AddQuestionsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        questionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! AddQuestionsTableViewCell
        return cell
    }
    
    
}

protocol AddQuestionsViewControllerDelegate: class {
    func saveQuestions(with questions: [Question])
}

