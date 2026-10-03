cask "escrcpy" do
  arch arm: "arm64", intel: "x64"

  version "3.2.0"
  sha256 arm:   "cb201c25c819c5d942ebefd8e21fef6280a241927feebba2c092a11b92768ac4",
         intel: "bba0dba3b4a26a12b52d2caa6c623018250d201e893f4533c37c5dd635ea7efe"

  url "https://github.com/viarotel-org/escrcpy/releases/download/v#{version}/Escrcpy-#{version}-mac-#{arch}.dmg"
  name "Escrcpy"
  desc "Graphical Scrcpy to display and control Android, devices powered by Electron"
  homepage "https://github.com/viarotel-org/escrcpy"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  auto_updates false
  depends_on :macos

  app "Escrcpy.app"

  postflight_steps do
    # Strip the quarantine attribute so the app is not reported as damaged on first launch.
    # `xattr -d` exits 0 when the attribute is already absent, so this is a no-op on
    # subsequent runs and needs neither sudo nor an interactive prompt.
    run "/usr/bin/xattr",
        args: ["-r", "-d", "com.apple.quarantine", "/Applications/Escrcpy.app"]
  end

  uninstall quit: "org.viarotel.escrcpy"

  zap trash: [
    "~/Library/Application Support/escrcpy",
    "~/Library/Logs/escrcpy",
    "~/Library/Preferences/org.viarotel.escrcpy.plist",
    "~/Library/Saved Application State/org.viarotel.escrcpy.savedState",
  ]

  caveats <<~EOS
    1. Escrcpy includes built-in adb support.
    2. In some cases you may need to manually install scrcpy to resolve compatibility issues
    3. Make sure USB debugging is enabled on your Android device.
    4. For wireless connection, your device needs to be on the same network.
    5. Recent Homebrew versions require `brew trust viarotel-org/escrcpy` before installing.
  EOS
end
