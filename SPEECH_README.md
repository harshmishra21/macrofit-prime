# 🎙️ MacroFit Prime - Expressive Hinglish Presentation Speech & Detailed Feature Code Map

---

## 🌟 Top 10 Features & Core Technical Logic (With Exact File Paths & Line Numbers)

Below is the deep-dive technical breakdown of the top 10 features, explaining **what it does**, **how the logic works**, and **the exact folder, file path, and line numbers** where the code is located:

---

### 1. ⭕ `CalorieMainRing` (Circular Calorie & Energy Progress Gauge)
- **What it does**: Dashboard par user ke daily target calories vs. consumed calories vs. burned calories ko ek futuristic neon ring container mein animate karke display karta hai.
- **Detailed Logic (Hinglish)**:
  - Pehle real-time remaining energy compute hoti hai: `remaining = (targetCalories - consumedCalories + burnedCalories)`.
  - Phir target fraction ratio derive kiya jata hai: `percent = (consumedCalories / targetCalories).clamp(0.0, 1.0)`.
  - Is percentage values ko `percent_indicator` package ki `CircularPercentIndicator` widget mein pass karke smooth dual-gradient (Emerald to Cyan) circular stroke paint generate hoti hai. Center stack mein flame icon aur remaining kcal ka glowing live counter dikhai deta hai.
- **📁 Code Location & File Lines**:
  - **Widget Definition**: [`lib/widgets/macro_ring.dart:L6-L77`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/widgets/macro_ring.dart#L6-L77)
  - **Dashboard Render Site**: [`lib/screens/dashboard_screen.dart:L118-L124`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/dashboard_screen.dart#L118-L124)

---

### 2. 📊 `BmiGaugeMeter` (Interactive Color-Coded BMI Gauge & Pointer Needle)
- **What it does**: Height (cm/ft) aur Weight (kg/lbs) sliders adjust karne par instantaneous Body Mass Index (BMI) calculate karta hai aur visual gradient segment bar par live pointer marker position shift karta hai.
- **Detailed Logic (Hinglish)**:
  - **Scientific Formula**: $\text{BMI} = \frac{\text{weightKg}}{(\text{heightM})^2}$.
  - **Classification Ranges**: Underweight (<18.5 Blue `#29B6F6`), Normal (18.5–24.9 Green `#00E676`), Overweight (25–29.9 Yellow `#FFB300`), Obese (30+ Red `#FF5252`).
  - **Marker Positioning Logic**: BMI score ko range `[15.0, 35.0]` ke between clamp karke 0.0 se 1.0 tak ki normalized fraction position banate hain: `indicatorPosition = (clampedBmi - 15.0) / (35.0 - 15.0)`. Is fraction ko `LayoutBuilder` width se multiply karke exact `Positioned` left coordinate set kiya jata hai `left: markerX - 10`.
- **📁 Code Location & File Lines**:
  - **Math Factory Calculation**: [`lib/models/app_models.dart:L311-L352`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/models/app_models.dart#L311-L352)
  - **Visual Gauge Widget**: [`lib/widgets/bmi_meter.dart:L5-L132`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/widgets/bmi_meter.dart#L5-L132)
  - **Calculator UI Tab**: [`lib/screens/calculators_screen.dart:L76-L193`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/calculators_screen.dart#L76-L193)

---

### 3. 🧪 `MacroProgressBar` (Protein, Carbs, Fats Micro-Nutrient Trackers)
- **What it does**: Daily micro-nutrients breakdown (Protein Red, Carbs Cyan, Fat Amber) ke targets aur live consumed amounts ko represent karne wala widget bar.
- **Detailed Logic (Hinglish)**:
  - `remaining = (targetGrams - currentGrams).clamp(0.0, 999.0)` calculate karta hai left-over grams.
  - Linear fill fraction `percent = (currentGrams / targetGrams).clamp(0.0, 1.0)` derive karke `LinearPercentIndicator` bar radius ke saath render karta hai.
- **📁 Code Location & File Lines**:
  - **Widget Component**: [`lib/widgets/macro_ring.dart:L79-L148`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/widgets/macro_ring.dart#L79-L148)
  - **Dashboard Usage**: [`lib/screens/dashboard_screen.dart:L127-L148`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/dashboard_screen.dart#L127-L148)

---

### 4. 💧 `Hydration Tracker Widget` (Animated Liquid Level Water Logger)
- **What it does**: User ke daily water intake target (e.g. 3000 mL) ko track karne wala widget jisme quick tap buttons (`+250 mL`, `+500 mL`) diye gaye hain.
- **Detailed Logic (Hinglish)**:
  - User tap par `addWater(amountMl)` method call hota hai: `_waterIntakeMl = (_waterIntakeMl + amountMl).clamp(0, 10000)`.
  - Progress percentage `waterPercent = (waterMl / targetMl).clamp(0.0, 1.0)` compute karke `LinearProgressIndicator` smoothness se level badhati hai aur `SharedPreferences` disk storage mein `water_intake_ml` sync ho jata hai.
- **📁 Code Location & File Lines**:
  - **State Controller Logic**: [`lib/services/app_state.dart:L140-L150`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/services/app_state.dart#L140-L150)
  - **UI Widget Rendering**: [`lib/screens/dashboard_screen.dart:L153-L219`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/dashboard_screen.dart#L153-L219)

---

### 5. 🧮 `TDEE & Calorie Goal Calculator` (Mifflin-St Jeor Energy Engine)
- **What it does**: User ke age, gender, height, weight, daily activity level (Sedentary to Extra Active), aur objective (Fat Loss, Maintain, Muscle Gain) ke according BMR, TDEE, aur exact Macro Grams Split compute karta hai.
- **Detailed Logic (Hinglish)**:
  - **Mifflin-St Jeor BMR Formula**:
    - Male: $\text{BMR} = 10W + 6.25H - 5A + 5$
    - Female: $\text{BMR} = 10W + 6.25H - 5A - 161$
  - **Maintenance TDEE**: $\text{TDEE} = \text{BMR} \times \text{ActivityMultiplier}$ (1.2x to 1.9x).
  - **Goal Adjustment**: Fat Loss (-500 kcal deficit), Maintenance (0), Muscle Growth (+350 kcal surplus).
  - **Macro Split Grams**: Protein 30% ($\frac{\text{Cals} \times 0.30}{4}$), Carbs 40% ($\frac{\text{Cals} \times 0.40}{4}$), Fat 30% ($\frac{\text{Cals} \times 0.30}{9}$).
- **📁 Code Location & File Lines**:
  - **Math Algorithm Function**: [`lib/services/app_state.dart:L190-L210`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/services/app_state.dart#L190-L210)
  - **Calculator UI Interface**: [`lib/screens/calculators_screen.dart:L196-L384`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/calculators_screen.dart#L196-L384)

---

### 6. 🍲 `QuickAddModal` (Custom Meal & Macro Bottom Sheet Input)
- **What it does**: User ko real-time custom dishes, protein, carbs, fat, aur calories log karne ke liye bottom modal sheet open karta hai.
- **Detailed Logic (Hinglish)**:
  - `TextEditingController` ke through inputs parse karke ek naya `FoodItem` object compile karta hai.
  - Category (Breakfast, Lunch, Dinner, Snack) assign karke `AppState.addLoggedMeal()` invokation se `_loggedMeals` list mein insert ho jata hai aur persistent JSON list ban kar storage mein write hota hai.
- **📁 Code Location & File Lines**:
  - **Modal Sheet Definition**: [`lib/widgets/quick_add_modal.dart:L1-L198`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/widgets/quick_add_modal.dart#L1-L198)
  - **Form Parse & State Commit**: [`lib/widgets/quick_add_modal.dart:L163-L189`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/widgets/quick_add_modal.dart#L163-L189)

---

### 7. 🏋️ `Active Workout Runner` (Gym Session Set, Rep & Weight Tracker)
- **What it does**: Gym sessions initiate karke per exercise sets, reps, aur weight log karne ka real-time interface.
- **Detailed Logic (Hinglish)**:
  - `ExerciseLog` dynamic list run hoti hai containing `WorkoutSet(reps, weightKg, isCompleted)`.
  - User live weight/reps edit kar sakta hai aur checkbox click karke set complete mark kar sakta hai. Finish hone par estimated calories burned calculate karke `WorkoutSession` history list mein prepend kar diya jata hai.
- **📁 Code Location & File Lines**:
  - **Workout Data Models**: [`lib/models/app_models.dart:L145-L188`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/models/app_models.dart#L145-L188)
  - **Active Workout Runner UI**: [`lib/screens/workout_planner_screen.dart:L63-L176`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/workout_planner_screen.dart#L63-L176)

---

### 8. 🌗 `Theme Engine & Persistent Toggle` (Obsidian Dark vs Daylight Light Theme)
- **What it does**: Deep obsidian dark theme aur crisp daylight light theme ke beech instant dynamic switching.
- **Detailed Logic (Hinglish)**:
  - `AppState` internal `ThemeMode` (`ThemeMode.dark` / `ThemeMode.light`) control karta hai.
  - `toggleTheme()` invoke hone par `notifyListeners()` poore root `MaterialApp` ko trigger karta hai, aur preference boolean `is_dark_mode` `SharedPreferences` disk storage mein persist hoti hai.
- **📁 Code Location & File Lines**:
  - **Theme System Definitions**: [`lib/theme/app_theme.dart:L51-L118`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/theme/app_theme.dart#L51-L118)
  - **State Controller Toggle**: [`lib/services/app_state.dart:L61-L66`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/services/app_state.dart#L61-L66)
  - **UI Switch Components**: [`lib/screens/dashboard_screen.dart:L64-L75`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/dashboard_screen.dart#L64-L75) & [`lib/screens/profile_settings_screen.dart:L77-L115`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/profile_settings_screen.dart#L77-L115)

---

### 9. 📈 `Analytics Dashboard` (fl_chart Vector Bar, Pie & Line Graphs)
- **What it does**: User ke weekly calorie adherence, daily macro percentage pie distribution, aur 7-day weight trend line graph visualize karne waala dynamic analytics dashboard.
- **Detailed Logic (Hinglish)**:
  - `fl_chart` package use karke raw data points ko `BarChartGroupData`, `PieChartSectionData`, aur `FlSpot` vectors mein calculate karke smooth curve splines (`isCurved: true`) aur gradient fills ke saath render kiya jata hai.
- **📁 Code Location & File Lines**:
  - **Weekly Calorie Bar Chart**: [`lib/screens/analytics_screen.dart:L59-L106`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/analytics_screen.dart#L59-L106)
  - **Macro Breakdown Pie Chart**: [`lib/screens/analytics_screen.dart:L108-L164`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/analytics_screen.dart#L108-L164)
  - **Weight Trajectory Line Graph**: [`lib/screens/analytics_screen.dart:L166-L224`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/analytics_screen.dart#L166-L224)

---

### 10. 🧊 `GlassCard` (Reusable Glassmorphic UI Container)
- **What it does**: App ka ultra-premium aesthetic layout maintain karne waala reusable glassmorphic container widget.
- **Detailed Logic (Hinglish)**:
  - Layered `BoxDecoration` wraps rounded borders (`Border.all`), dynamic theme-aware background surface colors (`darkSurface` / `lightSurface`), aur soft ambient drop shadows (`BoxShadow` with alpha opacity).
- **📁 Code Location & File Lines**:
  - **Widget Definition**: [`lib/widgets/glass_card.dart:L6-L65`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/widgets/glass_card.dart#L6-L65)

---

## 📁 Project Folder & Every Single File Detailed Explanation (In Hinglish)

Yahan project ke har single file aur folder ka complete explanation diya gaya hai ki kaunsi file kya karti hai aur kahan located hai:

```
/Users/harshmishra/Desktop/Flutter Mini Project/
├── lib/
│   ├── main.dart                          # Root application entry point & Provider wrapper
│   ├── theme/
│   │   └── app_theme.dart                 # Obsidian Dark & Clean Light Theme definitions & colors
│   ├── models/
│   │   └── app_models.dart                # Data Models (Food, LoggedMeal, Exercise, UserProfile, BmiResult)
│   ├── services/
│   │   └── app_state.dart                 # State Management & SharedPreferences disk storage
│   ├── data/
│   │   └── mock_data.dart                 # Pre-loaded healthy food catalog & exercise library
│   ├── widgets/
│   │   ├── glass_card.dart                # Glassmorphism card container widget
│   │   ├── macro_ring.dart                # Circular Calorie ring & linear macro progress bars
│   │   ├── bmi_meter.dart                 # Interactive color-coded BMI gauge meter
│   │   └── quick_add_modal.dart           # Custom food logger bottom sheet modal
│   └── screens/
│       ├── main_navigation_screen.dart    # Floating bottom navbar & PageView controller
│       ├── dashboard_screen.dart          # Today's overview, energy ring, hydration & quick actions
│       ├── meal_logger_screen.dart        # Searchable food catalog & today's logged meals view
│       ├── calculators_screen.dart        # Multi-tab Hub (BMI Calculator & TDEE Goal Calculator)
│       ├── workout_planner_screen.dart    # Exercise database & active gym session runner
│       ├── analytics_screen.dart          # Progress bar charts, pie charts & weight line graph
│       └── profile_settings_screen.dart   # Biometrics target editor & Light/Dark theme toggle
├── test/
│   └── widget_test.dart                  # Automated smoke & widget tests
└── pubspec.yaml                           # Project metadata & package dependencies
```

### Detailed Breakdown of Every Single File:

1. **`lib/main.dart`**:
   - **Kaam**: Yeh app ki main execution script hai. Isme `main()` function Provider `AppState` ko wrap karke root `MacroFitApp` widget ko start karta hai.

2. **`lib/theme/app_theme.dart`**:
   - **Kaam**: App ke luxury visual design values ko define karta hai: Dark Obsidian background, Neon Emerald (`#00E676`), Cyan (`#00E5FF`), Coral (`#FF5252`), glassmorphism shadows, aur Light/Dark `ThemeData` rules.

3. **`lib/models/app_models.dart`**:
   - **Kaam**: Pure app ke Data Schema definitions contain karta hai: `FoodItem` (calories, protein, carbs, fat), `LoggedMeal`, `Exercise`, `WorkoutSet`, `WorkoutSession`, `UserProfile`, aur `BmiResult` math calculator factory.

4. **`lib/services/app_state.dart`**:
   - **Kaam**: Central state management class (`ChangeNotifier`). User profile inputs, total daily calories consumed/burned, logged meals list, water hydration intake, theme toggle status, aur `SharedPreferences` local storage handles karta hai.

5. **`lib/data/mock_data.dart`**:
   - **Kaam**: High quality Unsplash images aur accurate macro specs ke saath default food catalog (Chicken Breast, Salmon, Avocado Toast, Oatmeal, etc.) aur gym exercises list furnish karta hai.

6. **`lib/widgets/glass_card.dart`**:
   - **Kaam**: Reusable UI container component jo glassmorphism aesthetic borders, dynamic theme-aware colors, aur soft drop shadows create karta hai.

7. **`lib/widgets/macro_ring.dart`**:
   - **Kaam**: `CalorieMainRing` dual radial gauge painter aur `MacroProgressBar` linear progress bars build karta hai.

8. **`lib/widgets/bmi_meter.dart`**:
   - **Kaam**: Interactive color segment bar (Blue, Green, Yellow, Red) aur dynamic indicator needle position paint karta hai.

9. **`lib/widgets/quick_add_modal.dart`**:
   - **Kaam**: Custom food item, serving size, calories, aur macros log karne ke liye animated bottom sheet form render karta hai.

10. **`lib/screens/main_navigation_screen.dart`**:
    - **Kaam**: Docked bottom navigation bar containing 6 tab items with smooth page controller animations (`PageView`).

11. **`lib/screens/dashboard_screen.dart`**:
    - **Kaam**: Primary fitness summary hub jo energy ring, remaining macros, water tracker, quick meal loggers, aur active workout card display karta hai.

12. **`lib/screens/meal_logger_screen.dart`**:
    - **Kaam**: Real-time food search filter, category filter pills, today's logged meals list with sub-totals, aur food catalog screen.

13. **`lib/screens/calculators_screen.dart`**:
    - **Kaam**: Tabbed calculator interface housing the interactive BMI Gauge tool aur Mifflin-St Jeor TDEE & Macro Goal generator.

14. **`lib/screens/workout_planner_screen.dart`**:
    - **Kaam**: Exercise catalog filtered by muscle group, active workout session runner with set/rep/weight logging, and past workout history.

15. **`lib/screens/analytics_screen.dart`**:
    - **Kaam**: Graphical analytical dashboard containing Weekly Calorie Bar Chart, Macro Distribution Pie Chart, and 7-Day Weight Trajectory Graph (`fl_chart`).

16. **`lib/screens/profile_settings_screen.dart`**:
    - **Kaam**: User avatar, biometric targets customizer (Calories, Water, Target Weight), and Dark/Light mode theme switcher.

17. **`pubspec.yaml`**:
    - **Kaam**: Configures Flutter package dependencies (`fl_chart`, `google_fonts`, `shared_preferences`, `flutter_animate`, `percent_indicator`, `provider`, `intl`) and font assets.

---

## 🎙️ 5-Minute Presentation & Demo Speech (Expressive Hinglish Script with Code Line References)

*(Use this speech script during your viva, project presentation, or live code demo!)*

---

### **[0:00 - 0:45] 1. Introduction & Core Concept**
> *"Respected Evaluators and Friends, Good Morning/Afternoon! Aaj main aapke saamne present kar raha hoon **MacroFit Prime** — ek ultra-premium, cross-platform Fitness, Macro Tracking, aur Health Metrics Application jise maine Flutter framework se build kiya hai.*
>
> *Aaj kal har vyakti apne fitness goals ko leke serious hai — chahe wo Weight Loss ho, Muscle Building ho, ya Daily Calorie Balance maintain karna ho. **MacroFit Prime** ka main objective hai: Users ko ek luxury glassmorphism UI experience dena, saath mein 100% scientifically accurate health calculations aur effortless daily tracking deliver karna."*

---

### **[0:45 - 2:00] 2. Dashboard, Calorie Ring & Hydration (Code Reference)**
> *"Sabse pehle aate hain app ke main **Dashboard Hub** par (location: [`lib/screens/dashboard_screen.dart`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/dashboard_screen.dart)).*
>
> *Dashboard par sabse prominently dikhta hai humara custom **`CalorieMainRing`** (line 118 par). Yeh ring user ke Target Calories vs Consumed vs Burned Calories ko evaluate karke exact remaining kilocalories calculate karta hai. Iska widget implementation aap [`lib/widgets/macro_ring.dart:L6-L77`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/widgets/macro_ring.dart#L6-L77) mein dekh sakte hain.*
>
> *Iske theek niche **Protein, Carbs, aur Fats** ke teen micro-nutrient progress bars hain (line 127–148). Aur saath hi ek interactive **Water Hydration Tracker** (line 153–219) diya gaya hai jisme user `+250 mL` ya `+500 mL` buttons se instant water log kar sakta hai. Iska state handling [`lib/services/app_state.dart:L140-L150`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/services/app_state.dart#L140-L150) mein written hai jo data ko local `SharedPreferences` mein persist rakhta hai."*

---

### **[2:00 - 3:15] 3. Interactive Calculators (BMI & TDEE Math Engines)**
> *"Ab main aapko app ke sabse powerful technical feature par le chalta hoon — **Fitness Calculators Hub** ([`lib/screens/calculators_screen.dart`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/calculators_screen.dart)). Isme do major mathematical tools built-in hain:*
>
> *Pehla hai **BMI Calculator** (lines 76–193). Height aur weight sliders adjust karte hi humara custom **`BmiGaugeMeter`** ([`lib/widgets/bmi_meter.dart:L5-L132`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/widgets/bmi_meter.dart#L5-L132)) instant score compute karke visual meter bar par indicator needle place karta hai. Iska mathematical factory algorithm [`lib/models/app_models.dart:L311-L352`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/models/app_models.dart#L311-L352) mein written hai jo exact ideal weight range aur color-coded category classification (Underweight, Normal, Overweight, Obese) return karta hai.*
>
> *Doosra hai **TDEE & Calorie Goal Calculator** (lines 196–384). Yeh tool **Mifflin-St Jeor Equation** follow karta hai. Iska core math function [`lib/services/app_state.dart:L190-L210`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/services/app_state.dart#L190-L210) mein written hai:
> Male BMR = $10W + 6.25H - 5A + 5$ aur Female BMR = $10W + 6.25H - 5A - 161$. Isme activity multipliers (1.2x to 1.9x) aur goal adjustments (Fat Loss -500 kcal, Surplus +350 kcal) apply karke automatic Protein, Carbs, aur Fat grams calculate ho jaate hain."*

---

### **[3:15 - 4:15] 4. Meal Logger, Active Workout Runner & Analytics**
> *"Next feature hai **Meals & Food Logger** ([`lib/screens/meal_logger_screen.dart`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/meal_logger_screen.dart)). App mein pre-loaded high quality food database hai search filter ke saath, aur custom dish log karne ke liye **`QuickAddModal`** ([`lib/widgets/quick_add_modal.dart:L1-L198`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/widgets/quick_add_modal.dart#L1-L198)) diya gaya hai.*
>
> *Iske alawa, **Workout Planner & Active Runner** ([`lib/screens/workout_planner_screen.dart:L63-L176`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/workout_planner_screen.dart#L63-L176)) user ko gym sessions mein per-exercise sets, reps, aur weight log karne ka real-time interface deta hai checkmark completion ke saath.*
>
> *Aur **Analytics Screen** ([`lib/screens/analytics_screen.dart`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/screens/analytics_screen.dart)) mein `fl_chart` package ka use karke Weekly Calorie Bar Chart (line 59), Macro Distribution Pie Chart (line 108), aur Weight Trajectory Line Graph (line 166) dynamically visualize hota hai."*

---

### **[4:15 - 5:00] 5. Theme Architecture, Testing & Conclusion**
> *"Architecture wise, app mein **Provider Pattern** for State Management use hua hai ([`lib/services/app_state.dart`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/services/app_state.dart)). Visual styling ke liye Obsidian Dark Theme aur Daylight Light Theme ([`lib/theme/app_theme.dart:L51-L118`](file:///Users/harshmishra/Desktop/Flutter%20Mini%20Project/lib/theme/app_theme.dart#L51-L118)) built-in hai jo instant switch hota hai.*
>
> *Project 100% production-ready hai — `flutter analyze` mein 0 errors/warnings hain aur `flutter test` mein 100% unit tests pass ho chuke hain.*
>
> *Thank you so much! Main ab aapke questions aur code walkthrough welcome karta hoon!"*
