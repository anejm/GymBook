# Fitness Tracker – Application Layout & Feature Plan

## 1. Osnovna ideja

Mobilna fitness aplikacija za beleženje treningov, vaj, setov, teže in ponovitev.

Glavni cilj aplikacije:

* hitro začeti trening
* hitro zapisovati sete
* pregledati pretekle treninge
* spremljati napredek skozi grafe in statistiko
* imeti pregled nad osebnimi fitness podatki
* omogočiti uporabniški profil in nastavitve

---

# 2. Glavna navigacija

Aplikacija ima glavno stran `Home`, iz katere uporabnik dostopa do najpomembnejših funkcij.

Predlagana struktura:

```text
                         FITNESS APP
                              │
          ┌───────────────────┼───────────────────┐
          │                   │                   │
       ← swipe              HOME              swipe →
          │                   │                   │
          ▼                   │                   ▼
     CALCULATOR               │               PROFILE
     & INSIGHTS               │               SETTINGS
                              │
                              │
                         NEW WORKOUT
                              │
                              ▼
                       WORKOUT SETUP
                              │
                              ▼
                       ACTIVE WORKOUT
                              │
                              ▼
                       WORKOUT SUMMARY
                              │
                              ▼
                             HOME

HOME
 │
 └── HISTORY
       │
       ├── By Workouts
       │      └── Workout Details
       │             ├── Graph
       │             └── Statistics table
       │
       └── By Exercises
              └── Exercise Details
                     ├── Graph
                     └── Statistics table
```

### Predlog spremembe

Namesto da bi bile vse funkcije skrite samo za swipe gestami, bi imel spodaj subtilno navigacijo ali jasne ikone.

Swipe lahko ostane kot dodatna funkcionalnost:

* swipe left → Profile
* swipe right → Insights / Calculator

Glavne funkcije pa naj bodo vedno hitro dostopne.

---

# 3. LOGIN

Prvi ekran aplikacije.

```text
┌─────────────────────────────┐
│                             │
│        FITNESS APP          │
│                             │
│     Track your progress     │
│                             │
│                             │
│       [ Continue ]          │
│                             │
│       [ Login ]             │
│                             │
│   Continue with Google      │
│                             │
└─────────────────────────────┘
```

### Funkcionalnost

* Continue / Enter
* Login
* Google login
* kasneje registracija
* kasneje Forgot password

Za prvo verzijo lahko `Continue` samo odpre Home, da najprej razvijemo aplikacijo.

---

# 4. HOME

Glavni center aplikacije.

```text
┌─────────────────────────────┐
│  ☰ / profile       FITNESS  │
│                             │
│  Good evening               │
│  Anej                       │
│                             │
│  ┌─────────────────────────┐│
│  │                         ││
│  │     + NEW WORKOUT       ││
│  │                         ││
│  └─────────────────────────┘│
│                             │
│  ┌─────────────────────────┐│
│  │        HISTORY          ││
│  └─────────────────────────┘│
│                             │
│  Recent workout             │
│                             │
│  Push             1h 05m    │
│  Pull             58m       │
│  Legs             1h 12m    │
│                             │
│  ← swipe →                 │
└─────────────────────────────┘
```

Home naj bo zelo preprost.

Glavni cilj uporabnika je:

> Odpre aplikacijo → klikne New Workout → začne trenirati.

Zato ne bi Home strani preveč napolnil s statistiko.

---

# 5. NEW WORKOUT

Ko uporabnik klikne `New Workout`.

```text
┌─────────────────────────────┐
│ ← New Workout               │
│                             │
│ Search workouts...          │
│                             │
│ Recent                      │
│                             │
│ ┌─────────────────────────┐ │
│ │ Push A                  │ │
│ │ Bench / Incline / ...   │ │
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │
│ │ Pull A                  │ │
│ │ Pullups / Rows / ...    │ │
│ └─────────────────────────┘ │
│                             │
│                             │
│       CREATE NEW            │
│                             │
└─────────────────────────────┘
```

Uporabnik ima dve možnosti:

### Recent workout

Klikne prejšnji trening.

Nato:

```text
Push A

Bench Press
Incline DB Press
Lateral Raise
Triceps Pushdown

       [ START ]
```

Uporabnik lahko še vedno kaj spremeni.

### Create New

Odpre nov prazen workout.

---

# 6. CREATE NEW WORKOUT

```text
┌─────────────────────────────┐
│ ← New Workout               │
│                             │
│ Workout name                │
│ [ Push A                 ]  │
│                             │
│ Search exercises...         │
│                             │
│ Selected exercises          │
│                             │
│ Bench Press             ☰  │
│ Incline DB Press         ☰ │
│ Lateral Raise            ☰ │
│                             │
│                             │
│        + ADD EXERCISE       │
│                             │
│          [ START ]          │
└─────────────────────────────┘
```

### Add Exercise

Na dnu ali kot popup:

```text
┌─────────────────────────────┐
│ Search exercise...          │
│                             │
│ Chest                       │
│  Bench Press                │
│  Incline Bench Press        │
│  Cable Fly                  │
│                             │
│ Back                        │
│  Pull Up                    │
│  Lat Pulldown               │
│  Barbell Row                │
│                             │
│ Legs                        │
│  Squat                      │
│  Leg Press                  │
│  RDL                        │
└─────────────────────────────┘
```

Search je zelo pomemben, ker bo uporabnik sčasoma imel ogromno vaj.

---

# 7. ACTIVE WORKOUT

Ko klikne `START`, pride na glavni workout ekran.

```text
┌─────────────────────────────┐
│ ← Push A              ⋮     │
│                             │
│ Bench Press                 │
│                             │
│ Set     Weight      Reps     │
│ ─────────────────────────── │
│  1       80 kg       8      │
│  2       80 kg       8      │
│  3       77.5 kg     9      │
│                             │
│         + ADD SET           │
│                             │
│ Incline DB Press            │
│                             │
│ Set     Weight      Reps     │
│ ─────────────────────────── │
│  1       24 kg       9      │
│  2       24 kg       8      │
│                             │
│         + ADD SET           │
│                             │
│                             │
│       ⏱  42:18              │
│                             │
└─────────────────────────────┘
```

To je najpomembnejši ekran celotne aplikacije.

---

# 8. ADD SET

Ko uporabnik klikne `+ ADD SET`:

```text
┌─────────────────────────────┐
│ Add Set                     │
│                             │
│ Weight                      │
│ [ 80.0 ] kg                 │
│                             │
│ Reps                        │
│ [ 8 ]                       │
│                             │
│ ☑ Use same weight            │
│   for next sets             │
│                             │
│         [ ADD ]             │
└─────────────────────────────┘
```

### Same weight

Če uporabnik vklopi:

`Use same weight`

se pri naslednjem setu avtomatsko predlaga ista teža.

Na primer:

```text
Set 1 → 80 kg
Set 2 → 80 kg
Set 3 → 80 kg
```

Uporabnik lahko težo še vedno spremeni.

---

# 9. INTERAKCIJA Z VAJO

Ko uporabnik klikne na vajo:

```text
Bench Press
```

se lahko kartica razširi.

```text
Bench Press

Set   Weight   Reps

1     80 kg     8
2     80 kg     8
3     77.5 kg   9

+ ADD SET

RIR
Notes
Rest timer
```

Ponoven klik jo skrči.

To je boljša rešitev kot odpiranje popolnoma nove strani za vsak klik, ker uporabnik med treningom želi čim manj navigacije.

---

# 10. WORKOUT TIMER

Na dnu je vedno viden timer:

```text
⏱ 42:18
```

Klik na timer odpre:

```text
┌─────────────────────────────┐
│                             │
│          WORKOUT            │
│                             │
│           42:18             │
│                             │
│       [ PAUSE ]             │
│                             │
│       [ FINISH ]            │
│                             │
└─────────────────────────────┘
```

### Pause

Začasno ustavi timer.

### Finish

Odpre confirmation:

```text
Finish workout?

Duration: 1h 04m
Exercises: 5
Sets: 17
Volume: 8,420 kg

[ CANCEL ]     [ FINISH ]
```

Po potrditvi se workout shrani.

---

# 11. WORKOUT SUMMARY

Po končanem treningu:

```text
┌─────────────────────────────┐
│       WORKOUT COMPLETE      │
│                             │
│           ✓                 │
│                             │
│ Push A                      │
│                             │
│ Duration        1h 04m      │
│ Exercises       5           │
│ Sets            17          │
│ Volume          8,420 kg    │
│                             │
│ New PRs        2 🏆         │
│                             │
│          [ DONE ]           │
└─────────────────────────────┘
```

Potem gre uporabnik nazaj na Home.

---

# 12. HISTORY

Home → History.

Na vrhu sta dva načina prikaza:

```text
┌─────────────────────────────┐
│ History                     │
│                             │
│ [ Workouts ] [ Exercises ]  │
│                             │
│ Search...                   │
└─────────────────────────────┘
```

## Workouts

```text
Push A
18 Aug
1h 04m
17 sets
8,420 kg

Pull A
16 Aug
58m
15 sets
7,210 kg
```

## Exercises

```text
Bench Press
82.5 kg PR
Last: 80 kg
+3.1%

Squat
120 kg PR
Last: 115 kg
+4.3%
```

---

# 13. HISTORY → WORKOUT DETAILS

Ko klikne trening:

```text
┌─────────────────────────────┐
│ ← Push A                    │
│                             │
│        VOLUME GRAPH         │
│                             │
│       ╱╲                    │
│  ╱───╯  ╲────╮              │
│ ╱           ╰──             │
│                             │
│ Volume: 8,420 kg            │
│                             │
│ Set    Weight      Reps      │
│ ─────────────────────────── │
│ 1       80 kg       8       │
│ 2       80 kg       8       │
│ 3       77.5 kg     9       │
│                             │
└─────────────────────────────┘
```

---

# 14. HISTORY → EXERCISE DETAILS

To bo še bolj uporabno.

Primer:

```text
Bench Press
```

Na vrhu graf:

```text
Weight / Estimated 1RM

90 ┤                    ●
85 ┤              ●  ●
80 ┤        ●  ●
75 ┤  ●  ●
   └────────────────────
```

Pod grafom:

```text
Statistics

Date        Weight    Reps    Volume
─────────────────────────────────────
18 Aug       82.5      8       660
14 Aug       80        8       640
10 Aug       80        7       560
06 Aug       77.5      9       697.5
```

Kasneje lahko uporabnik izbira:

```text
[ Weight ] [ 1RM ] [ Volume ] [ Reps ]
```

---

# 15. PROFILE / SETTINGS

Swipe left iz Home ali ikona profila.

```text
┌─────────────────────────────┐
│ Profile                     │
│                             │
│        👤                   │
│        Anej                  │
│        email@email.com      │
│                             │
│ Profile                     │
│ ├── Bodyweight              │
│ ├── Height                  │
│ └── Goals                   │
│                             │
│ Preferences                 │
│ ├── Units (kg/lb)           │
│ ├── Theme                   │
│ ├── Notifications           │
│ └── Rest timer              │
│                             │
│ Account                     │
│ ├── Google account          │
│ ├── Change password        │
│ └── Logout                  │
└─────────────────────────────┘
```

---

# 16. INSIGHTS / CALCULATOR

Swipe right iz Home.

Namesto da bi takoj naredili ogromno funkcij, bi to stran imenoval:

## Insights

Tukaj lahko kasneje dodajamo različne kalkulatorje in podatke.

```text
┌─────────────────────────────┐
│ Insights                    │
│                             │
│ 1RM Calculator              │
│ ┌─────────────────────────┐ │
│ │ Weight: 80 kg           │ │
│ │ Reps:   8               │ │
│ │                         │ │
│ │ Estimated 1RM: 101 kg  │ │
│ └─────────────────────────┘ │
│                             │
│ BMI / Bodyweight            │
│ Recovery                    │
│ Training Volume             │
│ Weekly Frequency            │
│                             │
└─────────────────────────────┘
```

### Kasneje

Lahko dodamo:

* estimated 1RM
* BMI
* bodyweight trend
* weekly volume
* muscle group volume
* training frequency
* strength standards
* percentil glede na populacijo
* calorie/macronutrient calculator
* plate calculator

Pri "percentilu glede na populacijo" morava biti previdna glede virov podatkov. Bolje je uporabljati preverjene podatke kot si izmišljati številke.

---

# 17. CALENDAR

Še en swipe desno oziroma dodatna stran.

```text
┌─────────────────────────────┐
│ August 2026                 │
│                             │
│ M  T  W  T  F  S  S        │
│                1  2         │
│ 3  4  5  6  7  8  9        │
│10 11 12 13 14 15 16        │
│17 18 19 20 21 22 23        │
│24 25 26 27 28 29 30        │
│31                           │
│                             │
│ ● = workout                 │
│                             │
│ 18 Aug                      │
│ Push A — 1h 04m            │
└─────────────────────────────┘
```

Ko klikneš datum, pokaže treninge tega dne.

---

# 18. Celotna struktura aplikacije

```text
                         LOGIN
                           │
                           ▼
                          HOME
                           │
       ┌───────────────────┼───────────────────┐
       │                   │                   │
       ▼                   ▼                   ▼
    HISTORY           NEW WORKOUT           PROFILE
       │                   │                   │
       │             ┌─────┴──────┐            │
       │             │            │            │
       │          RECENT       CREATE          │
       │             │            │            │
       │             └─────┬──────┘            │
       │                   │                   │
       │                   ▼                   │
       │              WORKOUT SETUP            │
       │                   │                   │
       │                   ▼                   │
       │             ACTIVE WORKOUT            │
       │                   │                   │
       │                   ▼                   │
       │             WORKOUT SUMMARY           │
       │                   │                   │
       │                   └──────► HOME       │
       │                                       │
       ▼                                       ▼
 WORKOUT DETAILS                         SETTINGS
       │
       ▼
 EXERCISE DETAILS


HOME
 │
 ├── swipe right → INSIGHTS
 │
 └── swipe further → CALENDAR
```

---

# 19. Predlagana struktura Flutter projekta

Ko bo projekt večji, ga ne bomo imeli vsega v `main.dart`.

```text
lib/
│
├── main.dart
│
├── screens/
│   ├── login/
│   │   └── login_page.dart
│   │
│   ├── home/
│   │   └── home_page.dart
│   │
│   ├── workout/
│   │   ├── workout_setup_page.dart
│   │   ├── active_workout_page.dart
│   │   └── workout_summary_page.dart
│   │
│   ├── history/
│   │   ├── history_page.dart
│   │   ├── workout_details_page.dart
│   │   └── exercise_details_page.dart
│   │
│   ├── insights/
│   │   └── insights_page.dart
│   │
│   ├── calendar/
│   │   └── calendar_page.dart
│   │
│   └── profile/
│       └── profile_page.dart
│
├── widgets/
│   ├── workout_card.dart
│   ├── exercise_card.dart
│   ├── set_row.dart
│   ├── statistic_card.dart
│   └── workout_timer.dart
│
├── models/
│   ├── exercise.dart
│   ├── workout.dart
│   ├── workout_set.dart
│   └── user_profile.dart
│
├── services/
│   ├── auth_service.dart
│   ├── workout_service.dart
│   └── exercise_service.dart
│
└── theme/
    └── app_theme.dart
```

---

# 20. Razvoj aplikacije po fazah

Ne bomo vsega naredili naenkrat.

## Phase 1 — UI prototype

Brez baze.

* Login
* Home
* New Workout
* Workout
* History
* Profile
* Insights

Cilj: aplikacija izgleda in se premika med stranmi.

---

## Phase 2 — Workout functionality

* Add exercise
* Add set
* Weight
* Reps
* Same weight
* Timer
* Pause
* Finish workout
* Workout summary

---

## Phase 3 — Database

Supabase + PostgreSQL:

```text
users
exercises
workouts
workout_exercises
sets
```

---

## Phase 4 — Authentication

* Email/password
* Google login
* user profiles
* Row Level Security

---

## Phase 5 — History

* workout history
* exercise history
* search
* sorting
* filters
* workout details
* exercise details

---

## Phase 6 — Statistics

* volume
* weight
* reps
* estimated 1RM
* PRs
* frequency
* muscle group volume
* progress graphs

---

## Phase 7 — Polish

* animations
* dark mode
* responsive UI
* loading states
* error handling
* offline handling
* notifications
* settings

---

# 21. Najpomembnejši UX princip

Aplikacija mora biti med treningom **hitrejša od pisanja v beležko**.

Glavni workflow mora biti:

```text
Open app
   ↓
New Workout
   ↓
Select recent workout
   ↓
Start
   ↓
Click exercise
   ↓
Add Set
   ↓
Weight + Reps
   ↓
Add
   ↓
Next set
   ↓
Finish
   ↓
Done
```

Če uporabnik za vnos enega seta potrebuje 15 klikov, je aplikacija slaba.

Zato bomo pri dejanski implementaciji dali velik poudarek na **hitro vnašanje podatkov** in uporabo zadnjih vrednosti kot privzetih.

---

# 22. Prva verzija (MVP)

Za prvo dejansko delujočo verzijo ne potrebujemo vsega zgoraj.

MVP:

```text
LOGIN
  ↓
HOME
  ├── NEW WORKOUT
  │     ├── Recent
  │     └── Create New
  │
  └── HISTORY
        ├── Workouts
        └── Exercises

WORKOUT
  ├── Exercises
  ├── Sets
  ├── Weight
  ├── Reps
  ├── Timer
  └── Finish

DATABASE
  ├── Users
  ├── Exercises
  ├── Workouts
  └── Sets
```

Šele ko to deluje brez težav, dodajamo grafe, Insights, Calendar, Google login in ostale funkcije.

---

# 23. Glavna razvojna filozofija

Aplikacije ne bomo naredili tako, da napišemo ogromno kode in upamo, da bo delovala.

Gradili jo bomo:

```text
UI
 ↓
Interaction
 ↓
State
 ↓
Data model
 ↓
Database
 ↓
Authentication
 ↓
Statistics
```

Vsak korak bo delujoč, preden greva na naslednjega.

