# Gas Tracker Mobile App

<div align="center">

**Track every fill-up, payment, and service event from a single dashboard.**

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/surenjanath)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-green.svg)](https://expo.dev/accounts/surenjanath_singh/projects/gas-tracker)
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)](LICENSE)

</div>

## 📱 Overview

Gas Tracker is an offline-first mobile companion for monitoring your vehicle's fuel costs, MPG, service reminders, and cash flow. Log every fuel expense, keep payments organized, manage multiple vehicles, and generate insights that make it easy to lower your fuel spend.

<div align="center">

[![Gas Tracker App](screenshots/main_screen.png)](#screenshots)

</div>

## ✨ Key Features

### ⛽ Fuel & Expense Tracking
- Capture date, location, mileage, fuel quantity, unit price, and total cost
- Support for both liters and gallons with automatic unit conversions
- Attach notes and payment methods to every entry
- Offline-first data storage with instant sync once you're back online

### 🚗 Vehicle & Maintenance Management
- Manage unlimited vehicles with make/model/year, VIN, and plate details
- Track mileage, service intervals, and maintenance history
- See when your next service is due with automatic reminders
- Store performance metrics such as average MPG and fuel type preference

### 💳 Payments & Cash Flow
- Separate payments from expenses to reconcile reimbursements or company cards
- Track payment sources, categories, and notes per transaction
- Understand balances with automatic totals and comparisons

### 📈 Analytics & Insights
- Monthly and yearly spending trends
- Average cost per mile/kilometer and fuel efficiency charts
- Highest fuel spenders, most visited stations, and category breakdowns
- Exportable CSV/JSON reports

### 🔒 Privacy & Sync
- Local encrypted storage powered by AsyncStorage
- Optional Supabase cloud sync so data follows you across devices
- Transparent privacy controls with granular data deletion

## 🚀 Getting Started

### Installation (Developers)
```bash
git clone <repository-url>
cd GasTracker
npm install
```

### Running Locally
```bash
npm run dev          # Start Expo dev server
npm run android      # Run on Android emulator/device
npm run ios          # Run on iOS simulator/device
```

### First-Time Setup (Users)
1. Launch the app and create your first vehicle.
2. Log your first fuel expense with gallons/liters, mileage, and payment.
3. Visit the Analytics tab for instant insights once data exists.
4. Configure currency, distance units, and dark mode from Settings.

## 📖 Usage Guide

### Logging Fuel Expenses
1. Open the **Add** tab and choose **Fuel Expense**.
2. Enter location, mileage, volume, price, and payment method.
3. Optionally add notes, attachments, or select a vehicle.
4. Save to update totals and analytics instantly.

### Managing Payments
1. Navigate to **Payments** within the Add tab.
2. Track reimbursements, company payments, or personal transfers.
3. Monitor balances vs. logged expenses from the Home dashboard.

### Working with Vehicles
1. Open the **Vehicles** tab to add or edit vehicles.
2. Update mileage, service intervals, and maintenance history.
3. Track MPG per vehicle and receive service reminders.

### Analytics & Reports
1. Visit the **Analytics** tab for spending trends and MPG insights.
2. Filter by vehicle, date range, or fuel type.
3. Export CSV/JSON files from Settings → Data Export.

### Settings & Personalization
- Choose units (miles/kilometers, gallons/liters)
- Configure preferred currency and theme color
- Enable auto-sync, background refresh, or offline-only mode
- Manage notification preferences for service reminders and sync alerts

## 🔒 Privacy & Security
- **Local Data:** Expenses, payments, vehicles, and preferences remain on device.
- **Cloud Sync (Optional):** Supabase stores encrypted backups when enabled.
- **Analytics:** Anonymous usage analytics help improve performance.
- **User Control:** Clear local data, revoke cloud sync, and export your history at any time.

See the full [Privacy Policy](PRIVACY_POLICY.md) for details.

## 🛠️ Technical Details
- **Framework:** React Native + Expo Router
- **Language:** TypeScript
- **Data Layer:** AsyncStorage (local), Supabase (cloud), Zustand store
- **Minimum OS:** iOS 13 / Android 8.0
- **Offline Support:** 100% of features available without internet

## 🐛 Troubleshooting
- **Entries not syncing:** Check internet status, then Settings → Sync Now.
- **Incorrect mileage:** Ensure odometer readings are sequential per vehicle.
- **Missing vehicles:** Re-enable cloud sync or import from exported backup.
- **Performance issues:** Clear cache in Settings or restart the app.

## 💬 Support
- Email: surenjanath.singh@gmail.com
- GitHub: https://github.com/surenjanath
- In-App: About → Contact Support

Provide device model, OS version, and reproduction steps when reporting issues.

## 🔄 Release Info
- **Current Version:** 1.0.0
- **Release Date:** January 2025
- **Distribution:** Expo Dev Client / EAS Build (Android & iOS)

## 📚 Related Docs
- [App Description](APP_DESCRIPTION.md)
- [Privacy Policy](PRIVACY_POLICY.md)
- [Terms of Service](TERMS_OF_SERVICE.md)

## 📝 License
© 2025 Surenjanath Singh. All rights reserved. Redistribution or reverse engineering is prohibited.

---

<div align="center">

**Built with ❤️ using Expo, Supabase, and TypeScript**

[Privacy Policy](PRIVACY_POLICY.md) · [Terms](TERMS_OF_SERVICE.md) · [App Description](APP_DESCRIPTION.md)

</div>

