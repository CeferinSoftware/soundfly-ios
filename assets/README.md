# Assets Folder

This folder contains the app assets.

## Structure

```
assets/
├── icons/
│   └── app_icon.png      # App icon (1024x1024 px)
├── images/
│   ├── logo.png          # App logo for splash screen
│   └── no_internet.png   # No internet illustration
└── fonts/
    ├── Roboto-Regular.ttf
    ├── Roboto-Medium.ttf
    └── Roboto-Bold.ttf
```

## App Icon

Place your app icon as `app_icon.png` in the `icons/` folder.

Requirements:
- Size: 1024x1024 pixels
- Format: PNG
- No transparency (for iOS)
- No rounded corners (iOS applies them automatically)

After adding your icon, run:
```bash
flutter pub run flutter_launcher_icons
```

## Images

Add any additional images your app needs in the `images/` folder.

## Fonts

If you want to use custom fonts, add them to the `fonts/` folder and update `pubspec.yaml`.
