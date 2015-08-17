//
//  ViewController.swift
//  JeopardyScorer
//
//  Created by Cale Sennett on 7/26/15.
//  Copyright (c) 2015 Cale Sennett. All rights reserved.
//

import UIKit
import Spring

class SingleJeopardy: UIViewController {
    @IBOutlet var singleJeopardyUIView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet var questionAmountButtons: [UIButton]!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var incorrectButton: UIButton!
    @IBOutlet weak var dailyDoubleButton: UIButton!
    @IBOutlet weak var doubleJeopardyButton: UIButton!
    @IBOutlet weak var didNotAnswerButton: UIButton!
    @IBOutlet weak var wagerUIView: UIView!
    @IBOutlet weak var wagerTextField: UITextField!
    @IBOutlet weak var finalJeopardyButton: UIButton!
    @IBOutlet var optionButtons: [UIButton]!
    @IBOutlet weak var dailyDoubleCorrectButton: UIButton!
    @IBOutlet weak var dailyDoubleIncorrectButton: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let TOTAL_KEY = "total"
    let DOUBLE_JEOPARDY_ENABLED_KEY = "double_jeopardy_enabled"
    let FINAL_JEOPARDY_ENABLED_KEY = "final_jeopardy_enabled"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTotalLabel()
        hideAnswerButtons()
        hideDailyDoubleButtons()
        hideWagerView()
        drawTextFieldBorderBottom()
        updateQuestionAmounts()
    }
    
    @IBAction func questionAmountButtonPressed(sender: UIButton) {
        animateButton(sender)
    }
    
    @IBAction func dailyDoubleButtonDidPress(sender: UIButton) {
        springWithCompletion(0.4, animations: {
            self.wagerUIView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.singleJeopardyUIView.bringSubviewToFront(self.wagerUIView)
        }, completion: { finished in
            self.performSegueWithIdentifier("questionToDailyDouble", sender: self)
        })
    }
    
    @IBAction func finalJeopardyButtonDidPress(sender: UIButton) {
        springWithCompletion(0.4, animations: {
            self.hideOptionButtons()
            self.wagerUIView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.singleJeopardyUIView.bringSubviewToFront(self.wagerUIView)
        }, completion: { finished in
            self.defaults.setBool(true, forKey: self.FINAL_JEOPARDY_ENABLED_KEY)
            self.performSegueWithIdentifier("questionToDailyDouble", sender: self)
        })
    }
    
    @IBAction func doubleJeopardyButtonDidPress(sender: UIButton) {
        let doubleJeopardyEnabled = defaults.boolForKey(DOUBLE_JEOPARDY_ENABLED_KEY)
        defaults.setBool(!doubleJeopardyEnabled, forKey: DOUBLE_JEOPARDY_ENABLED_KEY)
        updateQuestionAmounts()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "questionToAnswer" {
            let toView = segue.destinationViewController as! Answer
            if let amount = sender!.titleLabel!!.text {
                toView.amount = amount
            }
        }
    }
    
    private func hideDailyDoubleButtons() {
        dailyDoubleCorrectButton.transform = CGAffineTransformMakeTranslation(0, 300)
        dailyDoubleIncorrectButton.transform = CGAffineTransformMakeTranslation(0, 300)
    }
    
    private func hideWagerView() {
        wagerUIView.transform = CGAffineTransformMakeTranslation(400, 0)
    }
    
    private func hideOptionButtons() {
        var delay = 0.05
        for btn in optionButtons {
            springWithDelay(0.4, delay: delay, animations: {
                btn.transform = CGAffineTransformMakeTranslation(200, 0)
                delay += 0.05
            })
        }
    }
    
    private func updateQuestionAmounts() {
        if defaults.boolForKey(DOUBLE_JEOPARDY_ENABLED_KEY) == false {
            let amount = 200
            
            for (idx, btn) in questionAmountButtons.enumerate() {
                let questionAmount = amount * (idx + 1)
                btn.setTitle("$\(questionAmount)", forState: UIControlState.Normal)
            }
        } else {
            let amount = 400
            
            for (idx, btn) in questionAmountButtons.enumerate() {
                let questionAmount = amount * (idx + 1)
                btn.setTitle("$\(questionAmount)", forState: UIControlState.Normal)
            }
        }
    }
    
    private func drawTextFieldBorderBottom() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, wagerTextField.frame.height - 3, wagerTextField.frame.width, 10.0)
        bottomLine.backgroundColor = UIColor.whiteColor().CGColor
        wagerTextField.borderStyle = UITextBorderStyle.None
        wagerTextField.layer.addSublayer(bottomLine)
    }
    
    private func setTotalLabel() {
        if let total = defaults.objectForKey(TOTAL_KEY) as? Int {
            totalLabel.text = "\(total)"
        } else {
            totalLabel.text = "0"
        }
    }
    
    private func hideAnswerButtons() {
        correctButton.transform = CGAffineTransformMakeTranslation(0, 300)
        incorrectButton.transform = CGAffineTransformMakeTranslation(0, 300)
        didNotAnswerButton.transform = CGAffineTransformMakeTranslation(0, 300)
    }
    
    private func unhideAnswerButtons() {
        springWithDelay(0.4, delay: 0.05, animations: {
            self.correctButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.singleJeopardyUIView.bringSubviewToFront(self.correctButton)
            
        })
        springWithDelay(0.4, delay: 0.10, animations: {
            self.incorrectButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.singleJeopardyUIView.bringSubviewToFront(self.incorrectButton)
            
        })
        springWithDelay(0.4, delay: 0.15, animations: {
            self.didNotAnswerButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.singleJeopardyUIView.bringSubviewToFront(self.didNotAnswerButton)
            
        })
    }
    
    private func animateButton(button: UIButton) {
        springWithCompletion(0.4, animations: {
            button.frame.origin = CGPointMake(0, 183)
            button.titleEdgeInsets = UIEdgeInsetsMake(-280, 0, 0, 0)
            button.frame = CGRectMake(0, 183, 380, 485)
            self.singleJeopardyUIView.bringSubviewToFront(button)
            self.unhideAnswerButtons()
            
            }, completion: { finished in
                self.performSegueWithIdentifier("questionToAnswer", sender: button)
            })
    }
}

