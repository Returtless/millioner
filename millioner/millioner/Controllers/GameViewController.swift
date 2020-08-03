//
//  GameViewController.swift
//  millioner
//
//  Created by Владислав Лихачев on 28.07.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var fiftyHintButton: UIButton!
    @IBOutlet weak var hallHintButton: UIButton!
    @IBOutlet weak var friendHintButton: UIButton!
    
    @IBOutlet var answerButtons: [UIButton]!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeHiddenStatus(to: true)
        activityIndicator.startAnimating()
        //добавляем обсервер для вопросов, чтобы отключить индикатор загрузки
        Game.shared.session?.questions.addObserver(self, options: [.new, .initial], closure: { [weak self] (current, _) in
            if current.count > 0{
                self!.activityIndicator.stopAnimating()
                self!.changeHiddenStatus(to: false)
                Game.shared.session?.questions.removeObserver(self!)
                self!.questionNumber.text = Game.shared.session!.getCurrentQuestionNumber()
                self!.updateQuestion()
            }
        })
        //добавляем обсервер на номер текущего вопроса
        Game.shared.session?.currentQuestion.addObserver(self, options: [.new, .initial], closure: { [weak self] (current, _) in
            self!.questionNumber.text = Game.shared.session!.getCurrentQuestionNumber()
        })
        self.fiftyHintButton.setTitle(Game.shared.session?.hints[0].rawValue, for: .normal)
        self.hallHintButton.setTitle(Game.shared.session?.hints[1].rawValue, for: .normal)
        self.friendHintButton.setTitle(Game.shared.session?.hints[2].rawValue, for: .normal)
    }
    
    @IBAction func answer4WasTapped(_ sender: UIButton) {
        checkButtonAndUpdateQuestion(for: answerButtons.firstIndex(of: sender)!)
    }
    
    @IBAction func friendButtonWasTapped(_ sender: UIButton) {
        showInfo(message: Game.shared.session!.hintUsageFacade!.callFriend(), title: "Вы позвонили своему другу Эйнштейну")
        sender.isEnabled = false
    }
    
    @IBAction func HallButtonWasTapped(_ sender: UIButton) {
        showInfo(message: Game.shared.session!.hintUsageFacade!.useAuditoryHelp(), title: "Вы выбрали помощь зала")
        sender.isEnabled = false
    }
    
    @IBAction func fiftyButtonWasTapped(_ sender: UIButton) {
        let shuffledArray = Game.shared.session!.hintUsageFacade!.use50to50Hint()
        for i in 0..<shuffledArray.count {
           configureButton(button: answerButtons[i], index: i, state: false)
        }
        fiftyHintButton.isEnabled = false
    }
    
    func checkButtonAndUpdateQuestion(for buttonNumber: Int){
        if Game.shared.session?.questions.value[Game.shared.session!.currentQuestion.value].id == buttonNumber {
            Game.shared.session?.currentQuestion.value+=1
            Game.shared.session?.countRightAnswers+=1
            if (Game.shared.session!.countRightAnswers == Game.shared.session!.countAllQuestions){
                showInfo(message: "Ваш выигрыш составляет \(Game.shared.session!.countAllQuestions * 1000) рублей", title: "ВЫ ПОБЕДИЛИ", dismiss: true)
            } else {
                updateQuestion()
            }
        } else {
            showInfo(message: "Вы ничего не выиграли :(", title: "Game over", dismiss: true)
        }
    }
    
    func updateQuestion(){
        self.questionText.text = Game.shared.session?.questions.value[Game.shared.session!.currentQuestion.value].question
        for (index, button) in answerButtons.enumerated() {
            configureButton(button: button, index: index, state: true)
        }
    }
    
    func configureButton(button: UIButton, index: Int, state: Bool) {
        button.setTitle(Game.shared.session?.questions.value[Game.shared.session!.currentQuestion.value].answers[index], for: .normal)
        button.isEnabled = state
    }
    
    func showInfo(message : String, title : String, dismiss: Bool = false){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if dismiss{
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        self.present(alert, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Game.shared.addRecord(Game.shared.session!.countRightAnswers, Game.shared.session!.countAllQuestions)
        Game.shared.session = nil
    }
    
    func changeHiddenStatus(to status: Bool){
        changeHideStatusButtons(state: status)
        self.fiftyHintButton.isHidden = status
        self.hallHintButton.isHidden = status
        self.friendHintButton.isHidden = status
        self.questionNumber.isHidden = status
        self.questionText.isHidden = status
    }
    
    func changeHideStatusButtons(state: Bool) {
        for button in answerButtons.enumerated() {
            button.element.isHidden = state
        }
    }
}
