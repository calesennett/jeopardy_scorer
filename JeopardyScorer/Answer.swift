//
//  Answer.swift
//  
//
//  Created by Cale Sennett on 7/26/15.
//
//

import UIKit
import Spring

class Answer: UIViewController {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var amountButton: UIButton!
    
    @IBOutlet var answerUIView: UIView!
    @IBOutlet weak var correctAnswerButton: UIButton!
    @IBOutlet weak var incorrectAnswerButton: UIButton!
    @IBOutlet weak var didNotAnswerButton: UIButton!
    
    let defaults  = NSUserDefaults.standardUserDefaults()
    let TOTAL_KEY = "total"
    
    var amount : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTotalLabel()
        setButtonLabel()
    }
    
    @IBAction func correctAnswerButtonDidPress(sender: UIButton) {
        let questionButtonText = amountButton.titleLabel!.text
        let questionAmount = Int(questionButtonText!.substringFromIndex(advance(questionButtonText!.startIndex, 1)))
        
        var newTotal : Int!
        if let previousTotal = defaults.objectForKey(TOTAL_KEY) as? Int {
            newTotal = previousTotal + questionAmount!
        } else {
            newTotal = questionAmount!
        }
        
        defaults.setObject(newTotal, forKey: TOTAL_KEY)
        animateAnswerButtons()
    }
    
    @IBAction func incorrectAnswerButtonDidPress(sender: UIButton) {
        let questionButtonText = amountButton.titleLabel!.text
        let questionAmount = Int(questionButtonText!.substringFromIndex(advance(questionButtonText!.startIndex, 1)))
        
        var newTotal : Int!
        if let previousTotal = defaults.objectForKey(TOTAL_KEY) as? Int {
            newTotal = previousTotal - questionAmount!
        } else {
            newTotal = -questionAmount!
        }
        
        defaults.setObject(newTotal, forKey: TOTAL_KEY)
        animateAnswerButtons()
    }

    @IBAction func didNotAnswerButtonDidPress(sender: UIButton) {
        animateAnswerButtons()
    }
    
    private func hideAnswerButtons() {
        springWithDelay(0.4, delay: 0.05, animations: {
            self.didNotAnswerButton.transform = CGAffineTransformMakeTranslation(0, 300)
        })
        springWithDelay(0.4, delay: 0.1, animations: {
            self.incorrectAnswerButton.transform = CGAffineTransformMakeTranslation(0, 300)
        })
        springWithDelay(0.4, delay: 0.15, animations: {
            self.correctAnswerButton.transform = CGAffineTransformMakeTranslation(0, 300)
        })
    }
    
    private func animateAnswerButtons() {
        springWithCompletion(0.4, animations: {
            self.hideAnswerButtons()
            self.didNotAnswerButton.alpha = 0.99
            self.incorrectAnswerButton.alpha = 0.99
            self.correctAnswerButton.alpha = 0.99
        }, completion: { finished in
            self.performSegueWithIdentifier("answerToQuestion", sender: self)
        })
    }
    
    
    private func setTotalLabel() {
        if let total = defaults.objectForKey(TOTAL_KEY) as? Int {
            totalLabel.text = "\(total)"
        } else {
            totalLabel.text = "0"
        }
    }
    
    private func setButtonLabel() {
        amountButton.setTitle(self.amount, forState: UIControlState.Normal)
    }
}
