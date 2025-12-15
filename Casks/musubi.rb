cask "musubi" do
  version "1.0.0"
  sha256 "9931dcbad2768e3633050f6d2be57bf4bde5d0effedabf75e333de6b8fb0f07f"

  url "https://github.com/Kiizon/musubi/releases/download/v#{version}/musubi-#{version}.zip"
  name "musubi"
  desc "Minimal macOS menu bar timer with task tracking"
  homepage "https://github.com/Kiizon/musubi"

  depends_on macos: ">= :sequoia"

  app "musubi.app"

  zap trash: [
    "~/Library/Preferences/kish.musubi.plist",
  ]
end
