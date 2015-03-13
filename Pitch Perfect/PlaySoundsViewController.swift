//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aaron Justman on 3/11/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    
    // this is used to receive the recorded audio from the RecordSoundsViewController
    var recievedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer( contentsOfURL: recievedAudio.filePathURL, error: nil )
        
        // set enableRate to allow slowing down and speeding up the recording audio
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile( forReading: recievedAudio.filePathURL, error: nil )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowDownRecording( sender: UIButton )
    {
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        
        audioPlayer.play()
    }

    @IBAction func accelerateRecording( sender: UIButton )
    {
        audioPlayer.stop()
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0.0
        
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio( sender: UIButton )
    {
        playAudioWithVariablePitch( 1000 )
    }
    
    // the chipmunk and Darth Vader effects both use this function to create their effects
    func playAudioWithVariablePitch( pitch: Float )
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode( audioPlayerNode )
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode( changePitchEffect )
        
        audioEngine.connect( audioPlayerNode, to: changePitchEffect, format: nil )
        audioEngine.connect( changePitchEffect, to: audioEngine.outputNode, format: nil )
        
        audioPlayerNode.scheduleFile( audioFile, atTime: nil, completionHandler: nil )
        
        audioEngine.startAndReturnError( nil )
        
        audioPlayerNode.play()
    }
    
    @IBAction func playDarthVaderAudio( sender: UIButton )
    {
        playAudioWithVariablePitch( -1000 )
    }
    
    @IBAction func stopPlayback( sender: UIButton )
    {
        audioPlayer.stop()
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
