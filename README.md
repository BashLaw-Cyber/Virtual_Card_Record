# Virtual Card Keeper  

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)  
![License](https://img.shields.io/badge/License-MIT-green)  
![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen)  
![Status](https://img.shields.io/badge/Status-Active-success)  

A simple and secure **virtual card keeping app** that allows users to store, organize, and manage their important cards (ID cards, business cards, membership cards, etc.) digitally in one place.  

---

## **Features**  
  
- 🗂 **Card Categories**: Organize cards by type (All and Favorite). 
- 📷 **Scan & Extract Info**: Scan physical cards (using OCR) and automatically extract details.
- ✏️ **Edit Card Details**: Modify card information after scanning or adding manually.  
- 📶 **Offline Access**: Access your cards without internet.  

---

## **Tech Stack** 
- **Frontend**: [Flutter](https://flutter.dev/) (Dart)  
- **Backend**: Local SQLite  

---

## 📸 Screenshots

![Home Screen](lib/screenshots/homepage.png)  
![Add Card](lib/screenshots/addcard.png)
![Pick/Scan Card](lib/screenshots/pickimage.png)
![Extracted Card Info](lib/screenshots/extractedInfo.png)
![Extracted Card Info Edition](lib/screenshots/infoEdition.png)
![Contact/Card List](lib/screenshots/contactlist.png)
![Contact/Card Detail](lib/screenshots/contactDetail.png)

---

## 🎥 Demo Video / GIF

- **GIF Example:**

![App Demo](lib\screenshots\vcardGif.gif)
![App Demo](lib\screenshots\vcardGif2.gif)

---

### **For Developers**  
```bash
# Clone the repository
git clone https://github.com/BashLaw-Cyber/Virtual_Card_Record.git
cd VCARD

# Install dependencies
flutter pub get

# Run the app
flutter run