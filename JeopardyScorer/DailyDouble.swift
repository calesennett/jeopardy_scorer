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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let TOTAL_KEY = "total"

    @IBAction func wagerTextFieldEditingChanged(sender: UITextField) {
        let total = defaults.integerForKey(TOTAL_KEY)
        if wagerTextField.text.toInt() > total {
            spring(0.4) {
                self.errorDialogUIView.transform = CGAffineTransformMakeTranslation(0, 0)
                self.dailyDoubleUIView.bringSubviewToFront(self.errorDialogUIView)
            }
            springWithDelay(0.4, 3.0, {
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
    }
    
    
    @IBAction func answerButtonDidPress(sender: UIButton) {
        if let wagerAmount = wagerTextField.text.toInt() as Int! {
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
    
    private func animateAnswerButtons() {
        springWithCompletion(0.4, {
            self.hideAnswerButtons()
            self.incorrectButton.alpha = 0.99
            self.correctButton.alpha = 0.99
            }, { finished in
                self.performSegueWithIdentifier("dailyDoubleToQuestion", sender: self)
        })
    }
    
    private func hideAnswerButtons() {
        springWithDelay(0.4, 0.1, {
            self.incorrectButton.transform = CGAffineTransformMakeTranslation(0, 300)
        })
        springWithDelay(0.4, 0.15, {
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
        var bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, wagerTextField.frame.height - 3, wagerTextField.frame.width, 10.0)
        bottomLine.backgroundColor = UIColor.whiteColor().CGColor
        wagerTextField.borderStyle = UITextBorderStyle.None
        wagerTextField.layer.addSublayer(bottomLine)
    }
}
