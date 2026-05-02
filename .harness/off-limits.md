# Off-limits files
# Load this when: unsure if a file is safe to modify

## Never touch without explicit user approval
```
Secrets.swift                                   # API keys, never commit
*.xcconfig                                      # Build configurations
SARAK.xcodeproj/project.pbxproj                 # Xcode project file — never hand-edit;
                                                # Xcode auto-edits it for SPM/file ops are fine
**/Migrations/                                  # SwiftData migration files
SARAK/Services/SyncCoordinator.swift            # Core sync logic
```

## Protocol if you need to touch one
1. Stop coding.
2. State exactly which file and what change is needed.
3. Explain why it's necessary.
4. Wait for user approval before proceeding.
