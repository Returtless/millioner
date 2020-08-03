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
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    @IBOutlet weak var fiftyHintButton: UIButton!
    @IBOutlet weak var hallHintButton: UIButton!
    @IBOutlet weak var friendHintButton: UIButton!
    
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
    
    @IBAction func answer1WasTapped(_ sender: UIButton) {
        checkButtonAndUpdateQuestion(for: 0)
    }
    @IBAction func answer2WasTapped(_ sender: UIButton) {
        checkButtonAndUpdateQuestion(for: 1)
    }
    
    @IBAction func answer3WasTapped(_ sender: UIButton) {
        checkButtonAndUpdateQuestion(for: 2)
    }
    
    @IBAction func answer4WasTapped(_ sender: UIButton) {
        checkButtonAndUpdateQuestion(for: 3)
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
            switch shuffledArray[i] {
            case 0:
                answer1Button.isEnabled = false
            case 1:
                answer2Button.isEnabled = false
            case 2:
                answer3Button.isEnabled = false
            case 3:
                answer4Button.isEnabled = false
            default:
                return
            }
        }
        fiftyHintButton.isEnabled = false
    }
    
    func checkButtonAndUpdateQuestion(for buttonNumber: Int){
        if Game.shared.session?.questions.value[Game.shared.session!.currentQuestion.value].id == buttonNumber {
            Game.shared.session?.currentQuestion.value+=1
            Game.shared.session?.countRightAnswers+=1
            if (Game.shared.session!.countRightAnswers == Game.shared.session!.countAllQuestions){
                showInfoWithDismiss(message: "Ваш выигрыш составляет \(Game.shared.session!.countAllQuestions * 1000) рублей", title: "ВЫ ПОБЕДИЛИ")
            } else {
                updateQuestion()
            }
        } else {
            showInfoWithDismiss(message: "Вы ничего не выиграли :(", title: "Game over")
        }
    }
    
    func updateQuestion(){
        self.questionText.text = Game.shared.session?.questions.value[Game.shared.session!.currentQuestion.value].question
        self.answer1Button.setTitle(Game.shared.session?.questions.value[Game.shared.session!.currentQuestion.value].answers[0], for: .normal)
        self.answer2Button.setTitle(Game.shared.session?.questions.value[Game.shared.session!.currentQuestion.value].answers[1], for: .normal)
        self.answer3Button.setTitle(Game.shared.session?.questions.value[Game.shared.session!.currentQuestion.value].answers[2], for: .normal)
        self.answer4Button.setTitle(Game.shared.session?.questions.value[Game.shared.session!.currentQuestion.value].answers[3], for: .normal)
        self.answer1Button.isEnabled = true
        self.answer2Button.isEnabled = true
        self.answer3Button.isEnabled = true
        self.answer4Button.isEnabled = true
    }
    func showInfo(message : String, title : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func showInfoWithDismiss(message : String, title : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Game.shared.addRecord(Game.shared.session!.countRightAnswers, Game.shared.session!.countAllQuestions)
        Game.shared.session = nil
    }
    
    func changeHiddenStatus(to status: Bool){
        self.answer1Button.isHidden = status
        self.answer2Button.isHidden = status
        self.answer3Button.isHidden = status
        self.answer4Button.isHidden = status
        self.fiftyHintButton.isHidden = status
        self.hallHintButton.isHidden = status
        self.friendHintButton.isHidden = status
        self.questionNumber.isHidden = status
        self.questionText.isHidden = status
    }
    
}
