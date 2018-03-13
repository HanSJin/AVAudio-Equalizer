# AVAudio+Equalizer Example for iOS / Swift

[![License](https://img.shields.io/cocoapods/l/Auk.svg?style=flat)](LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/Auk.svg?style=flat)](http://cocoadocs.org/docsets/Auk)

This repository is an iOS sample project that contrains how to use equalizer options created by HanSJin.

## Screenshot

<img src='./screenshot1.png' alt='A screenshot of AVAudio+Equalizer' width='300'>
<img src='./screenshot2.png' alt='A screenshot of AVAudio+Equalizer' width='300'>

## Source

Here are sample preset options.

```swift
var preSet: [[Float]] = [
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // MySetting
  [4, 6, 5, 0, 1, 3, 5, 4.5, 3.5, 0], // Dance
  [4, 3, 2, 2.5, -1.5, -1.5, 0, 1, 2, 3], // Jazz
  [5, 4, 3.5, 3, 1, 0, 0, 0, 0, 0] // BaseMain
]
```

Also you can change detail value.

```swift
EQNode.bands[index].gain = 0.5 // set +0.5dB
```

## Music

This project contains bensound-energy.mp3 as sound sample. You can check the source of this music [here](https://www.bensound.com/royalty-free-music/track/energy).

## License

AVAudio+Equalizer is released under the [MIT License](LICENSE).

