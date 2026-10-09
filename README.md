# ✈️ SkyBooking

A SwiftUI flight-booking app for iPhone and iPad. Users create an account, browse and search flights, book them, and manage their profile and bookings — all backed by Firebase.

Built for **CIA-3013 · Advanced Mobile Applications** (HCT, semester 202520).

---

## Features

| Area | What it does |
|---|---|
| **Authentication** | Email/password sign-up and sign-in with Firebase Auth. Login state persists between launches. |
| **Home** | Welcome banner plus a **Live Departure Board** — flight cards (airline, number, status, airport, times, aircraft) loaded from a REST/JSON endpoint. Status badges are colour-coded (scheduled, departed, delayed, canceled). |
| **Search** | Find flights by departure city (queries Firestore). |
| **Flights** | Real-time list of all available flights from Firestore (live listener — updates without refreshing). |
| **Booking** | Review a flight and confirm; the booking is saved to Firestore under the signed-in user. |
| **Profile** | Edit name, phone, nationality and image URL; pick an avatar from the camera or photo library; view and cancel your bookings; sign out. |

## Tech stack

- **Language / UI:** Swift 5, SwiftUI (`NavigationStack`, `TabView`, `@AppStorage`, `#Preview`)
- **Backend:** [Firebase iOS SDK](https://github.com/firebase/firebase-ios-sdk) 12.11.0 — `FirebaseAuth`, `FirebaseFirestore`, `FirebaseCore` (via Swift Package Manager)
- **Networking:** `URLSession` + `JSONDecoder` for the departure board
- **UIKit bridge:** `UIImagePickerController` wrapped in `UIViewControllerRepresentable` (`CameraManager`)

## Requirements

- macOS with **Xcode 26.4 or newer** (the project's deployment target is **iOS 26.4**)
- A free [Firebase](https://console.firebase.google.com) project
- A Mac simulator or an iPhone/iPad running iOS 26.4+ (the camera needs a real device)

## Getting started

### 1. Clone and open

```bash
git clone https://github.com/ShouqAlshouq/SkyBooking.git
cd SkyBooking
open SkyBooking.xcodeproj
```

Xcode resolves the Firebase package automatically the first time (it can take a minute). `Package.resolved` is committed, so everyone gets the same version.

### 2. Add your Firebase config

The real `GoogleService-Info.plist` is **not** in the repo (it is git-ignored).

1. In the [Firebase console](https://console.firebase.google.com), open your project → **Project settings → Your apps → iOS** and register an app with bundle ID **`hct.ac.ae.SkyBooking`** (or change the bundle ID in Xcode and use that instead).
2. Download `GoogleService-Info.plist`.
3. Place it at `SkyBooking/GoogleService-Info.plist` (next to `Info.plist`) and make sure it is added to the SkyBooking target.

A placeholder, `GoogleService-Info.plist.example`, shows the expected shape.

### 3. Turn on the Firebase services

- **Authentication → Sign-in method →** enable **Email/Password**
- **Firestore Database →** create a database (start in test mode while developing, then add security rules — see below)

### 4. Add some flights

The app reads flights from a Firestore collection named **`Flights`**. Add a few documents so the Flights and Search tabs have something to show:

| Field | Type | Example |
|---|---|---|
| `flightNumber` | string | `SB101` |
| `airline` | string | `SkyAir` |
| `departureCity` | string | `Dubai` |
| `arrivalCity` | string | `Muscat` |
| `departureTime` | timestamp | any future date |
| `arrivalTime` | timestamp | after departure |
| `price` | number | `450` (shown as AED) |

> Field names must match exactly — the app decodes documents straight into the `Flight` model, so a missing or mistyped field will break loading.

### 5. Run

Select an iPhone simulator and press **⌘R**. Sign up, then explore the four tabs.

## Firestore data model

| Collection | Written by | Fields |
|---|---|---|
| `Flights` | you (manually / admin) | `flightNumber`, `airline`, `departureCity`, `arrivalCity`, `departureTime`, `arrivalTime`, `price` |
| `Bookings` | `BookingView` | `bookingDate`, `flightId`, `travelerId` (Firebase Auth UID), `status` |
| `Profiles` | `SignUpView` / `ProfileView` | `fullName`, `email`, `phoneNumber`, `nationality`, `imageURL`, `userID` |

## Project structure

```
SkyBooking/
├── SkyBooking.xcodeproj/
└── SkyBooking/
    ├── SkyBookingApp.swift        # App entry: configures Firebase, routes to sign-in or tabs
    ├── Model/
    │   ├── Flight.swift           # Firestore flight document
    │   ├── Booking.swift          # Firestore booking document
    │   ├── Profile.swift          # Firestore profile document
    │   ├── Route.swift            # Codable types for the departure-board JSON
    │   └── CameraManager.swift    # UIImagePickerController wrapper (camera / gallery)
    ├── View/
    │   ├── ContentView.swift      # TabView: Home · Search · Flights · Profile
    │   ├── SignInView.swift
    │   ├── SignUpView.swift
    │   ├── HomeView.swift         # Banner + live departure board
    │   ├── RouteCardView.swift    # One departure-board card
    │   ├── SearchFlightsView.swift
    │   ├── FlightsView.swift      # Live Firestore list
    │   ├── BookingView.swift
    │   └── ProfileView.swift
    ├── Assets.xcassets/           # App icon, logo, home banner, accent colour
    ├── Info.plist
    └── LaunchScreen.storyboard
```

## How it fits together

```
SkyBookingApp ── signed in? ──► ContentView (TabView)
      │                           ├─ HomeView ──► REST/JSON ──► RouteCardView
      └─ no ──► SignInView        ├─ SearchFlightsView ─┐
                  └► SignUpView   ├─ FlightsView ───────┼──► Firestore: Flights
                                  │        └► BookingView ──► Firestore: Bookings
                                  └─ ProfileView ──► Firestore: Profiles, Bookings
```

## Known limitations

- **Avatar photos aren't saved.** The camera/gallery picker only previews the photo on screen; the avatar that persists comes from the *Image URL* field. Uploading to Firebase Storage would be the natural next step.
- **Departure board uses a mock API.** `HomeView` fetches from a hard-coded Mockbin URL. Mock endpoints can expire — swap in a real flight-data API for production.
- **Search is an exact match.** The departure city must match the stored value exactly (case-sensitive).
- **Bookings show the flight ID**, not the full flight details.
- **No payments, seat selection, or return flights** — bookings are created as `Confirmed` immediately.
- **Firestore security rules are up to you.** Client-side filters (e.g. "only my bookings") are not security. Before sharing the app, add rules so users can only read and write their own `Bookings` and `Profiles`.

## Roadmap ideas

- Upload profile photos to Firebase Storage
- Show full flight details in "My Bookings"
- Case-insensitive search and an arrival-city filter
- Replace the mock departure board with a real flight-data API
- Firestore security rules and unit tests

## Author

**Shouq Alshouq** — www.linkedin.com/in/shouq-alshouq-ba3691264

*Course project for HCT · CIA-3013 Advanced Mobile Applications.*
