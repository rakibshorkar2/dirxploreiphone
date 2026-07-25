# DirXplore

**Advanced HTTP Directory Browser & Download Manager for iPhone**

A production-quality iOS application built with Flutter + native Swift for background downloads, SOCKS5 proxy support, and a premium Liquid Glass-inspired interface.

---

## Features

| Tab | Capability |
|-----|-----------|
| **Browser** | HTTP/HTTPS directory listings (Apache, Nginx, generic HTML), breadcrumb nav, search, sort, pull-to-refresh |
| **Downloads** | Background URLSession downloads, pause/resume/retry, speed + ETA display, auto-retry with exponential backoff |
| **Proxy** | SOCKS5 proxy manager with Keychain credential storage, connection testing, latency display |
| **Files** | Local file explorer in app Documents, preview images/text/PDFs, share/open-in external apps |
| **Settings** | Concurrent downloads, retry count, timeout, auto-resume, background downloads, notifications, theme |

---

## Defaults

- **Browser URL**: `http://172.16.50.4`
- **Default Proxy**: SOCKS5 `103.166.253.92:1088` (user: `test` / pass: `test`)

---

## Architecture

```
lib/
  main.dart                     ← CupertinoApp + Riverpod ProviderScope
  core/
    theme/app_theme.dart        ← Liquid Glass design system
    constants/app_constants.dart
  models/                       ← DirectoryItem, DownloadTask, ProxyConfig, AppSettings
  services/                     ← DirectoryService, DownloadService, ProxyService, FileService, NotificationService
  providers/                    ← Riverpod StateNotifiers for each domain
  screens/
    shell/app_shell.dart        ← CupertinoTabScaffold
    browser/                    ← Browser screen + tiles + breadcrumbs
    downloads/                  ← Download manager + tiles
    proxy/                      ← Proxy manager + form sheet
    files/                      ← File explorer + preview
    settings/                   ← Settings screen

ios/Runner/
  AppDelegate.swift             ← Background session + notification setup
  BackgroundDownloadManager.swift  ← URLSession background downloads
  DownloadMethodChannel.swift   ← Flutter ↔ Swift bridge
  ResumeDataManager.swift       ← Resume data persistence
  KeychainManager.swift         ← Keychain credential storage
  NotificationHandler.swift     ← Local push notifications
```

---

## Build Instructions

### Prerequisites

- **macOS** with Xcode 15.4+
- **Flutter SDK** 3.22+ (`flutter doctor` should show ✓ for iOS)
- iPhone running iOS 17+ **or** iOS Simulator

### 1. Get dependencies

```bash
flutter pub get
```

### 2. Run on Simulator (debug)

```bash
flutter run -d "iPhone 15 Pro"
```

### 3. Build for device (no codesign — sideloading)

```bash
flutter build ios --release --no-codesign
```

The `.app` is at `build/ios/iphoneos/Runner.app`

### 4. Create IPA for sideloading

```bash
cd build/ios/iphoneos
mkdir Payload
cp -r Runner.app Payload/
zip -r DirXplore.ipa Payload
```

Install with **AltStore**, **Sideloadly**, or **TrollStore**.

### 5. CI/CD (GitHub Actions)

Push to `main` → automatically builds and uploads `Runner.app` artifact.  
Manually trigger with `export_ipa: true` to get an IPA artifact.

---

## Important Notes

- **Background downloads** require `UIBackgroundModes` with `fetch` in Info.plist ✓
- **Local HTTP servers** require `NSAllowsArbitraryLoads: true` in Info.plist ✓
- **Resume support** uses `HTTP Range` headers via `URLSession` resume data
- **SOCKS5 proxy routing** is implemented natively in Swift (Flutter Dio handles standard HTTP only)
- Downloads that were active when the app was killed are restored as **Paused** on next launch and can be resumed

---

## License

Private / Personal Use
