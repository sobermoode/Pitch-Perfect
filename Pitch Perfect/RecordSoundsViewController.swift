//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aaron Justman on 3/10/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    var isPaused: Bool = false
    
    override func viewWillAppear( animated: Bool )
    {
        pauseButton.hidden = true
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
        pauseButton.hidden = false
        stopButton.hidden = false
        
        // record user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true )[ 0 ] as String
        
        // create the recording filename
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate( currentDateTime ) + ".wav"
        let pathArray = [ dirPath, recordingName ]
        let filePath = NSURL.fileURLWithPathComponents( pathArray )
        println( filePath )
        
        // set up the audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory( AVAudioSessionCategoryPlayAndRecord, error: nil )
        
        // initialize and prepare the recorder
        audioRecorder = AVAudioRecorder( URL: filePath, settings: nil, error: nil )
        
        // the RecordSoundsViewController will override functions from the AVAudioRecorder class
        audioRecorder.delegate = self
        
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording( recorder: AVAudioRecorder!, successfully flag: Bool )
    {
        if( flag )
        {
            // save recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            // perform segue
            /* (i'm assuming that self is required here because this is an AVAudioRecorder function.
            in order to make the RecordSoundsViewController use its own functions, self is required
            from within the other class's funcion. */
            self.performSegueWithIdentifier( "showRecordingSegue", sender: recordedAudio )
        }
        else
        {
            println( "Recording was not successful =/" )
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue( segue: UIStoryboardSegue, sender: AnyObject? )
    {
        if( segue.identifier == "showRecordingSegue" )
        {
            let playSoundsViewController: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsViewController.recievedAudio = data
        }
    }
    
        
    @IBAction func pauseRecording( sender: UIButton )
    {
        if( !isPaused )
        {
            println( "Pausing the recording..." )
            audioRecorder.pause()
            isPaused = true
        }
        else
        {
            println( "Unpausing the recording..." )
            audioRecorder.record()
            isPaused = false
        }
    }
    
    @IBAction func stopRecording( sender: UIButton )
    {
        // stop the current recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive( false, error: nil )
        
        // hide buttons
        recordButton.enabled = true
        recordingLabel.hidden = true
        stopButton.hidden = true
    }
}

