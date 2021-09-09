//
//  LauchViewController.swift
//  MetalViewMAC
//
//  Created by sws on 2021/9/9.
//

import Cocoa

class LauchViewController: NSViewController {

    @IBOutlet weak var msaaButton: NSPopUpButton!
    @IBOutlet weak var resButton: NSPopUpButton!
    
    private var viewSize:NSSize
    {
        switch resButton.titleOfSelectedItem!
        {
            case "512":
                return NSSize(width:512,height:512)
            case "1024":
                return NSSize(width:1024,height:1024)
            case "2048":
                return NSSize(width:2048,height:2048)
            default :
                return NSSize(width:1024,height:1024)
            
        }
    }
    
    private var msaaSample:Int
    {
        switch msaaButton.titleOfSelectedItem!
        {
            case "1x":
                return 1
            case "2x":
                return 2
            case "4x":
                return 4
            case "8x":
                return 1
            default :
                return 1
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        resButton.removeAllItems()
        resButton.addItems(withTitles: ["1024","512","2048"])
        msaaButton.removeAllItems()
        msaaButton.addItems(withTitles: ["1x","2x","4x","8x"])
        // Do view setup here.
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let DestViewController: ViewController = segue.destinationController as! ViewController
        DestViewController.preferredContentSize = viewSize
        Engine.msaaSample = msaaSample
    }
  
    
}
