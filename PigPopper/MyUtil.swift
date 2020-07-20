//
//  MyUtil.swift
//  PigPopper
//
//  Created by Evan Corriere on 7/17/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!
var playing = false

func playBackgroundMusic(filename: String) {
    if playing {
        return
    }
    
  let resourceUrl = Bundle.main.url(forResource:
    filename, withExtension: nil)
  guard let url = resourceUrl else {
    print("Could not find file: \(filename)")
    return
  }

  do {
    try backgroundMusicPlayer =
      AVAudioPlayer(contentsOf: url)
    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
    playing = true
  } catch {
    print("Could not create audio player!")
    return
  }
}
