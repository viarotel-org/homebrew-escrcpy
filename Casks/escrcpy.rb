cask "escrcpy" do
  arch arm: "arm64", intel: "x64"

  version "1.34.0"
  sha256 arm:   "e104b510744aecb0d6ee618aa5abb9f57596af98396ce993afe631c92d73da79",
         intel: "a861a4889e72c07cccb404c409b43440612f31bae1aa8d346f72c753dfbc2465"

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
  depends_on macos: ">= :catalina"

  app "Escrcpy.app"

  postflight do
    app_path = "/Applications/Escrcpy.app"

    unless File.exist?(app_path)
      opoo "Application not found at #{app_path}"
      return
    end

    xattr_path = `which xattr`.chomp
    quarantine_status = system_command(xattr_path,
                                       args:         ["-l", app_path],
                                       print_stderr: false).stdout
    if quarantine_status.include?("com.apple.quarantine")
      puts "\n============================================="
      puts "Would you like to remove the quarantine attribute to fix the app damage issue?"
      puts "This will prevent the 'app is damaged' warning."
      puts "Enter 'Y' or press Enter to proceed, 'n' to skip"
      puts "============================================="

      input = $stdin.gets.chomp.downcase
      if input.empty? || input == "y"
        system_command "/usr/bin/sudo",
                       args: [xattr_path, "-r", "-d", "com.apple.quarantine", app_path],
                       sudo: true
        puts "\n✅ Successfully removed quarantine attribute."
        puts "You can now launch the application normally."
      else
        puts "\n⏭️  Skipped removing quarantine attribute."
        puts "You may need to right-click the app and select 'Open' for first launch."
      end
    else
      puts "\n✨ Quarantine attribute is not present. No action needed."
    end
  rescue => e
    opoo "Error during postflight: #{e.message}"
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
  EOS
end
