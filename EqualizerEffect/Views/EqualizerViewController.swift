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
    let audioManager = AudioManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sound Equalizer Example"
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        if let sender = sender as? UISwitch {
            // Music OnOff
            if sender == switchMusicOn {
                print("music on/off", sender.isOn)
                if sender.isOn {
                    audioManager.play()
                } else {
                    audioManager.pause()
                }
            }
            
            // Use bypass
            else if sender == switchBypass {
                print("use bypass", sender.isOn)
                audioManager.updateBypass(to: sender.isOn)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: View Update & Events
extension EqualizerViewController {
    @IBAction func sliderValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            print("slider of index:", slider.tag, "is changed to", slider.value)
            audioManager.updateEqualizer(with: slider.tag, value: slider.value)
        }
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        if let segmentedControl = sender as? UISegmentedControl {
            print("segmentedControl is selected: ", segmentedControl.selectedSegmentIndex)
            
            // Eq update.
            audioManager.updateSelectedIndex(with: segmentedControl.selectedSegmentIndex)
            audioManager.updateFreSetGain()
            
            // Eq slider update.
            updateSliderValue(with: audioManager.getCurrentFreSet())
        }
    }
    
    // update value of sliders
    func updateSliderValue(with freSet: [Float]) {
        for (index, slide) in freqsSlides.enumerated() {
            slide.value = freSet[index]
        }
    }
}

