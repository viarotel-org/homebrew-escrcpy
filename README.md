# homebrew-escrcpy

Distributing escrcpy via homebrew

## Installation


### Add an escrcpy repository

```shell
brew tap viarotel-org/escrcpy
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