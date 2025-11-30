# Soundfly iOS - Flutter App

Una aplicación Flutter para iOS que se conecta con tu backend web de Soundfly para streaming de música.

## 📱 Características

- **WebView Integrado**: Carga tu sitio web de Soundfly directamente en la app
- **Push Notifications**: Soporte completo para Firebase Cloud Messaging
- **AdMob**: Integración de anuncios intersticiales de Google AdMob
- **Detección de Conectividad**: Pantalla de "Sin Internet" con opción de reintentar
- **Diseño Nativo iOS**: Splash screen animado y UI adaptada a iOS
- **Pull to Refresh**: Actualiza el contenido tirando hacia abajo
- **Doble tap para salir**: Previene salidas accidentales

## 🚀 Inicio Rápido

### Prerrequisitos

1. **Flutter SDK** (>=3.0.0): [Instalar Flutter](https://docs.flutter.dev/get-started/install)
2. **Xcode** (>=14.0): Disponible en Mac App Store
3. **CocoaPods**: `sudo gem install cocoapods`

### Instalación

1. **Clonar/Copiar el proyecto**

2. **Instalar dependencias Flutter**:
   ```bash
   cd ios
   flutter pub get
   ```

3. **Instalar pods de iOS**:
   ```bash
   cd ios/ios
   pod install
   ```

4. **Abrir en Xcode**:
   ```bash
   open ios/Runner.xcworkspace
   ```

## ⚙️ Configuración

### 1. Configuración Básica

Edita el archivo `lib/config/app_config.dart`:

```dart
// Tu URL del sitio Soundfly
static const String websiteUrl = 'https://tu-sitio.com';

// Tu código de compra de CodeCanyon
static const String purchaseCode = 'tu-codigo-de-compra';
```

### 2. Configuración de Firebase (Push Notifications)

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Agrega una app iOS con tu Bundle ID
3. Descarga `GoogleService-Info.plist`
4. Colócalo en `ios/Runner/`
5. Habilita las notificaciones en `app_config.dart`:

```dart
static const bool pushNotificationsEnabled = true;
```

### 3. Configuración de AdMob

1. Crea una cuenta en [Google AdMob](https://admob.google.com/)
2. Crea una app y obtén tu App ID
3. Crea una unidad de anuncio intersticial
4. Actualiza `app_config.dart`:

```dart
static const bool admobEnabled = true;
static const String admobAppId = 'ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY';
static const String admobInterstitialId = 'ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ';
```

5. Actualiza también el `Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY</string>
```

### 4. Cambiar el Bundle Identifier

1. Abre el proyecto en Xcode
2. Selecciona el target "Runner"
3. Ve a "Signing & Capabilities"
4. Cambia el "Bundle Identifier" a tu identificador único

### 5. Cambiar el Nombre de la App

1. En `Info.plist`, cambia:
   ```xml
   <key>CFBundleDisplayName</key>
   <string>Tu Nombre de App</string>
   ```

2. En `app_config.dart`:
   ```dart
   static const String appName = 'Tu Nombre de App';
   ```

### 6. Cambiar el Ícono de la App

1. Prepara tu ícono en formato PNG de 1024x1024 px
2. Colócalo en `assets/icons/app_icon.png`
3. Ejecuta:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

O usa [App Icon Generator](https://appicon.co/) y reemplaza los archivos en:
`ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## 🏗️ Compilación

### Modo Debug
```bash
flutter run -d ios
```

### Modo Release
```bash
flutter build ios --release
```

### Archivo IPA para App Store
```bash
flutter build ipa
```

## 📂 Estructura del Proyecto

```
ios/
├── lib/
│   ├── config/
│   │   ├── app_config.dart      # Configuración principal
│   │   ├── app_strings.dart     # Textos/traducciones
│   │   └── app_theme.dart       # Colores y estilos
│   ├── screens/
│   │   ├── splash_screen.dart   # Pantalla de inicio
│   │   ├── home_screen.dart     # WebView principal
│   │   └── no_internet_screen.dart
│   ├── services/
│   │   ├── admob_service.dart   # Anuncios AdMob
│   │   ├── connectivity_service.dart
│   │   └── push_notification_service.dart
│   └── main.dart                # Punto de entrada
├── ios/
│   ├── Runner/
│   │   ├── Info.plist           # Configuración iOS
│   │   ├── AppDelegate.swift
│   │   └── Assets.xcassets/     # Íconos y recursos
│   └── Podfile                  # Dependencias iOS
├── assets/                      # Recursos (íconos, imágenes)
└── pubspec.yaml                 # Dependencias Flutter
```

## 🔧 Solución de Problemas

### Error: CocoaPods not found
```bash
sudo gem install cocoapods
cd ios/ios
pod install
```

### Error: Signing certificate
1. Abre Xcode
2. Ve a Preferences > Accounts
3. Agrega tu Apple ID
4. Selecciona tu Team en el target Runner

### Error: Minimum iOS version
El proyecto requiere iOS 12.0 o superior.

### WebView no carga
1. Verifica que la URL en `app_config.dart` sea correcta
2. Asegúrate de que `NSAppTransportSecurity` esté configurado en `Info.plist`

## 📱 Publicación en App Store

1. **Crear App Store Connect record**
2. **Configurar certificados y provisioning profiles**
3. **Archivar la app en Xcode**
4. **Subir a App Store Connect**
5. **Completar la información de la app**
6. **Enviar para revisión**

## 🤝 Conexión con Backend Soundfly

Esta app se conecta automáticamente con tu backend web de Soundfly. Asegúrate de que:

1. Tu servidor Soundfly esté configurado correctamente
2. La URL sea accesible públicamente (o a través de VPN)
3. CORS esté configurado para permitir solicitudes desde apps móviles
4. SSL/HTTPS esté habilitado para producción

## 📄 Licencia

Este proyecto está bajo la licencia de CodeCanyon/Envato.

## 🆘 Soporte

Para soporte, visita [docs.scriptwriters.dev](https://docs.scriptwriters.dev/) o contacta al desarrollador original.

---

**Versión**: 14.0  
**Build**: 14000  
**Compatible con**: iOS 12.0+  
**Framework**: Flutter 3.0+
