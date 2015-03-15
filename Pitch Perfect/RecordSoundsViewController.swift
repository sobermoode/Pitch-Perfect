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
    
    // button outlets
    // EXTRA CREDIT: pause and restart buttons; see associated functions
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    var audioEngine: AVAudioEngine!
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    // flags to properly pause/unpause recording and re-use file name when restarting recording
    var isPaused: Bool!
    var isRestarting: Bool!
    
    // savedURL will save the URL to re-use when restarting the recording
    var filePath: NSURL!
    var savedURL: NSURL!
    
    override func viewWillAppear( animated: Bool )
    {
        // hide buttons that manipulate the in-progress recording
        pauseButton.hidden = true
        stopButton.hidden = true
        restartButton.hidden = true
        
        // falsify isPaused and isRestarting flags
        isPaused = false
        isRestarting = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        audioEngine = AVAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio( sender: UIButton )
    {
        // disable recording button while a recording is in-progress;
        // to restart a recording, tap the restart button
        recordButton.enabled = false
        
        // code review TASK 4;
        // instead of un-hiding the label, we are updating the text
        recordingLabel.text = "recording..."
        
        // show  manipulator buttons
        pauseButton.hidden = false
        stopButton.hidden = false
        restartButton.hidden = false
        
        // record user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true )[ 0 ] as String
        
        // create a new file if we haven't restarted an in-progress recording
        if( !isRestarting )
        {
            // create the recording filename
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate( currentDateTime ) + ".wav"
            let pathArray = [ dirPath, recordingName ]
            
            // create the file path and save it so we can re-write the file if the user restarts the recording
            filePath = NSURL.fileURLWithPathComponents( pathArray )
            savedURL = filePath
        }
        
        // otherwise, re-use the same file
        else
        {
            filePath = savedURL
        }
        
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
        // check that the recording did successfully finish before doing anything else
        if( flag )
        {
            // save recorded audio;
            // using RecordedAudio constructor
            recordedAudio = RecordedAudio( filePathURL: recorder.url, title: recorder.url.lastPathComponent! )
            
            // perform segue
            /* (i'm assuming that self is required here because this is an AVAudioRecorder function.
            in order to make the RecordSoundsViewController use its own functions, self is required
            from within the other class's funcion. */
            self.performSegueWithIdentifier( "showRecordingSegue", sender: recordedAudio )
        }
        
        // if the recording did not finish successfully, reset the state -
        // re-enable the microphone button and hide the manipulator buttons
        else
        {
            println( "Recording was not successful =/" )
            recordButton.enabled = true
            pauseButton.hidden = true
            stopButton.hidden = true
            restartButton.hidden = true
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
    
    // EXTRA CREDIT
    // just check the state of the isPaused flag;
    // pause() if we are not paused, otherwise, continue record()'ing
    @IBAction func pauseRecording( sender: UIButton )
    {
        if( !isPaused )
        {
            audioRecorder.pause()
            isPaused = true
        }
        else
        {
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
        
        // code review TASK 4;
        // re-enable initial state, so when we return, we don't have to check if
        // the button and label are disabled and set to "recording."
        recordButton.enabled = true
        recordingLabel.text = "Tap to Record"
    }
    
    @IBAction func restartRecording( sender: UIButton )
    {
        // set flag
        isRestarting = true
        
        // isPaused might not have been set; need to test against nil, not just a true/false test
        if( isPaused != nil )
        {
            isPaused = false
        }
        
        recordAudio( restartButton )
    }
}

