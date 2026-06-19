
## Syncing with Upstream
To sync this repository with the upstream google/boringssl repository while maintaining the lightweight SwiftPM structure:

1. Ensure Upstream Remote is Configured:
git remote add upstream https://github.com/google/boringssl

2. Run the Sync Script:
Execute the automation script from the root directory:

```
./scripts/sync-upstream.sh [commit-hash]
```
If no commit-hash is provided, it defaults to upstream/main.

