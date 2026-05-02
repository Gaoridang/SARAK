# Working tree snapshot — Xcode Project Scaffold
# Date: 2026-05-02
# State: BEFORE scaffold creation

---

## Existing SARAK/ source files
```
SARAK/
├── Assets.xcassets/
│   ├── AccentColor.colorset/
│   ├── AppIcon.appiconset/
│   └── Contents.json
├── ContentView.swift       ← OFF-LIMITS (do not modify)
├── Item.swift
└── SARAKApp.swift          ← OFF-LIMITS (do not modify)
```

## Files to be created (post-scaffold state)
```
SARAK/
├── Assets.xcassets/        (unchanged)
├── ContentView.swift       (unchanged)
├── Item.swift              (unchanged)
├── SARAKApp.swift          (unchanged)
├── Features/
│   ├── Auth/README.md
│   ├── BookSearch/README.md
│   ├── Goals/README.md
│   ├── Notes/README.md
│   ├── Progress/README.md
│   ├── Session/README.md
│   ├── Social/README.md
│   └── Stats/README.md
├── Repositories/
│   ├── Local/README.md
│   ├── Protocols/README.md
│   └── Remote/README.md
├── Services/
│   ├── AuthService.swift
│   └── SyncCoordinator.swift
├── Models/                 (empty — no SwiftData models yet)
├── Constants/
│   ├── APIConstants.swift
│   └── UIConstants.swift
└── Resources/
    └── Localizable.strings
```

## Off-limits files confirmed untouched
- SARAK/SARAKApp.swift
- SARAK/ContentView.swift
- SARAK.xcodeproj/project.pbxproj
