# 🚀 Complete Setup Guide - CRM Companion App

## 📦 What You Have

### ✅ Backend (Laravel) - LIVE on need24.in
- `leads` table (migrated)
- `lead_notes` table (migrated)
- `call_logs` table (migrated)
- 10 sample leads created
- API endpoints ready at `/api/mobile/*`
- Sanctum authentication working

### ✅ Flutter App - Ready to Build
- 17 files created
- Complete MVP with all features
- Configured for Android
- Codemagic YAML included

---

## 🎯 Quick Start (3 Options)

### OPTION 1: Build Using Codemagic (Easiest - 10 mins)

1. **Create GitHub Repository**
   ```bash
   # On your computer, navigate to a folder
   cd ~/projects
   ```

2. **Copy Flutter App Files**
   - Download all files from `/app/flutter_crm_app/`
   - Or I can package them for you

3. **Push to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial CRM Companion App"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/crm-companion.git
   git push -u origin main
   ```

4. **Setup Codemagic (FREE)**
   - Go to https://codemagic.io
   - Sign in with GitHub
   - Click "Add application"
   - Select your repository
   - Codemagic detects `codemagic.yaml` automatically
   - Click "Start new build"

5. **Download APK**
   - Build completes in 5-10 minutes
   - Download from Artifacts section
   - Install on Android phone

---

### OPTION 2: Build Locally (If you have Flutter installed)

1. **Install Flutter**
   - Download from https://flutter.dev
   - Add to PATH

2. **Copy Flutter App**
   - Get all files from `/app/flutter_crm_app/`

3. **Build APK**
   ```bash
   cd flutter_crm_app
   flutter pub get
   flutter build apk --release
   ```

4. **Get APK**
   - File at: `build/app/outputs/flutter-apk/app-release.apk`
   - Transfer to phone and install

---

### OPTION 3: GitHub Actions (Automated)

1. **Create `.github/workflows/build.yml`**
   (Content provided in README.md)

2. **Push to GitHub**

3. **Go to Actions Tab**
   - Build runs automatically
   - Download APK from artifacts

---

## 📱 Testing the App

### Test Login

Use your existing CRM credentials:
```
Email: your-crm-email@domain.com
Password: your-crm-password
```

Or test user (if you have one):
```
Email: test@need24.in
Password: test123
```

### Test API Manually (Postman)

1. **Login**
   ```
   POST https://need24.in/api/mobile/login
   Body (JSON):
   {
     "email": "your-email",
     "password": "your-password"
   }
   ```

2. **Get Leads**
   ```
   GET https://need24.in/api/mobile/leads
   Headers:
   Authorization: Bearer YOUR_TOKEN_FROM_LOGIN
   ```

---

## 🗂️ Project File Structure

```
flutter_crm_app/
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/AndroidManifest.xml
│   └── build.gradle
├── lib/
│   ├── core/
│   │   ├── constants/api_constants.dart
│   │   └── services/api_service.dart
│   ├── models/
│   │   ├── user.dart
│   │   ├── lead.dart
│   │   ├── lead_note.dart
│   │   └── lead_extended.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   └── leads_provider.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── leads_screen.dart
│   │   ├── lead_detail_screen.dart
│   │   └── settings_screen.dart
│   └── main.dart
├── pubspec.yaml
├── codemagic.yaml
└── README.md
```

---

## 🔧 Configuration

### Change Base URL (if needed)

Edit: `lib/core/constants/api_constants.dart`
```dart
static const String baseUrl = 'https://your-domain.com';
```

### Change App Name

Edit: `android/app/src/main/AndroidManifest.xml`
```xml
<application android:label="Your App Name">
```

Edit: `pubspec.yaml`
```yaml
name: your_app_name
```

---

## 🐛 Troubleshooting

### "Build failed - Flutter not found"
**Solution:** Install Flutter from https://flutter.dev

### "API returns 401 Unauthorized"
**Solution:** Check your credentials are correct

### "Can't install APK"
**Solution:** Enable "Install from Unknown Sources" in Android settings

### "App crashes on launch"
**Solution:** Check backend API is accessible from phone

---

## 📊 Features Checklist

- [x] User Authentication (Login/Logout)
- [x] Secure token storage
- [x] Leads list with pagination
- [x] Search leads
- [x] Filter by status/source
- [x] Lead detail view
- [x] Add notes to leads
- [x] Update lead status
- [x] One-tap call button
- [x] One-tap WhatsApp button
- [x] Pull-to-refresh
- [x] Modern UI with Material Design 3
- [x] Color-coded status badges
- [x] Avatar with initials
- [x] Settings screen
- [ ] Call recording sync (Future)
- [ ] Push notifications (Future)
- [ ] Offline mode (Future)

---

## 🎓 Next Steps After Build

1. **Install APK on your phone**
2. **Login with CRM credentials**
3. **Test all features:**
   - Browse leads
   - Search/filter
   - Open lead details
   - Add a note
   - Try call button
   - Try WhatsApp button
   - Change status
   - Logout and login again

4. **Report any issues**

---

## 📞 Support

If you need help:
1. Check README.md for common issues
2. Test API endpoints with Postman
3. Check backend logs: `/var/log/supervisor/backend.*.log`
4. Verify migrations ran: `php artisan migrate:status`

---

## 🎉 You're Ready!

Everything is set up and ready to build. Choose your preferred method above and get your APK!

**Estimated time to APK:**
- Codemagic: 10 minutes
- Local build: 5 minutes (if Flutter installed)
- GitHub Actions: 15 minutes

Good luck! 🚀
