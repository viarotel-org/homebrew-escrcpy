# homebrew-escrcpy

Distributing escrcpy via homebrew

## Installation


### Add an escrcpy repository


### Trust the tap

Recent Homebrew versions refuse to install casks from untrusted taps.

```shell
brew trust viarotel-org/escrcpy
```

### Install escrcpy

```shell
brew install --cask escrcpy
```

### Fixed open app prompt corrupted

```shell
sudo spctl --master-disable
sudo xattr -r -d com.apple.quarantine /Applications/Escrcpy.app
```

## Uninstall escrcpy

```shell
brew uninstall --zap escrcpy
```