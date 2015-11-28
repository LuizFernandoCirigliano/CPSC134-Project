//
//  ViewController.swift
//  CPSC134
//
//  Created by Luiz Fernando 2 on 11/25/15.
//  Copyright © 2015 CiriglianoApps. All rights reserved.
//

import UIKit


class ViewController: UIViewController, NetworkConnectionDelegate {

    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connect(sender: UIButton) {
        let address = self.addressTextField.text ?? ""
        let port = self.portTextField.text ?? ""
        
        
        guard !address.isEmpty else {
            displayErrorMessage("Please add a valid server address.")
            return;
        }
        
        guard let portInt = UInt16(port) where !port.isEmpty else {
            displayErrorMessage("Please add a valid server port.")
            return;
        }
        
        do {
            try NetworkManager.sharedManager.connectToServer(address, serverPort: portInt, delegate: self)
        } catch {
            displayErrorMessage("Unable to connect")
            return;
        }
    }
    
    func displayErrorMessage(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        
        alertController.addAction(cancelAction)
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.presentViewController(alertController, animated: true) {
            }
        }
    }
    
    func didConnect() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.performSegueWithIdentifier("segueToInstrument", sender: nil)
        }
    }
    
    func didNotConnect() {
        displayErrorMessage("Unable to Connect")
    }
}

