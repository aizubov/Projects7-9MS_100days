//
//  ViewController.swift
//  Projects7-9MS_100days.git
//
//  Created by user228564 on 1/18/23.
//

import UIKit

class ViewController: UIViewController {
    private var answerBar: UILabel!
    private var lifeBar: UILabel!
    private var failsArray: [String] = []
    private var singleButtons: [UIButton] = []
    
    private var layoutConstraints: [NSLayoutConstraint] = []
    private var words: [String] = []
    private var hiddenWord: String?
    
    
    private var answersArray: [String] = [] {
        didSet {
            answerBar.text = answersArray.joined()
        }
    }
    
    private var fails = 0 {
        didSet {
            failsArray = Array<String>(repeating: "❤️", count: 7 - fails)
            lifeBar.text = failsArray.joined()
        }
    }
    
    let buttonsView = UIView()
    let buttonSize = 44
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Hangman Game"
        
        barButtonItemsSetup()
        answerBarSetup()
        lifeBarSetup()
        buildButtonsView()
        
        NSLayoutConstraint.activate([
            answerBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 160),
            answerBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            answerBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            lifeBar.topAnchor.constraint(equalTo: answerBar.bottomAnchor, constant: 60),
            lifeBar.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            buttonsView.heightAnchor.constraint(equalToConstant: CGFloat(buttonSize) * 4),
            buttonsView.widthAnchor.constraint(equalToConstant: CGFloat(buttonSize) * 7),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -140)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let wordsLoad = try? String(contentsOf: wordsURL, encoding: .utf8) {
                words = wordsLoad.components(separatedBy: "\n")
            }
        }
        
        if words.isEmpty {
            words = ["whoa"]
        }
        
        restartGame()
    }
    
    
    @objc func restartGame(_ action: UIAlertAction? = nil) {
        hiddenWord = words.randomElement()
        
        answersArray = Array<String>(repeating: "▯", count: hiddenWord!.count)
        fails = 0
        
        for button in singleButtons {
            button.isHidden = false
        }
    }
    
    func barButtonItemsSetup() {
        let restartButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(restartGame)
        )
        
        navigationItem.leftBarButtonItem = restartButton
    }
    
    func answerBarSetup() {
        answerBar = UILabel()
        answerBar.translatesAutoresizingMaskIntoConstraints = false
        answerBar.textAlignment = .center
        answerBar.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        
        view.addSubview(answerBar)
        
    }
    
    func lifeBarSetup() {
        lifeBar = UILabel()
        lifeBar.translatesAutoresizingMaskIntoConstraints = false
        lifeBar.textAlignment = .center
        
        view.addSubview(lifeBar)

    }
    
    func buildButtonsView() {

        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
    
        
        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        var charIndex = 0
        
        for row in 0..<4 {
            for col in 0..<7 {
                guard charIndex < 26 else { return }
                
                let singleButton = UIButton(type: .system)
                singleButton.setTitle(String(letters[charIndex]), for: .normal)
                singleButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
                singleButton.tintColor = .label
                
                var column = col
                
                if row == 3 {
                    column = column + 1
                }
                
                let frame = CGRect(
                    x: column * 44, y: row * 44,
                    width: 44, height: 44
                )
                
                singleButton.frame = frame
                singleButton.layer.borderColor = UIColor.lightGray.cgColor
                singleButton.layer.borderWidth = 0.5
                singleButton.addTarget(self, action: #selector(singleButtonTapped), for: .touchUpInside)
                
                singleButtons.append(singleButton)
                buttonsView.addSubview(singleButton)
                
                charIndex += 1
            }
        }
    }
    
    @objc func singleButtonTapped(_ sender: UIButton) {
        guard let hiddenWord = hiddenWord else { return }
        guard let senderTitle = sender.currentTitle else { return }
        
        sender.isHidden = true
        var matchBool = false
        
        for (index, char) in hiddenWord.enumerated() {
            if char == Character(senderTitle.lowercased()) {
                answersArray[index] = String(char)
                matchBool = true
            }
        }
        
        if !matchBool {
            fails += 1
            
            if fails == 7 {
                let ac = UIAlertController(title: "Game over!", message: "Correct word: \(hiddenWord)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: restartGame))
                present(ac, animated: true)
            }
        }
        
        
        if hiddenWord == answersArray.joined() {
            let ac = UIAlertController(title: "Correct!", message: "You won!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: restartGame))
            present(ac, animated: true)
            
        }
    }
}
