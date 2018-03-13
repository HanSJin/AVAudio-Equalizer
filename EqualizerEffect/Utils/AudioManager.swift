//
//  AudioEngine.swift
//  EqualizerEffect
//
//  Created by 한승진 on 2018. 3. 12..
//  Copyright © 2018년 한승진. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioManagerDelegate: class {
    func audioManager(didStart manager: AudioManager)
    func audioManager(didStop manager: AudioManager)
    func audioManager(didPause manager: AudioManager)
}

class AudioManager {
    weak var delegate: AudioManagerDelegate?
    
    // Variables
    fileprivate let player = AVAudioPlayerNode()
    fileprivate let audioEngine = AVAudioEngine()
    fileprivate var audioFileBuffer: AVAudioPCMBuffer?
    fileprivate var EQNode: AVAudioUnitEQ?
    
    init?(music: String, frequencies: [Int]) {
        setUpEngine(with: music, frequencies: frequencies)
    }
    
    fileprivate func setUpEngine(with name: String, frequencies: [Int]) {
        // Load a music file
        do {
            guard let musicUrl = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
            let audioFile = try AVAudioFile(forReading: musicUrl)
            audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: UInt32(audioFile.length))
            try audioFile.read(into: audioFileBuffer!)
        } catch {
            assertionFailure("failed to load the music. Error: \(error)")
            return
        }
        
        // initial Equalizer.
        EQNode = AVAudioUnitEQ(numberOfBands: frequencies.count)
        EQNode!.globalGain = 1
        for i in 0...(EQNode!.bands.count-1) {
            EQNode!.bands[i].frequency  = Float(frequencies[i])
            EQNode!.bands[i].gain       = 0
            EQNode!.bands[i].bypass     = false
            EQNode!.bands[i].filterType = .parametric
        }
        
        // Attach nodes to an engine.
        audioEngine.attach(EQNode!)
        audioEngine.attach(player)
        
        // Connect player to the EQNode.
        let mixer = audioEngine.mainMixerNode
        audioEngine.connect(player, to: EQNode!, format: mixer.outputFormat(forBus: 0))
        
        // Connect the EQNode to the mixer.
        audioEngine.connect(EQNode!, to: mixer, format: mixer.outputFormat(forBus: 0))
        
        // Schedule player to play the buffer on a loop.
        if let audioFileBuffer = audioFileBuffer {
            player.scheduleBuffer(audioFileBuffer, at: nil, options: .loops, completionHandler: nil)
        }
    }
}


// MARK: State Update
extension AudioManager {
    public func isEngineRunning() -> Bool {
        return audioEngine.isRunning
    }
    
    public func engineStart() {
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            assertionFailure("failed to audioEngine start. Error: \(error)")
        }
    }
    
    public func play() {
        player.play()
        delegate?.audioManager(didStart: self)
    }
    
    public func stop() {
        player.stop()
        delegate?.audioManager(didStop: self)
    }
    
    public func pause() {
        player.pause()
        delegate?.audioManager(didStart: self)
    }
}


// MARK: GET, SET
extension AudioManager {
    public func setBypass(_ isOn: Bool) {
        for i in 0...(EQNode!.bands.count-1) {
            EQNode!.bands[i].bypass = isOn
        }
    }
    
    public func setEquailizerOptions(gains: [Float]) {
        guard let EQNode = EQNode else {
            return
        }
        for i in 0...(EQNode.bands.count-1) {
            EQNode.bands[i].gain = gains[i]
        }
    }
    
    public func getEquailizerOptions() -> [Float] {
        guard let EQNode = EQNode else {
            return []
        }
        return EQNode.bands.map { $0.gain }
    }
}
