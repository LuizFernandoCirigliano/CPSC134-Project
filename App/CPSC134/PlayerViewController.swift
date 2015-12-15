//
//  PlayerViewController.swift
//  CPSC134
//
//  Created by Luiz Fernando 2 on 11/26/15.
//  Copyright © 2015 CiriglianoApps. All rights reserved.
//

import UIKit
import SnapKit

class PlayerViewController: UIViewController {
    var lastBassNote = 72
    var lastMelodyNote = 72
    var leftView = UIView()
    var rightView = UIView()
    
    func configureGestures() {
        //Initialize 2 child UIViews to split the screen in half
        self.leftView = UIView(frame: self.view.frame)
        leftView.backgroundColor = UIColor.redColor()
        self.view.addSubview(leftView)
        
        self.rightView = UIView(frame: self.view.frame)
        rightView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(rightView)
        
        //Set the frame of the 2 subviews
        leftView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top);
            make.left.equalTo(self.view.snp_left);
            make.right.equalTo(self.view.snp_centerX);
            make.bottom.equalTo(self.view.snp_bottom);
        }

        rightView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top);
            make.left.equalTo(self.view.snp_centerX);
            make.right.equalTo(self.view.snp_right);
            make.bottom.equalTo(self.view.snp_bottom);
        }
        
        //Add pan and tap gesture recognizers to the left(bass) side of the screen
        let leftPan = UIPanGestureRecognizer(target: self, action: Selector("didPan:"))
        let leftTap = UITapGestureRecognizer(target: self, action: Selector("didTap:"))

        self.leftView.addGestureRecognizer(leftPan)
        self.leftView.addGestureRecognizer(leftTap)
        
        //Add pan and tap gesture recognizers to the right(melody) side of the screen
        let rightPan = UIPanGestureRecognizer(target: self, action: Selector("didPan:"))
        let rightTap = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
        self.rightView.addGestureRecognizer(rightPan);
        self.rightView.addGestureRecognizer(rightTap);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGestures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(sender.view)
        var yTranslation = -1*translation.y
        
        //Limit the highest and lowest notes that can be played
        if yTranslation > 480 {
            yTranslation = 480
        }
        if yTranslation < -480 {
            yTranslation = -480
        }
        
        let noteChange = Int(yTranslation/24.0)
        
        //If the touch happened on the left side the notes are lower than the right side
        if sender.view == self.leftView {
            let myNote = 48 + noteChange
            if myNote != lastBassNote {
                lastBassNote = myNote
                NetworkManager.sharedManager.sendNote(lastBassNote)
            }
        } else {
            let myNote = 72 + noteChange
            if myNote != lastMelodyNote {
                lastMelodyNote = myNote
                NetworkManager.sharedManager.sendNote(lastMelodyNote)
            }
        }
    }

    @IBAction func didTap(sender: UITapGestureRecognizer) {
        let position = sender.locationInView(sender.view);
        let y = sender.view!.frame.size.height - position.y;
        
        //Base note for left tap is 40, right tap is 70
        let baseNote = sender.view == self.leftView ? 40 : 70
        let note = baseNote + Int(y*30/sender.view!.frame.size.height);
        NetworkManager.sharedManager.sendNote(note);
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
