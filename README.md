# Swift Package Manager copy repository

This repository is a copy of https://github.com/firebase/boringssl with
the git metadata removed to provide one to two orders of magnitude increase in
speed for Swift Package Manager usage.

This repo is not supported as a direct dependency for non-Google usage.

The source here should mirror what is released in the BoringSSL-GRPC CocoaPods
used. There should be no changes to this repo other than updates from its mirror
and Swift Package Manager specific items.

Versioning should follow normal sem-ver, as dependencies on this package are
locked to the patch version. Non breaking edits to the Package manifest alone
should be a patch version update.

The current 0.7.x versioning is a mapping to enable SPM-only updates to the
0.0.7 version of the source that is aligned with the CocoaPods version
currently used by Firestore.

Releases should be normal tags, not marked as a "Release" via GitHub's
interface.

## Maintenance & Sync Guide

When syncing new revisions from the upstream `boringssl` repository, you MUST follow this checklist:

1. **Remove Test Files:** Delete all `*_test.cc`, `*_test.go`, and test vector files. This repository exists solely to serve SPM, and keeping test files bloats the download size and causes SPM warnings.
2. **No IDE State:** Ensure that no `.swiftpm/` directories or `.xcuserstate` files are committed. 
3. **Lean Package.swift:** The `Package.swift` file should explicitly define the core sources and must not expose or rely on test targets that have been deleted. *(Context: By deleting the test files from the repo entirely, we keep `Package.swift` lean because we avoid having to maintain a massive `exclude:` array just to prevent SwiftPM from throwing "unhandled source files" warnings. It also ensures those tests are never accidentally compiled into the final binary).*
4. **Remove Unneeded Build Files:** Strip out upstream build config files (e.g., `.bcr/`, `.bazelrc`, `CMakeLists.txt`) that aren't needed for SwiftPM. Any synced files not explicitly referenced in `Package.swift` are considered dead code and should be removed.
5. **CI Checks:** GitHub may disable the `spm` workflow due to repository inactivity. Before opening a PR, go to the Actions tab to ensure workflows are enabled. You may need to close and reopen your PR to trigger them.
6. **Xcode Validation:** Always build the package locally against the latest stable and beta versions of Xcode to ensure the sync does not introduce new compiler warnings.
