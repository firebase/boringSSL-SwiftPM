# Swift Package Manager copy repository

This repository is a copy of https://github.com/firebase/boringssl with
the git metadata removed to provide one to two orders of magnitude increase in
speed for Swift Package Manager usage.

There should be no changes to this repo other than updates from its mirror
and Swift Package Manager specific items.

Versioning should follow normal sem-ver, as dependencies on this package are
locked to the patch version. Non breaking edits to the Package manifest alone
should be a patch version update.

Releases should be normal tags, not marked as a "Release" via GitHub's
interface.
