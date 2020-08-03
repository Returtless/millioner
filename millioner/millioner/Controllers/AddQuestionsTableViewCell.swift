//
//  AddQuestionsTableViewCell.swift
//  millioner
//
//  Created by Владислав Лихачев on 01.08.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class AddQuestionsTableViewCell: UITableViewCell {

    @IBOutlet private weak var questionText: UITextField!
    @IBOutlet private weak var answer1TextField: UITextField!
    @IBOutlet private weak var answer2TextField: UITextField!
    @IBOutlet private weak var answer3TextField: UITextField!
    @IBOutlet private weak var answer4TextField: UITextField!
    @IBOutlet private weak var rightAnswerSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var difficultySegmentedControl: UISegmentedControl!
    
    private var questionBuilder : QuestionsBuilder?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if questionBuilder == nil {
            questionBuilder = QuestionsBuilder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func buildQuestion() -> Question? {
        guard !questionBuilder!.answers.isEmpty, !questionBuilder!.question.isEmpty else {
            return nil
        }
        return questionBuilder!.build()
    }
    
    @IBAction func questionTextChanged(_ sender: UITextField) {
        questionBuilder!.setQuestion(sender.text!)
    }
    
    @IBAction func answer1TextChanged(_ sender: UITextField) {
        questionBuilder!.addAnswer(sender.text!)
    }
    
    @IBAction func rightAnswerChanged(_ sender: UISegmentedControl) {
        questionBuilder!.setRightAnswer(sender.selectedSegmentIndex)
    }
    
    @IBAction func difficultyChanged(_ sender: UISegmentedControl) {
        questionBuilder!.setDifficulty(sender.selectedSegmentIndex)
    }
}
