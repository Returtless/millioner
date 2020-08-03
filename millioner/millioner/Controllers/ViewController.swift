//
//  ViewController.swift
//  millioner
//
//  Created by Владислав Лихачев on 28.07.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var addQuestionsButton: UIButton!
    
    @IBOutlet weak var difficultyIndicator: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func addQuestionButtonTapped(_ sender: UIButton) {
        let addQuestionsVC = storyboard?.instantiateViewController(withIdentifier: "AddQuestionsViewController") as! AddQuestionsViewController
        addQuestionsVC.delegate = self
        present(addQuestionsVC, animated: true, completion: nil)
    }
    
    @IBAction func startGameButtonTapped(_ sender: UIButton) {
        let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        Game.shared.session = GameSession(by: difficultyIndicator.selectedSegmentIndex)
        present(gameVC, animated: true, completion: nil)
    }
}

extension ViewController: AddQuestionsViewControllerDelegate {
    func saveQuestions(with questions: [Question]) {
        let questionsCaretaker = QuestionsCaretaker()
        questionsCaretaker.save(questions: questions)
    }
}
