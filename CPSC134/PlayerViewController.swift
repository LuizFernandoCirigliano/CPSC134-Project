//
//  PlayerViewController.swift
//  CPSC134
//
//  Created by Luiz Fernando 2 on 11/26/15.
//  Copyright © 2015 CiriglianoApps. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    var lastNote = 72
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        var yTrans = -1*translation.y
        if yTrans > 480 {
            yTrans = 480
        }
        if yTrans < -480 {
            yTrans = -480
        }
        
        let noteChange = Int(yTrans/24.0)
        print(noteChange)
        let myNote = lastNote + noteChange
        if myNote != lastNote {
            lastNote = myNote
            print(lastNote)
            NetworkManager.sharedManager.sendNote(lastNote)
        }
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
