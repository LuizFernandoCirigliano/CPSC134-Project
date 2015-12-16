//
//  PlayerViewController.swift
//  CPSC134
//
//  Created by Luiz Fernando 2 on 11/26/15.
//  Copyright © 2015 CiriglianoApps. All rights reserved.
//

import UIKit
import SnapKit

class PlayerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let instruments = ["PIANO", "BRIGHT_ACOUSTIC", "ELECTRIC_GRAND", "HONKYTONK_PIANO", "EPIANO1", "EPIANO2", "HARPSICHORD", "CLAVINET", "CELESTA", "GLOCKENSPIEL", "MUSIC_BOX", "VIBRAPHONE", "MARIMBA", "XYLOPHONE", "TUBULAR_BELLS", "DULCIMER", "DRAWBAR_ORGAN", "PERCUSSIVE_ORGAN", "ROCK_ORGAN", "CHURCH_ORGAN", "REED_ORGAN", "ACCORDION", "HARMONICA", "TANGO_ACCORDION", "NYLON_GUITAR", "STEEL_GUITAR", "JAZZ_GUITAR", "CLEAN_GUITAR", "MUTED_GUITAR", "OVERDRIVEN_GUITAR", "DISTORTION_GUITAR", "GUITAR_HARMONICS", "ACOUSTIC_BASS", "BASS", "PICKED_BASS", "FRETLESS_BASS", "SLAP_BASS1", "SLAP_BASS2", "SYNTH_BASS1", "SYNTH_BASS2", "VIOLIN", "VIOLA", "CELLO", "CONTRABASS", "TREMOLO_STRINGS", "PIZZICATO_STRINGS", "ORCHESTRAL_HARP", "TIMPANI", "STRING_ENSEMBLE1", "STRING_ENSEMBLE2", "SYNTH_STRINGS1", "SYNTH_STRINGS2", "CHOIR", "VOICE", "SYNTH_VOICE", "ORCHESTRA_HIT", "TRUMPET", "TROMBONE", "TUBA", "MUTED_TRUMPET", "HORN", "BRASS", "SYNTH_BRASS1", "SYNTH_BRASS2", "SOPRANO_SAX", "ALTO_SAX", "TENOR_SAX", "BARITONE_SAX", "OBOE", "ENGLISH_HORN", "BASSOON", "CLARINET", "PICCOLO", "FLUTE", "RECORDER", "PAN_FLUTE", "BOTTLE", "SHAKUHACHI", "WHISTLE", "OCARINA", "SQUARE", "SAWTOOTH", "CALLIOPE", "CHIFF", "CHARANG", "SOLO_VOX", "FIFTHS", "BASS_LEAD", "NEW_AGE", "WARM_PAD", "POLYSYNTH", "SPACE_VOICE", "BOWED_GLASS", "METALLIC", "HALO", "SWEEP", "ICE_RAIN", "SOUNDTRACK", "CRYSTAL", "ATMOSPHERE", "BRIGHTNESS", "GOBLINS", "ECHO_DROPS", "SCI_FI", "SITAR", "BANJO", "SHAMISEN", "KOTO", "KALIMBA", "BAGPIPE", "FIDDLE", "SHANNAI", "BELL", "AGOGO", "STEEL_DRUMS", "WOODBLOCK", "TAIKO", "TOM_TOM", "SYNTH_DRUM", "REVERSE_CYMBAL", "FRET_NOISE", "BREATH", "SEA", "BIRD", "TELEPHONE", "HELICOPTER", "APPLAUSE", "GUNSHOT"]
    
    var hidingMenu = true
    
    //The note that is played for the left side on mid-height
    var baseNoteLeft = 48 {
        //The didSet methods are called every time the value is updated
        didSet {
            leftLabel.text = noteStringForPitch(baseNoteLeft)
            NetworkManager.sharedManager.sendNote(baseNoteLeft, channel: 0)
        }
    }
    //The note that is played for the right side on mid-height
    var baseNoteRight = 72 {
        didSet {
            rightLabel.text = noteStringForPitch(baseNoteRight)
            NetworkManager.sharedManager.sendNote(baseNoteRight, channel: 1)
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
            make.bottom.equalTo(self.leftLabel.snp_top)
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
            make.bottom.equalTo(self.rightLabel.snp_top)
        }
        return stepper
    }()
    
    func myDefaultPicker() -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.hidden = true
        picker.tintColor = UIColor.whiteColor()

        return picker
    }
    lazy var leftInstrumentPicker:UIPickerView = {
        let picker = self.myDefaultPicker()
        self.leftView.addSubview(picker)
        picker.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.leftView)
            make.top.equalTo(self.leftLabel.snp_bottom)
        }
        return picker
    }()

    lazy var rightInstrumentPicker:UIPickerView = {
        let picker = self.myDefaultPicker()
        self.rightView.addSubview(picker)
        picker.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.rightView)
            make.top.equalTo(self.rightLabel.snp_bottom)
        }
        return picker
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
        let leftPress = UILongPressGestureRecognizer(target: self, action: Selector("didLongPress:"))
        self.leftView.addGestureRecognizer(leftPan)
        self.leftView.addGestureRecognizer(leftTap)
        self.leftView.addGestureRecognizer(leftPress)
        
        //Add pan and tap gesture recognizers to the right side of the screen
        let rightPan = UIPanGestureRecognizer(target: self, action: Selector("didPan:"))
        let rightTap = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
        let rightPress = UILongPressGestureRecognizer(target: self, action: Selector("didLongPress:"))
        self.rightView.addGestureRecognizer(rightPan)
        self.rightView.addGestureRecognizer(rightTap)
        self.rightView.addGestureRecognizer(rightPress)
    }
    
    @IBAction func showHideMenu() {
        hidingMenu = !hidingMenu
        self.leftStepper.hidden = hidingMenu
        self.rightStepper.hidden = hidingMenu
        self.rightInstrumentPicker.hidden = hidingMenu
        self.leftInstrumentPicker.hidden = hidingMenu
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
    func didPan(sender: UIPanGestureRecognizer) {
        let defaultPanNoteDuration = 200
        let translation = sender.translationInView(sender.view)
        let yTranslation = -1*translation.y
        let noteChange = Int(yTranslation/48.0)
        
        //Check which side of the screen the touch was in
        if sender.view == self.leftView {
            let myNote = noteInPitchRange(baseNoteLeft + noteChange)
            if myNote != self.lastNoteLeft {
                self.lastNoteLeft = myNote
                NetworkManager.sharedManager.sendNote(self.lastNoteLeft, duration: defaultPanNoteDuration, channel:0)
            }
        } else {
            let myNote = noteInPitchRange(baseNoteRight + noteChange)
            if myNote != self.lastNoteRight {
                self.lastNoteRight = myNote
                NetworkManager.sharedManager.sendNote(self.lastNoteRight, duration: defaultPanNoteDuration, channel:1)
            }
        }
    }
    

    //This method is called when a tap happens
    func didLongPress(sender: UITapGestureRecognizer) {
        let position = sender.locationInView(sender.view);
        let y = sender.view!.frame.size.height/2 - position.y;
        
        var finalNote:Int!
        let channel = sender.view == self.leftView ? 0 : 1
        let baseNote = channel == 0 ? self.baseNoteLeft : self.baseNoteRight
        let lastNote = channel == 0 ? self.lastNoteLeft : self.lastNoteRight
        
        if sender.state == .Ended {
            NetworkManager.sharedManager.sendNoteOff(lastNote, channel: channel)
        } else {
            finalNote = noteInPitchRange(baseNote + Int(y*15/sender.view!.frame.size.height))
            
            if sender.state == .Changed {
                if lastNote == finalNote {
                    return
                } else {
                    NetworkManager.sharedManager.sendNoteOff(lastNote, channel: channel)
                }
            }
            
            if channel == 0 {
                self.lastNoteLeft = finalNote
            } else {
                self.lastNoteRight = finalNote
            }
            NetworkManager.sharedManager.sendNoteOn(finalNote, channel: channel)
        }
    }
    //This method is called when a tap happens
    func didTap(sender: UITapGestureRecognizer) {
        let position = sender.locationInView(sender.view);
        let y = sender.view!.frame.size.height/2 - position.y;
        let x = position.x / sender.view!.frame.size.width
        let duration = Int(x*2000)
        
        var finalNote:Int!
        var channel:Int!
        
        if sender.view == self.leftView {
            finalNote = noteInPitchRange(baseNoteLeft + Int(y*15/sender.view!.frame.size.height))
            channel = 0
            self.lastNoteLeft = finalNote
        } else {
            finalNote = noteInPitchRange(baseNoteRight + Int(y*15/sender.view!.frame.size.height))
            channel = 1
            self.lastNoteRight = finalNote
        }
        
        NetworkManager.sharedManager.sendNote(finalNote, duration: duration, channel: channel)
    }
    
    //MARK: Stepper Delegate
    func stepperValueChanged(sender: UIStepper) {
        if sender.superview == self.leftView {
            self.baseNoteLeft = Int(sender.value)
        } else {
            self.baseNoteRight = Int(sender.value)
        }
    }
    
    //MARK: Picker DataSource/Delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.instruments.count
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let channel = pickerView == self.leftInstrumentPicker ? 0 : 1
        let lastNote = channel == 0 ? self.lastNoteLeft : self.lastNoteRight
        NetworkManager.sharedManager.sendInstrument(row, channel: channel)
        NetworkManager.sharedManager.sendNote(lastNote, channel: channel)
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = self.instruments[row]
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
}
