//
//  LauchViewController.swift
//  MetalViewIOS
//
//  Created by sws on 2021/9/9.
//

import UIKit

class LauchViewController: UIViewController {

    @IBAction func onChanged(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0:
            Engine.msaaSample = 1
        case 1:
            Engine.msaaSample = 2
        case 2:
            Engine.msaaSample = 4
        default:
            Engine.msaaSample = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
