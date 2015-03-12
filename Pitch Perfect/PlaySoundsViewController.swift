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
    var recievedAudio: RecordedAudio!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        if let mp3FilePath = NSBundle.mainBundle().pathForResource( "movie_quote", ofType: "mp3" )
//        {
//            let mp3FileURL = NSURL.fileURLWithPath( mp3FilePath )
//            audioPlayer = AVAudioPlayer(contentsOfURL: mp3FileURL, error: nil )
//            audioPlayer.enableRate = true
//        }
//        else
//        {
//            println( "Couldn't find the movie quote file =/" )
//        }
        
        audioPlayer = AVAudioPlayer( contentsOfURL: recievedAudio.filePathURL, error: nil )
        audioPlayer.enableRate = true
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
