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
    override func viewDidLoad() {
        super.viewDidLoad()
        Game.shared.session = GameSession()
        DataService.getServerData(qType: 2,count: 5) { [weak self] array in
            guard let self = self else { return }
            Game.shared.session?.questions.append(contentsOf: array!)
            Game.shared.session?.countAllQuestions = array!.count
            self.updateQuestion()
        }
        self.fiftyHintButton.setTitle(Game.shared.session?.hints[0].rawValue, for: .normal)
        self.hallHintButton.setTitle(Game.shared.session?.hints[1].rawValue, for: .normal)
        self.friendHintButton.setTitle(Game.shared.session?.hints[2].rawValue, for: .normal)
        //DataService.getServerData(qType: 3,count: 5)
        
        // Do any additional setup after loading the view.
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
        showInfo(message: "Альберт считает, что правильный ответ находится под номером \((Game.shared.session?.questions[Game.shared.session!.currentQuestion].id)!+1)", title: "Вы позвонили своему другу Эйнштейну")
        sender.isEnabled = false
    }
    @IBAction func HallButtonWasTapped(_ sender: UIButton) {
        let first = Int.random(in: 1...80)
        let second = Int.random(in: first...85)
        let third = Int.random(in: second...90)
        showInfo(message: "Зал проглосовал следующим образом: 1 - \(first)%, 2 - \(second-first)%, 3 - \(third - second)%, 4 - \(100-third)%", title: "Вы выбрали помощь зала")
        sender.isEnabled = false
        
    }
    
    @IBAction func fiftyButtonWasTapped(_ sender: UIButton) {
        var shuffledArray =  [0,1,2,3]
        
        shuffledArray.remove(at: shuffledArray.firstIndex(of: Game.shared.session!.questions[Game.shared.session!.currentQuestion].id)!)
        shuffledArray.shuffle()
        var countHidden = 0
        for i in 0..<shuffledArray.count {
            if countHidden < 2 {
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
                countHidden+=1
            }
        }
        fiftyHintButton.isEnabled = false
    }
    
    func checkButtonAndUpdateQuestion(for buttonNumber: Int){
        if Game.shared.session?.questions[Game.shared.session!.currentQuestion].id == buttonNumber {
            Game.shared.session?.currentQuestion+=1
            Game.shared.session?.countRightAnswers+=1
            if (Game.shared.session!.countRightAnswers == Game.shared.session!.countAllQuestions){
                //self.dismiss(animated: true)
                print("YOU WIN")
                showInfo(message: "Ваш выигрыш составляет \(Game.shared.session!.countAllQuestions * 1000) рублей", title: "ВЫ ПОБЕДИЛИ")
            } else {
                updateQuestion()
            }
        } else {
            showInfo(message: "Вы ничего не выиграли :(", title: "Game over")
            //self.dismiss(animated: true)
        }
    }
    
    func updateQuestion(){
        self.questionNumber.text = "Вопрос \(Game.shared.session!.currentQuestion+1)"
        self.questionText.text = Game.shared.session?.questions[Game.shared.session!.currentQuestion].question
        self.answer1Button.setTitle(Game.shared.session?.questions[Game.shared.session!.currentQuestion].answers[0], for: .normal)
        self.answer2Button.setTitle(Game.shared.session?.questions[Game.shared.session!.currentQuestion].answers[1], for: .normal)
        self.answer3Button.setTitle(Game.shared.session?.questions[Game.shared.session!.currentQuestion].answers[2], for: .normal)
        self.answer4Button.setTitle(Game.shared.session?.questions[Game.shared.session!.currentQuestion].answers[3], for: .normal)
        self.answer1Button.isEnabled = true
        self.answer2Button.isEnabled = true
        self.answer3Button.isEnabled = true
        self.answer4Button.isEnabled = true
    }
    func showInfo(message : String, title : String){
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

}
