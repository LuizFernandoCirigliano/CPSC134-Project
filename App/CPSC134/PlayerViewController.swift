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
    var lastBassNote = 72 {
        didSet {
            leftLabel.text = noteStringForPitch(lastBassNote)
        }
    }
    var lastMelodyNote = 72 {
        didSet {
            rightLabel.text = noteStringForPitch(lastMelodyNote)
        }
    }
    
    //Layout setup
    let leftView:UIView = {
        let theView = UIView()
        theView.backgroundColor = UIColor.redColor()
        return theView
    }()
    let rightView:UIView = {
        let theView = UIView()
        theView.backgroundColor = UIColor.blueColor()
        return theView
    }()
    
    let leftLabel:UILabel = {
        let theLabel = UILabel()
        theLabel.font = UIFont(name: "Didot", size: 60.0)
        return theLabel
    }()
    
    let rightLabel:UILabel = {
        let theLabel = UILabel()
        theLabel.font = UIFont(name: "Didot", size: 60.0)
        return theLabel
    }()
    
    let pitchLetters = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    
    //Convert a pitch number to Letter + Octave representation
    func noteStringForPitch(pitchNumber: Int!) -> String {
        let pitchClass = pitchLetters[pitchNumber % 12]
        let octave = (pitchNumber + 3)/12
        
        return "\(pitchClass)\(octave)"
    }
    
    func configureGestures() {
        self.view.addSubview(leftView)
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
        
        //Add the visual feedback labels to each view
        leftLabel.textColor = UIColor.whiteColor()
        rightLabel.textColor = UIColor.whiteColor()
        
        leftView.addSubview(leftLabel)
        rightView.addSubview(rightLabel)
        
        leftLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(leftView)
        }
        rightLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(rightView)
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
        
        let noteChange = Int(yTranslation/48.0)
        
        //If the touch happened on the left side the notes are lower than the right side
        if sender.view == self.leftView {
            let myNote = 48 + noteChange
            if myNote != self.lastBassNote {
                self.lastBassNote = myNote
                NetworkManager.sharedManager.sendNote(self.lastBassNote)
            }
        } else {
            let myNote = 72 + noteChange
            if myNote != self.lastMelodyNote {
                self.lastMelodyNote = myNote
                NetworkManager.sharedManager.sendNote(self.lastMelodyNote)
            }
        }
    }

    @IBAction func didTap(sender: UITapGestureRecognizer) {
        let position = sender.locationInView(sender.view);
        let y = sender.view!.frame.size.height - position.y;
        var baseNote:Int!
        var finalNote:Int!
        
        //Base note for left tap is 40, right tap is 70
        if sender.view == self.leftView {
            baseNote = 40
            finalNote = baseNote + Int(y*15/sender.view!.frame.size.height);
            self.lastBassNote = finalNote
        } else {
            baseNote = 70
            finalNote = baseNote + Int(y*15/sender.view!.frame.size.height);
            self.lastMelodyNote = finalNote
        }
        
        NetworkManager.sharedManager.sendNote(finalNote);
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
