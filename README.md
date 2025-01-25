# SecureStorage

SecureStorage is a property wrapper around the keychain to easily access your protected data.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FSecureStorage%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0xWDG/SecureStorage)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FSecureStorage%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0xWDG/SecureStorage)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
![License](https://img.shields.io/github/license/0xWDG/SecureStorage)

## Requirements

- Swift 5.9+ (Xcode 15+)
- iOS 13+, macOS 10.15+

## Installation (Pakage.swift)

```swift
dependencies: [
    .package(url: "https://github.com/0xWDG/SecureStorage.git", branch: "main"),
],
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "SecureStorage", package: "SecureStorage"),
    ]),
]
```

## Installation (Xcode)

1. In Xcode, open your project and navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Paste the repository URL (`https://github.com/0xWDG/SecureStorage`) and click **Next**.
3. Click **Finish**.

## Usage

```swift
import SwiftUI
import SecureStorage

struct ContentView: View {
    // For this example, we directly bind the username & password.
    // This is not smart to do, because you'll overwrite the values as you type.
    @SecureStorage("username")
    var username: String?

    @SecureStorage("password")
    var password: String?

    var body: some View {
        VStack {
            Text("Please login")
            TextField("Username", text: $username ?? "")
            SecureField("Password", text: $password ?? "")

            Button("Login") {
                print("Login", username, password)
            }
            Button("Delete username") {
                SecureStorage("username").delete()
            }
            Button("Delete password") {
                SecureStorage("password").delete()
            }
            Button("Delete username") {
                SecureStorage("*").deleteAll()
            }
        }
    }
}
```

## Better example

```swift


## Contact

🦋 [@0xWDG](https://bsky.app/profile/0xWDG.bsky.social)
🐘 [mastodon.social/@0xWDG](https://mastodon.social/@0xWDG)
🐦 [@0xWDG](https://x.com/0xWDG)
🧵 [@0xWDG](https://www.threads.net/@0xWDG)
🌐 [wesleydegroot.nl](https://wesleydegroot.nl)
🤖 [Discord](https://discordapp.com/users/918438083861573692)

Interested learning more about Swift? [Check out my blog](https://wesleydegroot.nl/blog/).