# 🏋️ MacroFit Prime - Ultra-Premium Macro & Fitness Tracking App

**MacroFit Prime** is a state-of-the-art, cross-platform Flutter application engineered for fitness tracking, macro counting, meal logging, interactive workout management, and biometric health calculations (BMI, BMR, TDEE). Built with a luxury glassmorphic design system, dynamic animations, and seamless dark/light theme persistence.

---

## 📸 Core Features & Capabilities

### ⚡ 1. Daily Energy & Macro Dashboard
- **Animated Calorie Ring**: Real-time visual tracking of Target Calories vs Consumed Calories vs Burned Calories with live remaining kilocalories display.
- **Micro-Nutrient Breakdown**: Dynamic progress indicators for Protein, Carbohydrates, and Fats with remaining gram calculations.
- **Hydration Tracker Widget**: Animated liquid fill level bar with one-tap quick hydration logging (`+250 mL`, `+500 mL`).
- **Quick Meal Log Shortcuts**: Grouped overview for Breakfast, Lunch, Dinner, and Snacks.

### 🧮 2. Interactive Health & Fitness Calculators
- **BMI (Body Mass Index) Calculator**:
  - Interactive height (`cm` / `ft+in`) and weight (`kg` / `lbs`) sliders.
  - Live color-coded `BmiGaugeMeter` displaying exact score, risk category badge (Underweight, Normal, Overweight, Obese), visual needle marker, ideal weight range, and tailored health recommendations.
- **TDEE (Total Daily Energy Expenditure) & Macro Goal Calculator**:
  - Calculates Basal Metabolic Rate (BMR) using the scientifically validated **Mifflin-St Jeor Equation**.
  - Activity Level Multipliers (Sedentary 1.2x to Extra Active 1.9x).
  - Objective adjustments (Fat Loss Deficit -500 kcal, Weight Maintenance 0 kcal, Muscle Growth Surplus +350 kcal).
  - Custom Macro Split Generator (30% Protein, 40% Carbs, 30% Fat) with a one-tap button to sync goals across the app state.

### 🥗 3. Food & Nutrition Logger
- Pre-loaded database of popular fitness foods with high-resolution Unsplash photos, serving sizes, and exact macro breakdowns.
- Real-time search filter and meal category chips (Breakfast, Lunch, Dinner, Snacks).
- **Quick Add Custom Food Modal**: Input custom dishes, calories, and macros on the fly.
- Today's Logged Meals view with individual item deletion and category sub-totals.

### 🏋️ 4. Workout Planner & Active Session Logger
- Exercises database categorized by muscle group (Chest, Legs, Back, Shoulders, HIIT).
- **Active Workout Mode**: Interactive exercise runner with set, rep, and weight logging, accompanied by completion checkboxes.
- Workout history log with session duration and estimated calories burned.

### 📊 5. Analytics & Progress Insights
- **Weekly Calorie Adherence Bar Chart** powered by `fl_chart`.
- **Macro Distribution Pie Chart** visualizing Protein vs Carbs vs Fat balance.
- **7-Day Weight Trajectory Line Chart** featuring smooth curved vector paths and gradient fills.

### 🌗 6. Luxury Theme Engine
- **Obsidian Dark Mode** (default) featuring Electric Emerald (`#00E676`), Cyan (`#00E5FF`), Coral (`#FF5252`), and Solar Amber accents paired with glassmorphism styling.
- **Clean Daylight Light Mode** for high contrast outdoor usability.
- Instant global theme switcher with persistent local storage.

---

## 🛠️ Technology Stack & Libraries

| Category | Technology / Package | Purpose |
|---|---|---|
| **Framework** | Flutter 3.44+ / Dart 3.12+ | Cross-platform desktop, web, and mobile app UI framework |
| **State Management** | `provider` (`ChangeNotifier`) | Reactive global state management & UI synchronization |
| **Data Persistence** | `shared_preferences` | Local disk storage for logged meals, hydration, theme & biometrics |
| **Data Visualizations** | `fl_chart` | High-performance vector charts (Bar Chart, Pie Chart, Line Chart) |
| **Typography** | `google_fonts` (`Outfit`) | Modern, luxury typography |
| **Animations** | `flutter_animate` & `percent_indicator` | Entry animations, fluid transitions & circular/linear progress bars |
| **Date & Formatting** | `intl` | Date parsing & number formatting |

---

## 🧠 What I Learned While Building MacroFit Prime

Building **MacroFit Prime** from scratch provided deep technical learnings across software architecture, UI design principles, mathematical logic implementations, and platform engineering:

### 1. **Mastering Reactive State Management with Provider**
- Learned how to structure a clean, single-source-of-truth `AppState` using `ChangeNotifier`.
- Understood how to decouple business logic (caloric intake arithmetic, TDEE calculation, hydration tracking) from presentational widgets to keep code clean and maintainable.
- Optimized rebuilds by using `Consumer` and granular `Provider.of<AppState>(context, listen: false)` calls to avoid unnecessary widget re-renders.

### 2. **Implementing Complex Health Algorithms & Dynamic Math**
- **Mifflin-St Jeor BMR Equation**: Implemented gender-specific BMR equations:
  $$\text{BMR}_{\text{male}} = 10W + 6.25H - 5A + 5$$
  $$\text{BMR}_{\text{female}} = 10W + 6.25H - 5A - 161$$
- **BMI Normalization & Gauge Positioning**: Learned how to map non-linear numerical ranges (BMI scale 15.0 to 35.0+) into normalized `[0.0, 1.0]` floating-point values to calculate exact pixel positioning for custom marker needles in `LayoutBuilder`.

### 3. **Designing Premium Glassmorphic UI Systems**
- Gained hands-on experience creating custom design systems using Flutter's `ThemeData`, custom `Color` constants, linear gradients, and layered `BoxShadow` definitions.
- Created reusable components like `GlassCard` that adapt dynamically to both Dark Obsidian and Daylight Light modes based on global theme state.

### 4. **Data Visualization with `fl_chart`**
- Understood how vector charting packages handle axis titles, grid lines, touch tooltips, curved splines (`isCurved: true`), and area fills (`BarAreaData`).
- Learned how to bind dynamic app state model data to `BarChartGroupData`, `PieChartSectionData`, and `FlSpot` arrays.

### 5. **Local Data Persistence Architecture**
- Designed a JSON serialization pattern (`toJson` / `fromJson`) for custom Dart data models (`LoggedMeal`, `FoodItem`, `WorkoutSession`).
- Saved and rehydrated complex application state across application restarts using `SharedPreferences`.

### 6. **Platform Engineering & Native macOS Troubleshooting**
- Encountered and solved native Xcode build issues (`MACOSX_DEPLOYMENT_TARGET` version mismatches and macOS Finder extended attribute `xattr` detritus during CodeSign).
- Learned how Xcode configuration files (`project.pbxproj`) manage deployment targets, code signing flags, and shell script build phases.

---

## 📂 Project Structure

```
macrofit_prime/
├── lib/
│   ├── main.dart                          # Root app entrypoint & Provider initialization
│   ├── theme/
│   │   └── app_theme.dart                 # Design system, color palettes & Dark/Light ThemeData
│   ├── models/
│   │   └── app_models.dart                # Data Models (Food, LoggedMeal, Exercise, UserProfile, BmiResult)
│   ├── services/
│   │   └── app_state.dart                 # Global State Management & SharedPreferences storage
│   ├── data/
│   │   └── mock_data.dart                 # Pre-loaded healthy food catalog & exercise library
│   ├── widgets/
│   │   ├── glass_card.dart                # Glassmorphic container widget
│   │   ├── macro_ring.dart                # Circular Calorie ring & linear macro indicators
│   │   ├── bmi_meter.dart                 # Interactive color-coded BMI gauge meter
│   │   └── quick_add_modal.dart           # Custom food logger bottom sheet
│   └── screens/
│       ├── main_navigation_screen.dart    # Floating bottom navbar & PageView controller
│       ├── dashboard_screen.dart          # Energy overview, Hydration, Today's macros
│       ├── meal_logger_screen.dart        # Searchable food catalog & logged meals view
│       ├── calculators_screen.dart        # BMI & TDEE macro goal calculator tabs
│       ├── workout_planner_screen.dart    # Exercise database & active gym session runner
│       ├── analytics_screen.dart          # Progress bar charts, pie charts & weight line graph
│       └── profile_settings_screen.dart   # Biometrics target editor & Light/Dark theme toggle
├── test/
│   └── widget_test.dart                  # Automated smoke & widget tests
└── pubspec.yaml                           # App configuration & package dependencies
```

---

## ⚡ Getting Started & How to Run

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.19.0 or higher)
- Xcode (for macOS desktop target) or Google Chrome (for Web target)

### Installation Steps

1. **Clone or Navigate to the Workspace Directory**:
   ```bash
   git clone https://github.com/harshmishra21/macrofit-prime.git
   cd macrofit-prime
   ```

2. **Install Package Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run Code Analysis & Tests**:
   ```bash
   flutter analyze
   flutter test
   ```

4. **Launch Application**:
   - **Run on Web (Chrome)**:
     ```bash
     flutter run -d chrome
     ```
   - **Run on macOS Desktop**:
     ```bash
     flutter run -d macos
     ```
   - **Build Production Web Bundle**:
     ```bash
     flutter build web
     ```

---

## 💖 Thank You & Connect With Me!

Thank you so much for checking out **MacroFit Prime**! If you found this project helpful or inspiring, please consider giving it a ⭐ on GitHub!

Feel free to reach out, connect, or collaborate:
- **GitHub**: [@harshmishra21](https://github.com/harshmishra21)
- **Project Repository**: [harshmishra21/macrofit-prime](https://github.com/harshmishra21/macrofit-prime)

*Happy coding & stay fit! 🚀🏋️‍♂️*


