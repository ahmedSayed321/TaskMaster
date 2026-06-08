# TaskMaster

A native iOS task management app that helps users organize their daily tasks across three distinct workflow states — **Todo**, **In Progress**, and **Done** — built with Objective-C using the MVC architectural pattern.

---

## 📱 Screenshots

<table>
  <tr>
    <td align="center"><b>Splash Screen</b></td>
    <td align="center"><b>Todo List</b></td>
    <td align="center"><b>In Progress</b></td>
    <td align="center"><b>Done</b></td>
  </tr>
  <tr>
    <td><img src="TodoApp/Screens/Simulator Screenshot - iPhone 16 Pro - 2026-06-08 at 16.52.23.png" width="180"/></td>
    <td><img src="TodoApp/Screens/Simulator Screenshot - iPhone 16 Pro - 2026-06-08 at 16.52.32.png" width="180"/></td>
    <td><img src="TodoApp/Screens/Simulator Screenshot - iPhone 16 Pro - 2026-06-08 at 16.52.39.png" width="180"/></td>
    <td><img src="TodoApp/Screens/Simulator Screenshot - iPhone 16 Pro - 2026-06-08 at 16.52.42.png" width="180"/></td>
  </tr>
  <tr>
    <td align="center"><b>Add Task</b></td>
    <td align="center"><b>Date Picker</b></td>
    <td align="center"><b>Live Notification</b></td>
    <td align="center"><b>Search</b></td>
  </tr>
  <tr>
    <td><img src="TodoApp/Screens/Simulator Screenshot - iPhone 16 Pro - 2026-06-08 at 16.53.21.png" width="180"/></td>
    <td><img src="TodoApp/Screens/Simulator Screenshot - iPhone 16 Pro - 2026-06-08 at 16.53.40.png" width="180"/></td>
    <td><img src="TodoApp/Screens/Simulator Screenshot - iPhone 16 Pro - 2026-06-08 at 16.55.01.png" width="180"/></td>
    <td><img src="TodoApp/Screens/Simulator Screenshot - iPhone 16 Pro - 2026-06-08 at 16.55.44.png" width="180"/></td>
  </tr>
</table>

---

## ✨ Features

- **Three-State Workflow** — Tasks live in one of three lanes: **Todo**, **In Progress**, and **Done**, navigated via a tab bar
- **Add Tasks** — Create a task with a title, description, priority level, and a scheduled reminder date/time
- **Edit & Promote Tasks** — Tap any task to edit its details or change its status (Todo → In Progress → Done), which automatically moves it to the correct lane
- **Priority Filtering** — Filter tasks by **Low**, **Medium**, or **High** priority using a segmented control on every list screen
- **Color-Coded Priority** — Green dot for Low, Yellow for Medium, Red for High — at a glance
- **Live Search** — Real-time search bar on every tab; filters the currently selected priority segment
- **Swipe to Delete** — Native swipe-to-delete with automatic list and persistence update
- **Local Notifications** — Schedules a `UNCalendarNotificationTrigger` reminder at the exact date/time set when adding or editing a task
- **Full Offline Persistence** — All tasks are stored locally using `NSUserDefaults` + `NSKeyedArchiver` (Secure Coding) — no internet required
- **Custom UI Styling** — Dark-mode first design with a gold/amber accent palette, rounded table views, and white-tinted search bars

---

## 🏗 Architecture & Tech Stack

| Category         | Detail                                              |
|-----------------|-----------------------------------------------------|
| **Language**     | Objective-C                                         |
| **Architecture** | MVC (Model – View – Controller)                     |
| **UI Framework** | UIKit (Storyboards + Tab Bar Controller)            |
| **Persistence**  | `NSUserDefaults` + `NSKeyedArchiver` / `NSKeyedUnarchiver` |
| **Notifications**| `UserNotifications` framework (`UNCalendarNotificationTrigger`) |
| **Delegation**   | Custom `MyDelegation` protocol for cross-controller data refresh |

---

## 🗂 Project Structure

```
TaskMaster/
├── TodoApp/
│   ├── Task.h / Task.m                  # Model: title, description, priority, status, date
│   ├── TodoViewController.h / .m        # Todo tab — list, filter, search, add, delete
│   ├── InProgressViewController.h / .m  # In Progress tab — list, filter, search, edit, delete
│   ├── DoneViewController.h / .m        # Done tab — list, filter, search, edit, delete
│   ├── AddTaskViewController.h / .m     # Modal: create a new task + schedule notification
│   ├── EditTaskViewController.h / .m    # Modal: edit task, change status, reschedule notification
│   ├── MyDelegation.h                   # Protocol: loadData delegate used across controllers
│   ├── AppDelegate.h / .m              # App lifecycle
│   ├── SceneDelegate.h / .m            # Scene lifecycle
│   └── Base.lproj/                      # Storyboard UI definitions
│       └── Main.storyboard
├── Assets.xcassets/                     # App icons and image assets
└── Screens/                             # App screenshots
```

---

## 🔄 Data Flow

```
AddTaskViewController
        │
        │  NSKeyedArchiver → NSUserDefaults["todos"]
        ▼
TodoViewController  ──(edit tap)──►  EditTaskViewController
        │                                     │
        │                           Reads old key, removes task
        │                           Writes task to new key (todos / inprogress / done)
        ▼                                     │
NSUserDefaults                        MyDelegation.loadData()
  ["todos"]                                   │
  ["inprogress"]           ◄──────────────────┘
  ["done"]
```

Each tab reads from its own `NSUserDefaults` key and rebuilds its Low / Medium / High priority sub-arrays on every `viewWillAppear`.

---

## 🔔 Notifications

When a task is created or edited, `AddTaskViewController` / `EditTaskViewController` schedules a local notification:

```objc
UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
content.title = @"Task reminder";
content.body  = task.title;
content.sound = [UNNotificationSound defaultSound];

NSDateComponents *components = [[NSCalendar currentCalendar]
    components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                NSCalendarUnitHour | NSCalendarUnitMinute)
      fromDate:task.date];

UNCalendarNotificationTrigger *trigger =
    [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];

UNNotificationRequest *request =
    [UNNotificationRequest requestWithIdentifier:[[NSUUID UUID] UUIDString]
                                         content:content
                                         trigger:trigger];

[[UNUserNotificationCenter currentNotificationCenter]
    addNotificationRequest:request withCompletionHandler:nil];
```

---

## 🚀 Getting Started

### Requirements
- Xcode 15+
- iOS 16.0+
- iPhone or Simulator

### Run

1. Clone the repository:
   ```bash
   git clone https://github.com/ahmedSayed321/TaskMaster.git
   ```
2. Open `TaskMaster.xcodeproj` in Xcode
3. Select your target simulator or connected device
4. Press **⌘ R** to build and run

> No third-party dependencies or package managers required.

---

## 📄 License

This project is for educational purposes.
