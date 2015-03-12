//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Aaron Justman on 3/10/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
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
        recordButton.enabled = false
        recordingLabel.hidden = false
        stopButton.hidden = false
    }
    
    @IBAction func stopRecording( sender: UIButton )
    {
        recordButton.enabled = true
        recordingLabel.hidden = true
        stopButton.hidden = true
    }
}

