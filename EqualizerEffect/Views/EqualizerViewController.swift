//
//  ViewController.swift
//  EqualizerEffect
//
//  Created by 한승진 on 2018. 3. 7..
//  Copyright © 2018년 한승진. All rights reserved.
//

import UIKit


class EqualizerViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var switchMusicOn: UISwitch!
    @IBOutlet weak var switchBypass: UISwitch!
    @IBOutlet var freqsSlides: [UISlider]!

    // Variables
    var audioManager: AudioManager?
    
    let frequencies: [Int] = [32, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    var preSets: [[Float]] = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // My setting
        [4, 6, 5, 0, 1, 3, 5, 4.5, 3.5, 0], // Dance
        [4, 3, 2, 2.5, -1.5, -1.5, 0, 1, 2, 3], // Jazz
        [5, 4, 3.5, 3, 1, 0, 0, 0, 0, 0] // Base Main
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sound Equalizer Example"
  
        // Enable Engine
        audioManager = AudioManager(music: "bensound-energy", frequencies: frequencies)
        
        if let audioManager = audioManager {
            audioManager.delegate = self
            audioManager.setEquailizerOptions(gains: preSets[0])
            audioManager.engineStart()
            audioManager.play()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: AudioManagerDelegate
extension EqualizerViewController: AudioManagerDelegate {
    
    func audioManager(didStart manager: AudioManager) {
        print("music play")
    }
    
    func audioManager(didStop manager: AudioManager) {
        print("music stop")
    }
    
    func audioManager(didPause manager: AudioManager) {
        print("music pause")
    }
}


// MARK: Events
extension EqualizerViewController {
    
    // UISwich
    @IBAction func switchValueChanged(_ sender: Any) {
        if let sender = sender as? UISwitch, let audio = audioManager {
            
            // Music OnOff
            if sender == switchMusicOn {
                if sender.isOn {
                    audio.play()
                } else {
                    audio.pause()
                }
            }

            // Use bypass
            else if sender == switchBypass {
                audio.setBypass(sender.isOn)
            }
        }
    }
    
    // UISlider
    @IBAction func sliderValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            print("slider of index:", slider.tag, "is changed to", slider.value)
            
            guard let audioManager = audioManager else {
                return
            }
            
            // Update equalizer values
            var preSet = audioManager.getEquailizerOptions()
            preSet[slider.tag] = slider.value
            audioManager.setEquailizerOptions(gains: preSet)
        }
    }
    
    // UISegmentedControl
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        if let segmentedControl = sender as? UISegmentedControl {
            print("segmentedControl is selected: ", segmentedControl.selectedSegmentIndex)
            
            guard let audioManager = audioManager else {
                return
            }
            
            // Update Equalizer.
            let index = segmentedControl.selectedSegmentIndex
            audioManager.setEquailizerOptions(gains: preSets[index])
            
            // Update UISliders.
            let preSet = audioManager.getEquailizerOptions()
            for (index, slide) in freqsSlides.enumerated() {
                slide.value = preSet[index]
            }
        }
    }
}
