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
    var hidingMenu = true
    
    //The note that is played for the left side on mid-height
    var baseNoteLeft = 48 {
        //The didSet methods are called every time the value is updated
        didSet {
            leftLabel.text = noteStringForPitch(baseNoteLeft)
            NetworkManager.sharedManager.sendNote(baseNoteLeft)
        }
    }
    //The note that is played for the right side on mid-height
    var baseNoteRight = 72 {
        didSet {
            rightLabel.text = noteStringForPitch(baseNoteRight)
            NetworkManager.sharedManager.sendNote(baseNoteRight)
        }
    }
    
    //Last note played by the left side
    var lastNoteLeft = 48 {
        didSet {
            //Update the label when this value is changed
            leftLabel.text = noteStringForPitch(lastNoteLeft)
        }
    }
    //Last note played by the right side
    var lastNoteRight = 72 {
        didSet {
            //Update the label when this value is changed
            rightLabel.text = noteStringForPitch(lastNoteRight)
        }
    }
    
    //Layout setup
    lazy var leftView:UIView = {
        let theView = UIView()
        theView.backgroundColor = UIColor.redColor()
        return theView
    }()
    
    lazy var rightView:UIView = {
        let theView = UIView()
        theView.backgroundColor = UIColor.blueColor()
        return theView
    }()
    
    //Create a new label with the default font and text color
    func myDefaultLabel() -> UILabel {
        let theLabel = UILabel()
        theLabel.font = UIFont(name: "Didot", size: 60.0)
        theLabel.textColor = UIColor.whiteColor()
        return theLabel
    }
    
    //Create and position the label for the left side
    lazy var leftLabel:UILabel = {
        let label = self.myDefaultLabel()
        self.leftView.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.leftView)
        }
        return label
    }()
    //Create and position the label for the right side
    lazy var rightLabel:UILabel = {
        let label = self.myDefaultLabel()
        self.rightView.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.rightView)
        }
        return label
    }()
    
    //Create a default stepper to pick the base notes
    func myDefaultStepper() -> UIStepper {
        let stepper = UIStepper()
        stepper.maximumValue = 127
        stepper.minimumValue = 0
        stepper.tintColor = UIColor.whiteColor()
        //The method that is called whenever the value on the stepper is changed
        stepper.addTarget(self, action: "stepperValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        stepper.hidden = true
        return stepper
    }
    
    //Create and position the stepper below the left label
    lazy var leftStepper:UIStepper = {
        let stepper = self.myDefaultStepper()
        stepper.value = Double(self.baseNoteLeft)
        self.leftView.addSubview(stepper)
        stepper.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.leftView)
            make.top.equalTo(self.leftLabel.snp_bottom)
        }
        return stepper
    }()
    
    //Create and position the stepper below the right label
    lazy var rightStepper:UIStepper = {
        let stepper = self.myDefaultStepper()
        stepper.value = Double(self.baseNoteRight)
        self.rightView.addSubview(stepper)
        stepper.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.rightView)
            make.top.equalTo(self.rightLabel.snp_bottom)
        }
        return stepper
    }()
    
    let pitchLetters = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    
    //Convert a pitch number to Letter + Octave representation
    func noteStringForPitch(pitchNumber: Int!) -> String {
        let pitchClass = pitchLetters[pitchNumber % 12]
        let octave = pitchNumber/12
        
        return "\(pitchClass)\(octave)"
    }
    
    //Limit an int to the 0-127 range
    func noteInPitchRange(note: Int) -> Int! {
        if note > 127 {return 127}
        if note < 0 {return 0}
        return note
    }
    
    func configureViews() {
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
    }
    
    func configureGestures() {
        //Add pan and tap gesture recognizers to the left side of the screen
        let leftPan = UIPanGestureRecognizer(target: self, action: Selector("didPan:"))
        let leftTap = UITapGestureRecognizer(target: self, action: Selector("didTap:"))

        self.leftView.addGestureRecognizer(leftPan)
        self.leftView.addGestureRecognizer(leftTap)
        
        //Add pan and tap gesture recognizers to the right side of the screen
        let rightPan = UIPanGestureRecognizer(target: self, action: Selector("didPan:"))
        let rightTap = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
        self.rightView.addGestureRecognizer(rightPan)
        self.rightView.addGestureRecognizer(rightTap)
    }
    
    @IBAction func showHideMenu() {
        hidingMenu = !hidingMenu
        self.leftStepper.hidden = hidingMenu
        self.rightStepper.hidden = hidingMenu
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureGestures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This method is called when a pan action happens on the screen
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(sender.view)
        let yTranslation = -1*translation.y
        let noteChange = Int(yTranslation/48.0)
        
        //Check which side of the screen the touch was in
        if sender.view == self.leftView {
            let myNote = noteInPitchRange(baseNoteLeft + noteChange)
            if myNote != self.lastNoteLeft {
                self.lastNoteLeft = myNote
                NetworkManager.sharedManager.sendNote(self.lastNoteLeft)
            }
        } else {
            let myNote = noteInPitchRange(baseNoteRight + noteChange)
            if myNote != self.lastNoteRight {
                self.lastNoteRight = myNote
                NetworkManager.sharedManager.sendNote(self.lastNoteRight)
            }
        }
    }
    
    //This method is called when a tap happens
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        let position = sender.locationInView(sender.view);
        let y = sender.view!.frame.size.height/2 - position.y;
        var finalNote:Int!
        
        if sender.view == self.leftView {
            finalNote = noteInPitchRange(baseNoteLeft + Int(y*15/sender.view!.frame.size.height))
            self.lastNoteLeft = finalNote
        } else {
            finalNote = noteInPitchRange(baseNoteRight + Int(y*15/sender.view!.frame.size.height))
            self.lastNoteRight = finalNote
        }
        
        NetworkManager.sharedManager.sendNote(finalNote)
    }
    
    func stepperValueChanged(sender: UIStepper) {
        if sender.superview == self.leftView {
            self.baseNoteLeft = Int(sender.value)
        } else {
            self.baseNoteRight = Int(sender.value)
        }
    }
}
