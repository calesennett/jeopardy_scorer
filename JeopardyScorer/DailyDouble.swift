//
//  DailyDouble.swift
//  
//
//  Created by Cale Sennett on 8/8/15.
//
//

import UIKit
import Spring

class DailyDouble: UIViewController {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var wagerTextField: UITextField!
    @IBOutlet weak var errorDialogUIView: UIView!
    @IBOutlet var dailyDoubleUIView: UIView!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var incorrectButton: UIButton!
    @IBOutlet var optionButtons: [UIButton]!
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let TOTAL_KEY = "total"
    let FINAL_JEOPARDY_ENABLED_KEY = "final_jeopardy_enabled"

    @IBAction func wagerTextFieldEditingChanged(sender: UITextField) {
        let total = defaults.integerForKey(TOTAL_KEY)
        if Int(wagerTextField.text!) > total {
            spring(0.4) {
                self.errorDialogUIView.transform = CGAffineTransformMakeTranslation(0, 0)
                self.dailyDoubleUIView.bringSubviewToFront(self.errorDialogUIView)
            }
            springWithDelay(0.4, delay: 3.0, animations: {
                self.errorDialogUIView.transform = CGAffineTransformMakeTranslation(350, 0)
                self.wagerTextField.text = ""
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTotal()
        drawTextFieldBorderBottom()
        hideErrorDialog()
        wagerTextField.becomeFirstResponder()
        if defaults.boolForKey(FINAL_JEOPARDY_ENABLED_KEY) {
            self.hideOptionButtons()
        }
        showDailyDoubleButtons()
    }
    
    @IBAction func answerButtonDidPress(sender: UIButton) {
        if let wagerAmount = Int(wagerTextField.text!) as Int! {
            let total = defaults.integerForKey(TOTAL_KEY)
            var newTotal : Int!
            if sender.titleLabel?.text == "CORRECT" {
                newTotal = total + wagerAmount
            } else {
                newTotal = total - wagerAmount
            }
            
            defaults.setInteger(newTotal, forKey: TOTAL_KEY)
            animateAnswerButtons()
        }
    }
    
    private func showDailyDoubleButtons() {
        springWithDelay(0.4, delay: 0.05, animations: {
            self.correctButton.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        springWithDelay(0.4, delay: 0.1, animations: {
            self.incorrectButton.transform = CGAffineTransformMakeTranslation(0, 0)
        })
    }
    
    private func animateAnswerButtons() {
        if defaults.boolForKey(FINAL_JEOPARDY_ENABLED_KEY) == false {
            springWithCompletion(0.4, animations: {
                self.hideAnswerButtons()
                self.incorrectButton.alpha = 0.99
                self.correctButton.alpha = 0.99
                }, completion: { finished in
                    self.performSegueWithIdentifier("dailyDoubleToQuestion", sender: self)
            })
        } else {
            springWithCompletion(0.4, animations: {
                self.hideAnswerButtons()
                self.incorrectButton.alpha = 0.99
                self.correctButton.alpha = 0.99
            }, completion: { finished in
                self.performSegueWithIdentifier("finalJeopardyToFinalScreen", sender: self)
            })
        }
    }
    
    private func hideOptionButtons() {
        for btn in optionButtons {
            btn.transform = CGAffineTransformMakeTranslation(300, 0)
        }
    }
    
    private func hideAnswerButtons() {
        springWithDelay(0.4, delay: 0.1, animations: {
            self.incorrectButton.transform = CGAffineTransformMakeTranslation(0, 300)
        })
        springWithDelay(0.4, delay: 0.15, animations: {
            self.correctButton.transform = CGAffineTransformMakeTranslation(0, 300)
        })
    }
    
    private func setTotal() {
        let total = defaults.integerForKey(TOTAL_KEY)
        totalLabel.text = "\(total)"
    }
    
    private func hideErrorDialog() {
        errorDialogUIView.transform = CGAffineTransformMakeTranslation(350, 0)
    }
    
    private func drawTextFieldBorderBottom() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, wagerTextField.frame.height - 3, wagerTextField.frame.width, 10.0)
        bottomLine.backgroundColor = UIColor.whiteColor().CGColor
        wagerTextField.borderStyle = UITextBorderStyle.None
        wagerTextField.layer.addSublayer(bottomLine)
    }
}
