//
//  SettingsViewController.swift
//  tipsy
//
//  Created by Davis Wamola on 3/3/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SSRadioButtonControllerDelegate {
    @IBOutlet weak var fifteenPerCent: UIButton!
    @IBOutlet weak var twentyPerCent: UIButton!
    @IBOutlet weak var twentyFivePerCent: UIButton!
    
    var defaultButtons: Array<UIButton>?
    var radioButtonController: SSRadioButtonsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultButtons = [fifteenPerCent, twentyPerCent, twentyFivePerCent]
        
        let defaults = UserDefaults.standard
        let integerTipValue = defaults.integer(forKey: "default_tip_value")
        
        radioButtonController = SSRadioButtonsController(buttons: fifteenPerCent, twentyPerCent, twentyFivePerCent)
        radioButtonController!.delegate = self
        radioButtonController!.pressed(defaultButtons![integerTipValue])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectButton(_ aButton: UIButton?) {
        let currentButton = radioButtonController!.selectedButton()
        let integerTipIndex = defaultButtons!.index{$0 === currentButton} ?? 0
        let defaults = UserDefaults.standard

        defaults.set(integerTipIndex, forKey: "default_tip_value")
        defaults.synchronize()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
