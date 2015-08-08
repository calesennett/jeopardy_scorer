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
    @IBOutlet weak var questionAmountButton: UIButton!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var incorrectButton: UIButton!
    @IBOutlet weak var didNotAnswerButton: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let TOTAL_KEY = "total"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTotalLabel()
        hideAnswerButtons()
    }
    
    @IBAction func questionAmountButtonPressed(sender: UIButton) {
        animateButton(sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "questionToAnswer" {
            let toView = segue.destinationViewController as! Answer
            if let amount = sender!.titleLabel!!.text {
                toView.amount = amount
            }
        }
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
        springWithDelay(0.4, 0.05, {
            self.correctButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.singleJeopardyUIView.bringSubviewToFront(self.correctButton)
            
        })
        springWithDelay(0.4, 0.10, {
            self.incorrectButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.singleJeopardyUIView.bringSubviewToFront(self.incorrectButton)
            
        })
        springWithDelay(0.4, 0.15, {
            self.didNotAnswerButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.singleJeopardyUIView.bringSubviewToFront(self.didNotAnswerButton)
            
        })
    }
    
    private func animateButton(button: UIButton) {
        springWithCompletion(0.4, {
            button.frame.origin = CGPointMake(0, 183)
            button.titleEdgeInsets = UIEdgeInsetsMake(-280, 0, 0, 0)
            button.frame = CGRectMake(0, 183, 380, 485)
            self.singleJeopardyUIView.bringSubviewToFront(button)
            self.unhideAnswerButtons()
            
            }, { finished in
                self.performSegueWithIdentifier("questionToAnswer", sender: button)
            })
    }
}

