//
//  Final.swift
//  
//
//  Created by Cale Sennett on 8/9/15.
//
//

import UIKit
import Spring

class Final: UIViewController {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let TOTAL_KEY = "total"
    let FINAL_JEOPARDY_ENABLED_KEY = "final_jeopardy_enabled"
    let DOUBLE_JEOPARDY_ENABLED_KEY = "double_jeopardy_enabled"

    override func viewDidLoad() {
        super.viewDidLoad()
        setTotalLabel()
    }
    
    @IBAction func playAgainButtonDidPress(sender: UIButton) {
        springWithCompletion(0.4, animations: {
            self.playAgainButton.transform = CGAffineTransformMakeTranslation(0, 400)
        }, completion: { finished in
            self.resetGame()
            self.performSegueWithIdentifier("finalScreenToQuestion", sender: self)
        })
    }
    
    private func resetGame() {
        defaults.setBool(false, forKey: FINAL_JEOPARDY_ENABLED_KEY)
        defaults.setBool(false, forKey: DOUBLE_JEOPARDY_ENABLED_KEY)
        defaults.setInteger(0, forKey: TOTAL_KEY)
    }
    
    private func setTotalLabel() {
        if let total = defaults.objectForKey(TOTAL_KEY) as? Int {
            totalLabel.text = "\(total)"
        } else {
            totalLabel.text = "0"
        }
    }
}
