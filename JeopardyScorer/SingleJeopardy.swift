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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let TOTAL_KEY = "total"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTotalLabel()
    }
    
    @IBAction func questionAmountButtonPressed(sender: UIButton) {
        animateButton(sender)
    }
    
    private func setTotalLabel() {
        if let total = defaults.objectForKey(TOTAL_KEY) as? NSString {
            totalLabel.text = String(total)
        } else {
            totalLabel.text = "0"
        }
    }
    
    private func animateButton(button: UIButton) {
        spring(0.4) {
            button.frame.origin = CGPointMake(0, 183)
            button.titleEdgeInsets = UIEdgeInsetsMake(-350, 0, 0, 0)
            button.frame = CGRectMake(0, 183, 380, 485)
            self.singleJeopardyUIView.bringSubviewToFront(button)
        }
    }
}

