# CRM Companion App - Flutter

A mobile companion app for the Need24 WhatsApp CRM system.

## Features

✅ **Authentication**
- Login with email/phone and password
- Secure token storage
- Auto-login on app start

✅ **Leads Management**
- View all leads with beautiful cards
- Search by name, phone, or city
- Filter by status and source
- Pull-to-refresh
- Pagination support

✅ **Lead Actions**
- One-tap call button
- One-tap WhatsApp button
- Add notes to leads
- Update lead status
- View activity timeline

✅ **UI/UX**
- Modern Material Design 3
- Google Fonts (Inter)
- Color-coded status badges
- Avatar with initials
- Shimmer loading effects

## Screenshots

[Add screenshots here after building]

## Backend API

The app connects to: `https://need24.in/api/mobile/`

### Available Endpoints:
- `POST /api/mobile/login` - User authentication
- `GET /api/mobile/leads` - Get leads list
- `GET /api/mobile/leads/{id}` - Get lead details
- `POST /api/mobile/leads/{id}/notes` - Add note
- `POST /api/mobile/leads/{id}/status` - Update status
- `POST /api/mobile/calls/log` - Log call

## Setup Instructions

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / VS Code
- Android SDK (for building APK)

### Installation

1. **Clone/Download the project**
   ```bash
   cd flutter_crm_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run on emulator/device**
   ```bash
   flutter run
   ```

4. **Build APK**
   ```bash
   flutter build apk --release
   ```

   APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

## Build Using Codemagic (FREE Cloud Build)

1. **Push to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin YOUR_GITHUB_REPO_URL
   git push -u origin main
   ```

2. **Go to [Codemagic](https://codemagic.io)**
   - Sign up with GitHub
   - Connect your repository
   - Codemagic will auto-detect `codemagic.yaml`

3. **Start Build**
   - Click "Start new build"
   - Select branch: `main`
   - Build starts automatically

4. **Download APK**
   - Build completes in ~5-10 minutes
   - Download APK from artifacts
   - Install on Android device

## Build Using GitHub Actions

1. **Create `.github/workflows/build.yml`**
   ```yaml
   name: Build Flutter APK
   
   on:
     push:
       branches: [ main ]
     workflow_dispatch:
   
   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v3
         - uses: subosito/flutter-action@v2
           with:
             flutter-version: '3.19.0'
         - run: flutter pub get
         - run: flutter build apk --release
         - uses: actions/upload-artifact@v3
           with:
             name: app-release
             path: build/app/outputs/flutter-apk/app-release.apk
   ```

2. **Push to GitHub**
3. **Go to Actions tab**
4. **Download APK from artifacts**

## Login Credentials

Use your existing Need24 CRM credentials:
- Email/Phone: Your CRM login
- Password: Your CRM password

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── constants/
│   │   └── api_constants.dart         # API endpoints
│   └── services/
│       └── api_service.dart           # Dio HTTP client
├── models/
│   ├── user.dart                      # User model
│   ├── lead.dart                      # Lead model
│   └── lead_note.dart                 # Note model
├── providers/
│   ├── auth_provider.dart             # Auth state management
│   └── leads_provider.dart            # Leads state management
└── screens/
    ├── splash_screen.dart             # Splash/loading
    ├── login_screen.dart              # Login UI
    ├── home_screen.dart               # Bottom nav
    ├── leads_screen.dart              # Leads list
    ├── lead_detail_screen.dart        # Lead details
    └── settings_screen.dart           # Settings/logout
```

## Dependencies

```yaml
flutter_riverpod: ^2.5.1     # State management
dio: ^5.4.0                  # HTTP client
flutter_secure_storage: ^9.0 # Secure token storage
google_fonts: ^6.1.0         # Typography
url_launcher: ^6.2.2         # Call/WhatsApp
intl: ^0.19.0               # Date formatting
shimmer: ^3.0.0             # Loading effect
```

## Troubleshooting

### Issue: "INTERNET permission denied"
**Solution:** Permissions are already added in AndroidManifest.xml

### Issue: "Can't make calls"
**Solution:** Make sure CALL_PHONE permission is granted

### Issue: "API connection failed"
**Solution:** Check that backend is running at https://need24.in

### Issue: "Build failed - Gradle error"
**Solution:** 
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

## Support

For issues or questions:
- Check the backend API at: https://need24.in/api/mobile/login
- Test with Postman first
- Verify user credentials

## License

Proprietary - Need24 CRM

## Version History

### v1.0.0 (2024-02-28)
- ✅ Initial MVP release
- ✅ Authentication
- ✅ Leads list with search/filters
- ✅ Lead details with notes
- ✅ Call and WhatsApp integration
- ✅ Status updates

## Roadmap

### v1.1.0 (Upcoming)
- 📱 Call recording sync
- 📊 Activity dashboard
- 🔔 Push notifications
- 📸 Lead photo upload
- 🌐 Offline mode

---

**Built with ❤️ for Need24 CRM**
