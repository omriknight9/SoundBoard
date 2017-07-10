//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Omri Shalev on 10/07/2017.
//  Copyright © 2017 Omri Shalev. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var soundNameTxt: UITextField!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    var audioRecorder: AVAudioRecorder? = nil
    var audioPlayer: AVAudioPlayer?
    var audioURL: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playBtn.isEnabled = false
        addBtn.isEnabled = false
    }
    
    func setupRecorder() {
        do {
            // Create an Audio Session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            // Create URL for the audio file
            
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComonents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComonents)!
        
            
            // Create settings for the audio recorder
            
            var settings: [String: AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
            // Create AudioRecorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func RecordTapped(_ sender: Any) {
        if audioRecorder!.isRecording {
            // Stop the recording
            audioRecorder?.stop()
            
            // Change button title to record
            recordBtn.setTitle("Record", for: .normal)
            playBtn.isEnabled = true
            addBtn.isEnabled = true
        } else {
            // Start the recordng
            audioRecorder?.record()
            
            // Change button title to stop
            recordBtn.setTitle("Stop", for: .normal)
        }
    }
    @IBAction func PlayTapped(_ sender: Any) {
        do{
           try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {
            
        }
        
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = soundNameTxt.text
        sound.audio = NSData(contentsOf: audioURL!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
    }
    
}









