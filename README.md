# Point2Go

Point2Go is an iOS app that allows users to save and manage locations directly on a map.  
It supports adding pins with reverse-geocoded addresses, storing them in Core Data, and reloading them later.  
Users can re-center the map to their current location, delete individual pins, or remove all saved locations at once.

---

## ✨ Features
- Show current user location on the map.
- Add pins by tapping anywhere on the map.
- Reverse geocoding: each pin shows its street and city.
- Save locations in Core Data for persistence.
- Re-load saved pins automatically when reopening the app.
- Delete individual pins or all pins with one tap.
- Re-center button to quickly move back to your position.

  
## 📱 Screenshots

| Splash Screen | Map with Pins | Pin Callout | Re-Centered |
|---------------|---------------|-------------|-------------|
| ![Splash](/Point2Go/Screenshots/splash.png) | ![Pins](/Point2Go/Screenshots/map-pins.png) | ![Callout](/Point2Go/Screenshots/pin-callout.png) | ![Re-Center](/Point2Go/Screenshots/recenter.png) |

---


---

## 🛠 How to Run Locally
1. **Fork** this repository to your own GitHub account.
2. **Clone** the fork to your machine:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Point2Go.git
   cd Point2Go
   ```
3. Open the project in **Xcode** (`Point2Go.xcodeproj`).
4. Make sure to run on a real device or enable a simulated location in the iOS Simulator:
   - Simulator → **Debug > Location > Apple** (or set a custom location).
5. Build & Run (`⌘ + R`).

---

## 📦 Tech Stack
- **Swift 5**
- **UIKit**
- **MapKit**
- **CoreLocation**
- **Core Data**

---

## 📄 License
This project is licensed under the MIT License.  
Feel free to use, modify, and share.
