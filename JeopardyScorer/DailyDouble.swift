//
//  DailyDouble.swift
//  
//
//  Created by Cale Sennett on 8/8/15.
//
//

import UIKit

class DailyDouble: UIViewController {
    @IBOutlet weak var wagerTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        drawTextFieldBorderBottom()
    }
    
    private func drawTextFieldBorderBottom() {
        var bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, wagerTextField.frame.height - 3, wagerTextField.frame.width, 10.0)
        bottomLine.backgroundColor = UIColor.whiteColor().CGColor
        wagerTextField.borderStyle = UITextBorderStyle.None
        wagerTextField.layer.addSublayer(bottomLine)
    }
}
