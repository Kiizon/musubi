cask "musubi" do
  version "1.0.0"
  sha256 "REPLACE_WITH_SHA256_AFTER_RELEASE"

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
