# iCloud / CloudKit signing

The default unsigned IPA flow intentionally uses `Blink-sideload.entitlements`, which does not include CloudKit or iCloud entitlements. That IPA cannot support Blink Sync, even after it is re-signed.

For an iCloud-capable build, use Apple signing from source.

## Configuration

After preparing the source tree, copy the repository's iCloud configuration into the Blink source tree:

```bash
cp developer_setup.icloud.xcconfig blink-src/developer_setup.xcconfig
```

This configuration uses:

- Team ID: `ACBMGSSX43`
- Bundle ID: `com.zippyy.blink`
- iCloud container: `iCloud.com.zippyy.blink`
- App group: `group.com.zippyy.blink`

## Apple Developer setup

Create or enable these matching resources in the Apple Developer portal before building:

1. App ID: `com.zippyy.blink`
2. iCloud capability with CloudKit
3. iCloud container: `iCloud.com.zippyy.blink`
4. App Group: `group.com.zippyy.blink`
5. A new provisioning profile generated after the capabilities are enabled

## Build

Use the fixed builder only to prepare the source:

```bash
./build-blink-shell-gpl-fixed.sh --setup-only --overwrite
cp developer_setup.icloud.xcconfig blink-src/developer_setup.xcconfig
open blink-src/Blink.xcodeproj
```

In Xcode, select the **Blink** target, choose the Apple team, and verify the iCloud and App Groups capabilities select the resources above. Archive and export from Xcode. Do not use the unsigned `Blink-unsigned.ipa` path for iCloud Sync.
