
## Project Overview

A beginner/intermediate-level **Healthcare Management System** developed in **8086 Assembly Language** for **EMU8086**.

The project demonstrates basic 8086 Assembly concepts through a simple, menu-driven healthcare system.

---

## 🏥 1. Patient Management

### Features
1. Add Patient
2. View Patient
3. Search Patient by ID
4. Update Patient
5. Delete Patient

### Patient Information
- Patient ID
- Patient Name
- Age
- Gender
- Phone Number

**Maximum Records:** 10 Patients

---

## 👨‍⚕️ 2. Doctor Management

### Features
1. Add Doctor
2. View Doctors
3. Search Doctor by ID
4. Doctor Specialization
5. Doctor Availability

### Doctor Information
- Doctor ID
- Doctor Name
- Specialization
- Availability

**Maximum Records:** 10 Doctors

---

## 📅 3. Appointment Management

### Features
1. Book Appointment
2. View Appointment
3. Search Appointment
4. Cancel Appointment
5. Appointment Status

### Appointment Information
- Appointment ID
- Patient ID
- Doctor ID
- Date
- Status

### Appointment Status
- Pending
- Confirmed
- Completed
- Cancelled

**Maximum Records:** 10 Appointments

---

## 💊 4. Pharmacy Management

### Features
1. Add Medicine
2. View Medicines
3. Search Medicine
4. Check Stock
5. Medicine Price

### Medicine Information
- Medicine ID
- Medicine Name
- Quantity / Stock
- Price

### Stock Status
- Available
- Out of Stock

**Maximum Records:** 10 Medicines

---

## 🖥️ 5. General System Features

The system also includes:

- Welcome Screen
- Main Menu
- Four Separate Management Panels
- Submenus
- Back to Main Menu
- Invalid Choice Handling
- "Press Any Key to Continue"
- Program Exit
- Basic Error Handling
- Record Not Found Messages
- Success Messages

---

## ⚙️ 6. 8086 Assembly Concepts Demonstrated

The project demonstrates the following concepts:

- `MOV`
- `CMP`
- `JMP`
- `JE`
- `JNE`
- `LOOP`
- `CALL`
- `RET`
- `INT 21H`
- Character Input
- Number Input
- String Input
- String Output
- Arrays
- Variables
- Counters
- Procedures
- Conditional Branching
- Searching
- Simple Arithmetic
- Active / Deleted Record Flags
- Stack Usage
- Register Usage

---

## 📊 Project Requirements Summary

| Panel | Number of Features |
|---|---:|
| Patient Management | 5 |
| Doctor Management | 5 |
| Appointment Management | 5 |
| Pharmacy Management | 5 |
| **Total** | **20** |

The project contains **4 main panels** and **20 major features**.

---

## 🗂️ Main System Structure

```text
Healthcare Management System
│
├── Main Menu
│
├── Patient Management
│   ├── Add Patient
│   ├── View Patient
│   ├── Search Patient
│   ├── Update Patient
│   └── Delete Patient
│
├── Doctor Management
│   ├── Add Doctor
│   ├── View Doctors
│   ├── Search Doctor
│   ├── Specialization
│   └── Availability
│
├── Appointment Management
│   ├── Book Appointment
│   ├── View Appointment
│   ├── Search Appointment
│   ├── Cancel Appointment
│   └── Appointment Status
│
└── Pharmacy Management
    ├── Add Medicine
    ├── View Medicines
    ├── Search Medicine
    ├── Check Stock
    └── Medicine Price