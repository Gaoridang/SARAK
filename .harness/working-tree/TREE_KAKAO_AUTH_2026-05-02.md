# Working tree snapshot — Kakao Auth
# Date: 2026-05-02
# State: BEFORE implementation

---

## Files to create
- `SARAK/Features/Auth/AuthViewModel.swift`
- `SARAK/Features/Auth/AuthView.swift`
- `SARAK/Constants/StringConstants.swift`
- `SARAKTests/AuthViewModelTests.swift`

## Files to modify
- `SARAK/Services/AuthService.swift` — implement signInWithKakao, signOut, isSignedIn
- `SARAK/Constants/APIConstants.swift` — add Auth.redirectURL
- `SARAK/Constants/UIConstants.swift` — add Colors.kakaoYellow
- `SARAK/Resources/Localizable.strings` — add auth string keys
- `SARAK/SARAKApp.swift` — add .onOpenURL handler, set AuthView as root

## Manual step (cannot be done from code)
- Xcode: Target SARAK → Info → URL Types → + → URL Schemes: `sarak`
  Required for OAuth deep link callback to reach the app.

## Off-limits files confirmed untouched
- SARAK.xcodeproj/project.pbxproj (no hand-edits)
- SARAK/Services/SyncCoordinator.swift
