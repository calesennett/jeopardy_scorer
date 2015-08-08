//
//  Answer.swift
//  
//
//  Created by Cale Sennett on 7/26/15.
//
//

import UIKit

class Answer: UIViewController {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var amountButton: UIButton!
    @IBOutlet weak var correctAnswerButton: UIButton!
    @IBOutlet weak var incorrectAnswerButton: UIButton!
    @IBOutlet weak var didNotAnswerButton: UIButton!
    
    let defaults  = NSUserDefaults.standardUserDefaults()
    let TOTAL_KEY = "total"
    
    var amount : String!
    
    @IBAction func correctAnswerButtonDidPress(sender: UIButton) {
        let questionButtonText = amountButton.titleLabel!.text
        let questionAmount = questionButtonText!.substringFromIndex(advance(questionButtonText!.startIndex, 1)).toInt()
        
        var newTotal : Int!
        if let previousTotal = defaults.objectForKey(TOTAL_KEY) as? Int {
            newTotal = previousTotal + questionAmount!
        } else {
            newTotal = questionAmount!
        }
        
        defaults.setObject(newTotal, forKey: TOTAL_KEY)
    }
    
    @IBAction func incorrectAnswerButtonDidPress(sender: UIButton) {
        let questionButtonText = amountButton.titleLabel!.text
        let questionAmount = questionButtonText!.substringFromIndex(advance(questionButtonText!.startIndex, 1)).toInt()
        
        var newTotal : Int!
        if let previousTotal = defaults.objectForKey(TOTAL_KEY) as? Int {
            newTotal = previousTotal - questionAmount!
        } else {
            newTotal = -questionAmount!
        }
        
        defaults.setObject(newTotal, forKey: TOTAL_KEY)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTotalLabel()
        setButtonLabel()
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
