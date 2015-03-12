//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aaron Justman on 3/10/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewWillAppear( animated: Bool )
    {
        stopButton.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio( sender: UIButton )
    {
        // hide onscreen buttons
        recordButton.enabled = false
        recordingLabel.hidden = false
        stopButton.hidden = false
        
        // record user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true )[ 0 ] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate( currentDateTime ) + ".wav"
        let pathArray = [ dirPath, recordingName ]
        let filePath = NSURL.fileURLWithPathComponents( pathArray )
        println( filePath )
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory( AVAudioSessionCategoryPlayAndRecord, error: nil )
        
        audioRecorder = AVAudioRecorder( URL: filePath, settings: nil, error: nil )
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording( sender: UIButton )
    {
        // stop the current recording
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive( false, error: nil )
        
        // show buttons
        recordButton.enabled = true
        recordingLabel.hidden = true
        stopButton.hidden = true
    }
}

