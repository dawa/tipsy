//
//  ViewController.swift
//  tipsy
//
//  Created by Davis Wamola on 2/27/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var settingsButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.

        // bill amount is always the first responder
        billField.becomeFirstResponder()

        // Remembering the bill amount across app restarts (if <10mins)
        if let lastBill = getLastBill() {
            billField.text = lastBill
        }

        // Use cog image as setting controller toggle button
        settingsButton?.title = NSString(string: "\u{2699}") as String
        if let font = UIFont(name: "Helvetica", size: 18.0) {
            settingsButton?.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let defaults = UserDefaults.standard

        tipControl.selectedSegmentIndex = defaults.integer(forKey: "default_tip_value")
    }
    
    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(_ sender: AnyObject) {
        let billString = billField.text! as NSString
        let tipPercentages = [0.15, 0.2, 0.25]
        let bill = Double(billString as String) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        tipLabel.text = formatter.string(from: tip as NSNumber)!
        totalLabel.text = formatter.string(from: total as NSNumber)!

        let defaults = UserDefaults.standard
        defaults.set(billString, forKey: "last_bill_value")
        defaults.set(Date(), forKey: "last_bill_timestamp")
        defaults.synchronize()

        animateTotal()
    }
    
    func animateTotal() {
        self.totalLabel.alpha = 0
        UIView.animate(withDuration: 0.5,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.curveEaseIn,
                                   animations: { self.totalLabel.alpha = 1 },
                                   completion: nil )
    }

    func getLastBill() -> String? {
        let now = Date()
        let defaults = UserDefaults.standard
        let lastBillTimestamp = defaults.object(forKey: "last_bill_timestamp") as! Date?
        let billResetAfter = TimeInterval(10 * 60)
        
        if (lastBillTimestamp == nil || now.timeIntervalSince(lastBillTimestamp!) > billResetAfter) {
            return nil
        } else {
            return defaults.object(forKey: "last_bill_value") as! String?
        }
    }
}

