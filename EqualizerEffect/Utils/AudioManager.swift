//
//  AudioEngine.swift
//  EqualizerEffect
//
//  Created by 한승진 on 2018. 3. 12..
//  Copyright © 2018년 한승진. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager {
    
    // Variables
    fileprivate let player = AVAudioPlayerNode()
    fileprivate let audioEngine: AVAudioEngine = AVAudioEngine()
    fileprivate var audioFileBuffer: AVAudioPCMBuffer?
    fileprivate var EQNode: AVAudioUnitEQ = AVAudioUnitEQ(numberOfBands: 10)
    
    fileprivate var selectedFreSetIndex = 0
    fileprivate let frequencies = [32, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    
    // Setting values of Equalizer freset option
    fileprivate var preSet: [[Float]] = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // My setting
        [4, 6, 5, 0, 1, 3, 5, 4.5, 3.5, 0], // Dance
        [4, 3, 2, 2.5, -1.5, -1.5, 0, 1, 2, 3], // Jazz
        [5, 4, 3.5, 3, 1, 0, 0, 0, 0, 0] // Base Main
    ]
    
    init() {
        setUpEngine()
    }
    
    fileprivate func setUpEngine() {
        do {
            // Load a mp3 file
            guard let musicUrl = Bundle.main.url(forResource: "bensound-energy", withExtension: "mp3") else { return }
            let audioFile = try AVAudioFile(forReading: musicUrl)
            audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: UInt32(audioFile.length))
            try audioFile.read(into: audioFileBuffer!)
        } catch {
            assertionFailure("failed to load the music. Error: \(error)")
        }
        
        // EQ initialize.
        EQNode.globalGain = 1
        for i in 0...(EQNode.bands.count-1) {
            EQNode.bands[i].frequency  = Float(frequencies[i])
            EQNode.bands[i].gain       = 0
            EQNode.bands[i].bypass     = false
            EQNode.bands[i].filterType = .parametric
        }
        
        // Attack nodes to an engine.
        audioEngine.attach(EQNode)
        audioEngine.attach(player)
        
        // Connect player to the EQNode.
        let mixer = audioEngine.mainMixerNode
        audioEngine.connect(player, to: EQNode, format: mixer.outputFormat(forBus: 0))
        
        // Connect the EQNode to the mixer.
        audioEngine.connect(EQNode, to: mixer, format: mixer.outputFormat(forBus: 0))
        
        // Schedule player to play the buffer on a loop.
        if let audioFileBuffer = audioFileBuffer {
            player.scheduleBuffer(audioFileBuffer, at: nil, options: .loops, completionHandler: nil)
        }
        
        // Start the audio engine
        engineStart()
        play()
    }
}


// MARK: State Update
extension AudioManager {
    func engineStart() {
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            assertionFailure("failed to audioEngine start. Error: \(error)")
        }
    }
    
    func play() {
        player.play()
    }
    
    func stop() {
        player.stop()
    }
    
    func pause() {
        player.pause()
    }
    
    func isEngineRunning() -> Bool {
        return audioEngine.isRunning
    }
}


// MARK: Update Values
extension AudioManager {
    func getCurrentFreSet() -> [Float] {
        return preSet[selectedFreSetIndex]
    }
    
    func updateSelectedIndex(with index: Int) {
        selectedFreSetIndex = index
    }
    
    func updateBypass(to isOn: Bool) {
        for i in 0...(EQNode.bands.count-1) {
            EQNode.bands[i].bypass = isOn
        }
    }
    
    func updateFreSetGain() {
        for i in 0...(EQNode.bands.count-1) {
            EQNode.bands[i].gain = preSet[selectedFreSetIndex][i]
        }
    }
    
    func updateEqualizer(with index: Int, value: Float) {
        EQNode.bands[index].gain = value
        preSet[selectedFreSetIndex][index] = value
    }
}
