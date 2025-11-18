# Gas Tracker – App Description

## Overview
Gas Tracker is a cross-platform (iOS + Android) mobile application that helps drivers take control of their fuel expenses, vehicle maintenance, and driving habits. Whether you’re managing a single daily driver or a fleet of work vehicles, Gas Tracker keeps every fill-up, payment, and service event organized with rich analytics and offline-first reliability.

## What Does Gas Tracker Do?
- **Log Fuel Expenses:** Capture mileage, gallons/liters, unit price, total cost, and payment type per entry
- **Monitor Vehicle Health:** Track MPG, maintenance intervals, and service history for multiple vehicles
- **Understand Cash Flow:** Separate expenses from payments to reconcile reimbursements or company card usage
- **Generate Insights:** Review dashboards that surface monthly spend, fuel efficiency, and usage trends
- **Sync Securely:** Keep everything on-device or enable Supabase sync to back up and share data across devices

## Key Feature Areas

### ⛽ Fuel Tracking
- Log fill-ups with date, station/location, odometer, and volume
- Support for liters/gallons and multiple currencies
- Auto-calculated totals, price-per-unit, and cost-per-mile
- Attach notes and tags (e.g., work trip, premium fuel, towing)

### 🚗 Vehicle Management
- Unlimited vehicles with make, model, VIN, license plate, and avatar
- Track current mileage, last service mileage, and upcoming maintenance
- Monitor average MPG per vehicle and total miles driven

### 💳 Payment & Balance Management
- Record payments separate from expenses to see outstanding balances
- Categorize payment sources (personal, corporate, reimbursement)
- Quick glance on the Home screen shows total spend vs. payments

### 📊 Analytics & Reporting
- Dynamic dashboards for monthly/yearly spend, MPG trends, and station usage
- Identify top expenses, recurring vendors, and cost anomalies
- Export CSV or JSON for tax filing or expense reports
- Upcoming: predictive alerts for tire rotations, oil changes, and yearly inspections

### ⚙️ Personalization & Settings
- Choose units (miles vs. kilometers, gallons vs. liters)
- Configure currency, theme colors, and dark mode
- Enable/disable background sync, analytics, or offline-only mode
- Manage notification preferences for service reminders and sync results

## How It Works
1. **Offline-First Storage:** AsyncStorage keeps all data accessible without internet.
2. **Background Sync:** When enabled, Supabase keeps a secure copy and resolves conflicts.
3. **Smart Caching:** Screens subscribe to a centralized Zustand store, so metrics update instantly.
4. **Computed Analytics:** Derived metrics (MPG, cost per mile, monthly totals) are calculated at runtime for accuracy.

## Data Model Highlights
- `FuelExpense`: captures per-fill transaction details and computed totals
- `Payment`: stores reimbursements, transfers, or income related to driving
- `Vehicle`: metadata plus maintenance intervals, mileage targets, and usage stats
- `ServiceRecord`: logs maintenance operations with cost, mileage, and notes
- `UserSettings`: volume/distance units, currency, notification preferences, sync state
- `UserProfile`: optional details such as avatar, contact info, and preferred fuel type

## Screens & User Flow

### Home
- Overview cards for expenses vs. payments
- Quick Actions to add fuel, payments, or vehicles
- Recent activities, last sync state, and error banners if something fails

### Entries / Add
- Guided forms for Fuel Expense, Payment, Vehicle, and Service entries
- Inline validation with helpful defaults (e.g., last mileage populated automatically)

### Analytics
- Rich charts for cost trends, MPG breakdown, and per-vehicle stats
- Filters by vehicle, date range, and fuel type

### Vehicles
- Grid/list view of vehicles with status badges (e.g., maintenance due soon)
- Detail view with history, service log, and performance metrics

### Settings
- Account/profile preferences
- Localization (units, currency, language)
- Sync controls, exports, backups, and diagnostics

## Privacy & Security
- Data remains local unless you opt into cloud sync
- Supabase authentication protects sync-enabled accounts
- All traffic uses SSL/TLS; service_role keys are never exposed to clients
- Users can clear local data, revoke sync, or request data export anytime

Full details are available in the [Privacy Policy](PRIVACY_POLICY.md).

## Target Users
- **Everyday Drivers:** Track personal fuel spend and MPG to improve driving habits
- **Gig/Delivery Workers:** Separate business vs. personal trips and simplify tax prep
- **Fleet & Small Business Owners:** Monitor multiple vehicles and drivers without complex fleet software
- **Auto Enthusiasts:** Keep detailed service and modification history

## Roadmap Highlights
- Push notifications for maintenance reminders
- AI-assisted log completion using receipt OCR
- Station price comparison powered by community submissions
- Desktop dashboard for exporting and reconciling fleet data

## Availability & Version Info
- **Platforms:** iOS (Expo), Android (Expo)
- **Framework:** React Native / Expo SDK 54
- **Version:** 1.0.0 (January 2025)
- **Developer:** Surenjanath Singh
- **Distribution:** Expo Dev Client & EAS Build

---

**Gas Tracker – Drive smarter, spend less, stay organized.**

© 2025 Surenjanath Singh. All rights reserved.

