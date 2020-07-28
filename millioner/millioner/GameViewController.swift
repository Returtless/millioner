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
        let alert = UIAlertController(title: "Вы позвонили своему другу Эйнштейну", message: "Альберт считает, что правильный ответ находится под номером \((Game.shared.session?.questions[Game.shared.session!.currentQuestion].id)!+1)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        sender.isEnabled = false
    }
    @IBAction func HallButtonWasTapped(_ sender: UIButton) {
        
        let first = Int.random(in: 1...80)
        let second = Int.random(in: first...85)
        let third = Int.random(in: second...90)
        
        let alert = UIAlertController(title: "Вы выбрали помощь зала", message: "Зал проглосовал следующим образом: 1 - \(first)%, 2 - \(second-first)%, 3 - \(third - second)%, 4 - \(100-third)%", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        sender.isEnabled = false
        
    }
    
    @IBAction func fiftyButtonWasTapped(_ sender: UIButton) {
//       var shuffledArray =  [1,2,3,4]
//        shuffledArray.shuffle()
//        var countHidden = 0
//        for i in 0..<shuffledArray.count {
//            if countHidden < 2 {
//                
//                if (shuffledArray[i] != )
//            }
//        }
        
    }
    func checkButtonAndUpdateQuestion(for buttonNumber: Int){
        if Game.shared.session?.questions[Game.shared.session!.currentQuestion].id == buttonNumber {
            Game.shared.session?.currentQuestion+=1
            Game.shared.session?.countRightAnswers+=1
            if (Game.shared.session!.countRightAnswers == Game.shared.session!.countAllQuestions){
                self.dismiss(animated: true)
                print("YOU WIN")
            } else {
                updateQuestion()
                print("All is good")
            }
        } else {
            self.dismiss(animated: true)
            print("game over")
        }
    }
    
    func updateQuestion(){
        self.questionNumber.text = "Вопрос \(Game.shared.session!.currentQuestion+1)"
        self.questionText.text = Game.shared.session?.questions[Game.shared.session!.currentQuestion].question
        self.answer1Button.setTitle(Game.shared.session?.questions[Game.shared.session!.currentQuestion].answers[0], for: .normal)
        self.answer2Button.setTitle(Game.shared.session?.questions[Game.shared.session!.currentQuestion].answers[1], for: .normal)
        self.answer3Button.setTitle(Game.shared.session?.questions[Game.shared.session!.currentQuestion].answers[2], for: .normal)
        self.answer4Button.setTitle(Game.shared.session?.questions[Game.shared.session!.currentQuestion].answers[3], for: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Game.shared.addRecord(Game.shared.session!.countRightAnswers, Game.shared.session!.countAllQuestions)
        Game.shared.session = nil
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
