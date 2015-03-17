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
    
    // options for sound effects
    let snailSpeed: Float = 0.5
    let rabbitSpeed: Float = 2.0
    let chipmunkPitch: Float = 1000
    let darthVaderPitch: Float = -1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathURL, error: nil)
        
        // set enableRate to allow slowing down and speeding up the recording audio
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        // code review TASK 3
        // stop and reset all current playback
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    // this function handles all playback with effects
    @IBAction func playAudioWithEffect(sender: UIButton) {
        // code review TASK 3
        // stop and reset all current playback
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // determine which effect button was pressed and set all necessary properties
        if(sender.tag == 1 || sender.tag == 2) {
            audioPlayer.rate = (sender.tag == 1) ? snailSpeed : rabbitSpeed
            audioPlayer.currentTime = 0.0
            audioPlayer.play()
        }
        else {
            var audioPlayerNode = AVAudioPlayerNode()
            audioEngine.attachNode(audioPlayerNode)
            
            // pointer to the configured effect
            var effectNode: AVAudioNode!
            
            if(sender.tag == 3 || sender.tag == 4) {
                var pitchEffect = AVAudioUnitTimePitch()
                pitchEffect.pitch = (sender.tag == 3) ? chipmunkPitch : darthVaderPitch
                effectNode = pitchEffect
            }
            else if(sender.tag == 5) {
                var reverbEffect = AVAudioUnitReverb()
                reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
                reverbEffect.wetDryMix = 42.0
                effectNode = reverbEffect
            }
            else if(sender.tag == 6) {
                var echoEffect = AVAudioUnitDelay()
                echoEffect.delayTime = 0.5
                echoEffect.feedback = 75
                echoEffect.wetDryMix = 42.0
                effectNode = echoEffect
            }
            
            // connect the effect to the engine
            audioEngine.attachNode(effectNode)
            audioEngine.connect(audioPlayerNode, to: effectNode, format: nil)
            audioEngine.connect(effectNode, to: audioEngine.outputNode, format: nil)
            
            // play the recording with applied effect
            audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
            audioEngine.startAndReturnError(nil)
            audioPlayerNode.play()
        }
    }
    
    @IBAction func stopPlayback(sender: UIButton)
    {
        audioPlayer.stop()
        
        // code review TASK 3 - supplemental;
        // pressing the stop button while the chipmunk or dark vader playback was active
        // did not stop the playback. this is because the pitch effect is controlled by
        // the audioEndine, not the audioPlayer. So, the audioEngine needs to be stopped
        // and reseted to fix this additional bug.
        audioEngine.stop()
        audioEngine.reset()
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
