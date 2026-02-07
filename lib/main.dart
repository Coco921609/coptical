import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'feasts_screen.dart';
import 'fasts_screen.dart';
import 'did_you_know_screen.dart';
import 'settings_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendrier Copte',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF8C022E),
      ),
      home: const SettingsScreen(), // Ou ton écran principal
    );
  }
}

// ==========================================
// GESTIONNAIRE GLOBAL (Filtres & Réglages)
// ==========================================
class FilterManager {
  // --- Liste des événements désactivés ---
  static Set<String> disabledEvents = {};

  // --- Design des Post-it (Les variables qui manquaient) ---
  static String postItStyle = 'Classique';
  static Color postItColor = const Color(0xFF1E1E1E);
  static String circleStyle = 'Plein';
  static Color circleColor = const Color(0xFFFF4081);

  // --- Tailles de police (Clés exactes pour correspondre aux sliders) ---
  static Map<String, double> fontSizes = {
    "Saviez-vous ?": 18.0,
    "Fêtes": 18.0,
    "Jeûnes": 18.0,
  };

  // --- Effets de transition ---
  static Map<String, String> effects = {
    "Saviez-vous ?": "Par défaut",
    "Fêtes": "Par défaut",
    "Jeûnes": "Par défaut",
  };

  // --- Logique de visibilité ---
  static bool isVisible(String name) => !disabledEvents.contains(name);

  // --- Méthode pour réinitialiser (Optionnel mais pratique) ---
  static void resetToDefault() {
    disabledEvents.clear();
    postItStyle = 'Classique';
    postItColor = const Color(0xFF1E1E1E);
    fontSizes = {
      "Saviez-vous ?": 18.0,
      "Fêtes": 18.0,
      "Jeûnes": 18.0,
    };
    effects = {
      "Saviez-vous ?": "Par défaut",
      "Fêtes": "Par défaut",
      "Jeûnes": "Par défaut",
    };
  }
}

// --- CLASSE DE DONNÉES (INDISPENSABLE POUR AFFICHER LES ÉVÉNEMENTS) ---
class CopticEvent {
  final String name;
  final Color color;
  CopticEvent(this.name, this.color);
}



// --- NAVIGATION PRINCIPALE ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Liste des écrans
  final List<Widget> _screens = [
    const Center(child: Text("Calendrier / Savoir")),
    const Center(child: Text("Fêtes")),
    const Center(child: Text("Jeûnes")),
    const SettingsScreen(), // Votre écran de réglages
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF161616),
        selectedItemColor: const Color(0xFFFF4081),
        unselectedItemColor: Colors.white24,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'saviez-vous ?'),
          BottomNavigationBarItem(icon: Icon(Icons.celebration), label: 'Fêtes'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Jeûnes'),          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Réglages'),
        ],
      ),
    );
  }
}

// ==========================================
// MODÈLES ET DONNÉES COPTES
// ==========================================
class CopticData {
  static int getCopticYear(DateTime date) {
    int startDay = (date.year % 4 == 3) ? 12 : 11;
    return (date.month < 9 || (date.month == 9 && date.day < startDay))
        ? date.year - 284
        : date.year - 283;
  }

  static String getCopticMonthName(int gregorianMonth) {
    const monthsMap = {
      1: "TOBA", 2: "AMSHIR", 3: "BARAMHAT", 4: "BARAMOUDA",
      5: "BASHANS", 6: "PAONA", 7: "EPEP", 8: "MERSA",
      9: "TOUT", 10: "BABA", 11: "HATOR", 12: "KIAHK"
    };
    return monthsMap[gregorianMonth] ?? "";
  }

  static Color getMonthColor(String monthName) {
    switch (monthName) {
      case "TOUT": return Colors.redAccent;
      case "BABA": return Colors.orangeAccent;
      case "HATOR": return Colors.yellowAccent;
      case "KIAHK": return Colors.greenAccent;
      case "TOBA": return Colors.cyanAccent;
      case "AMSHIR": return Colors.blueAccent;
      case "BARAMHAT": return Colors.indigoAccent;
      case "BARAMOUDA": return Colors.purpleAccent;
      case "BASHANS": return Colors.pinkAccent;
      case "PAONA": return Colors.tealAccent;
      case "EPEP": return Colors.amberAccent;
      case "MERSA": return Colors.limeAccent;
      case "NASIE": return Colors.deepOrangeAccent;
      default: return Colors.white;
    }
  }

  static CopticEvent? getEventForDay(DateTime day) {
    int year = day.year;
    int month = day.month;
    int date = day.day;

    // --- ÉVÉNEMENTS FIXES GÉNÉRAUX ---
    int offset = (year == 2028 || year == 2032 || year == 2036) ? 1 : 0;

// 1. Circoncision
    if (month == 1 && date == (14 + offset)) {
      if (FilterManager.isVisible("Circoncision")) return CopticEvent("Circoncision", Colors.brown);
    }

// 2. Miracle de Cana
    if (month == 1 && date == (21 + offset)) {
      if (FilterManager.isVisible("Miracle de Cana")) return CopticEvent("Miracle de Cana", Colors.brown);
    }

// 3. Fuite en Égypte
    if (month == 6 && date == 1 && !(year == 2031)) {
      if (FilterManager.isVisible("Fuite en Égypte")) return CopticEvent("Fuite en Égypte", Colors.brown);
    }

// 4. Jeûne et Fêtes de la Vierge / Transfiguration
    if (month == 8 && date >= 7 && date <= 21) {
      if (date == 19) {
        if (FilterManager.isVisible("Transfiguration")) return CopticEvent("Transfiguration", Colors.pink);
      } else {
        if (FilterManager.isVisible("Jeûne de la Vierge")) return CopticEvent("Jeûne de la Vierge", Colors.blue);
      }
    }
    if (month == 8 && date == 22) {
      if (FilterManager.isVisible("Fête de la Vierge")) return CopticEvent("Fête de la Vierge", Colors.green);
    }

// 5. Nouvel An et Sainte Croix (Septembre)
    if (month == 9) {
      int startDay = (year % 4 == 3) ? 12 : 11;

      // Nouvel An Copte
      if (date == startDay) {
        if (FilterManager.isVisible("Nouvel An Copte")) return CopticEvent("Nouvel An Copte", Colors.green);
      }

      // Sainte Croix de Septembre
      int croixStart = (startDay == 12) ? 28 : 27;
      if (date >= croixStart && date <= (croixStart + 2)) {
        if (FilterManager.isVisible("Ste Croix (Septembre)")) return CopticEvent("Fête de la Ste Croix", Colors.green);
      }
    }

// 6. Sainte Croix de Mars (À ajouter pour que le bouton Mars fonctionne)
    if (month == 3 && date == 19) {
      if (FilterManager.isVisible("Ste Croix (Mars)")) return CopticEvent("Fête de la Ste Croix", Colors.green);
    }

    // --- LOGIQUE PAR ANNÉE ---
    if (year == 2026) {
      if (month == 1 && date <= 5) return CopticEvent("Jeûne de la Nativité", Colors.blue);
      if (month == 1 && date == 6) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 7) return CopticEvent("Noël", Colors.pink);
      if (month == 1 && date >= 16 && date <= 18) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 19) return CopticEvent("Théophanie", Colors.pink);
      if (month == 2 && date >= 2 && date <= 4) return CopticEvent("Jeûne de Ninive", Colors.blue);
      if (month == 2 && date == 5) return CopticEvent("Fête de Jonas", Colors.green);
      if (month == 2 && date == 15) return CopticEvent("Entrée au Temple", Colors.brown);
      if ((month == 2 && date >= 16) || (month == 3) || (month == 4 && date <= 3)) {
        if (month == 3 && date == 19) return CopticEvent("Fête de la Ste Croix", Colors.green);
        return CopticEvent("Grand Carême", Colors.blue);
      }
      if (month == 4 && date >= 6 && date <= 11) {
        if (date == 7) return CopticEvent("Annonciation", Colors.pink);
        return CopticEvent("Semaine Sainte", Colors.lightBlueAccent);
      }
      if (month == 4 && date == 4) return CopticEvent("Samedi de Lazare", Colors.green);
      if (month == 4 && date == 5) return CopticEvent("Dimanche des Rameaux", Colors.pink);
      if (month == 4 && date == 12) return CopticEvent("Pâques", Colors.pink);
      if ((month == 4 && date >= 13) || (month == 5) || (month == 6 && date <= 1)) {
        if (month == 4 && date == 19) return CopticEvent("Dimanche de Thomas", Colors.brown);
        if (month == 5 && date == 21) return CopticEvent("Ascension", Colors.pink);
        if (month == 5 && date == 31) return CopticEvent("Pentecôte", Colors.pink);
        return CopticEvent("Cinquantaire", Colors.purple);
      }
      if ((month == 6 && date >= 2) || (month == 7 && date <= 11)) return CopticEvent("Jeûne des Apôtres", Colors.blue);
      if (month == 7 && date == 12) return CopticEvent("Fête des Apôtres", Colors.green);
      if (month == 11 && date >= 25 || month == 12) return CopticEvent("Jeûne de la Nativité", Colors.blue);
    }

    if (year == 2027) {
      if (month == 1 && date <= 6) return CopticEvent("Jeûne de la Nativité", Colors.blue);
      if (month == 1 && date == 6) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 7) return CopticEvent("Noël", Colors.pink);
      if (month == 1 && date == 18) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 19) return CopticEvent("Théophanie", Colors.pink);
      if (month == 2 && date == 15) return CopticEvent("Entrée au Temple", Colors.brown);
      if (month == 2 && date >= 22 && date <= 24) return CopticEvent("Jeûne de Ninive", Colors.blue);
      if (month == 2 && date == 25) return CopticEvent("Fête de Jonas", Colors.green);
      if ((month == 3 && date >= 8) || (month == 4 && date <= 23)) {
        if (month == 3 && date == 19) return CopticEvent("Fête de la Ste Croix", Colors.green);
        if (month == 4 && date == 7) return CopticEvent("Annonciation", Colors.pink);
        return CopticEvent("Grand Carême", Colors.blue);
      }
      if (month == 4 && date == 24) return CopticEvent("Samedi de Lazare", Colors.green);
      if (month == 4 && date == 25) return CopticEvent("Dimanche des Rameaux", Colors.pink);
      if (month == 4 && date >= 26 || (month == 5 && date == 1)) return CopticEvent("Semaine Sainte", Colors.lightBlueAccent);
      if (month == 5 && date == 2) return CopticEvent("Pâques", Colors.pink);
      if ((month == 5 && date >= 3) || (month == 6 && date <= 20)) {
        if (month == 5 && date == 9) return CopticEvent("Dimanche de Thomas", Colors.brown);
        if (month == 6 && date == 10) return CopticEvent("Ascension", Colors.pink);
        if (month == 6 && date == 20) return CopticEvent("Pentecôte", Colors.pink);
        return CopticEvent("Cinquantaire", Colors.purple);
      }
      if ((month == 6 && date >= 21) || (month == 7 && date <= 11)) return CopticEvent("Jeûne des Apôtres", Colors.blue);
      if (month == 7 && date == 12) return CopticEvent("Fête des Apôtres", Colors.green);
      if (month == 9 && date == 12) return CopticEvent("Nouvel An Copte", Colors.green);
      if (month == 9 && date >= 28 && date <= 30) return CopticEvent("Fête de la Ste Croix", Colors.green);
      if (month == 11 && date >= 26 || month == 12) return CopticEvent("Jeûne de la Nativité", Colors.blue);
    }

    if (year == 2028) {
      if (month == 1 && date <= 6) return CopticEvent("Jeûne de la Nativité", Colors.blue);
      if (month == 1 && date == 7) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 8) return CopticEvent("Noël", Colors.pink);
      if (month == 1 && date == 19) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 20) return CopticEvent("Théophanie", Colors.pink);
      if (month == 2 && date >= 7 && date <= 9) return CopticEvent("Jeûne de Ninive", Colors.blue);
      if (month == 2 && date == 10) return CopticEvent("Fête de Jonas", Colors.green);
      if (month == 2 && date == 16) return CopticEvent("Entrée au Temple", Colors.brown);
      if ((month == 2 && date >= 21) || month == 3 || (month == 4 && date <= 6)) {
        if (month == 3 && date == 19) return CopticEvent("Fête de la Ste Croix", Colors.green);
        return CopticEvent("Grand Carême", Colors.blue);
      }
      if (month == 4 && date == 7) return CopticEvent("Annonciation", Colors.pink);
      if (month == 4 && date == 8) return CopticEvent("Samedi de Lazare", Colors.green);
      if (month == 4 && date == 9) return CopticEvent("Dimanche des Rameaux", Colors.pink);
      if (month == 4 && date >= 10 && date <= 15) return CopticEvent("Semaine Sainte", Colors.lightBlueAccent);
      if (month == 4 && date == 16) return CopticEvent("Pâques", Colors.pink);
      if ((month == 4 && date >= 17) || month == 5 || (month == 6 && date <= 4)) {
        if (month == 4 && date == 23) return CopticEvent("Dimanche de Thomas", Colors.brown);
        if (month == 5 && date == 25) return CopticEvent("Ascension", Colors.pink);
        if (month == 6 && date == 4) return CopticEvent("Pentecôte", Colors.pink);
        return CopticEvent("Cinquantaire", Colors.purple);
      }
      if ((month == 6 && date >= 5) || (month == 7 && date <= 11)) return CopticEvent("Jeûne des Apôtres", Colors.blue);
      if (month == 7 && date == 12) return CopticEvent("Fête des Apôtres", Colors.green);
      if ((month == 11 && date >= 25) || month == 12) return CopticEvent("Jeûne de la Nativité", Colors.blue);
    }

    if (year == 2029) {
      if (month == 1 && date <= 4) return CopticEvent("Jeûne de la Nativité", Colors.blue);
      if (month == 1 && (date == 5 || date == 6)) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 7) return CopticEvent("Noël", Colors.pink);
      if (month == 1 && date == 18) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 19) return CopticEvent("Théophanie", Colors.pink);
      if (month == 1 && date >= 29 && date <= 31) return CopticEvent("Jeûne de Ninive", Colors.blue);
      if (month == 2 && date == 1) return CopticEvent("Fête de Jonas", Colors.green);
      if (month == 2 && date == 15) return CopticEvent("Entrée au Temple", Colors.brown);
      if ((month == 2 && date >= 12) || (month == 3 && date <= 30)) {
        if (month == 3 && date == 19) return CopticEvent("Fête de la Ste Croix", Colors.green);
        return CopticEvent("Grand Carême", Colors.blue);
      }
      if (month == 3 && date == 31) return CopticEvent("Samedi de Lazare", Colors.green);
      if (month == 4 && date == 1) return CopticEvent("Dimanche des Rameaux", Colors.pink);
      if (month == 4 && date >= 2 && date <= 6) return CopticEvent("Semaine Sainte", Colors.lightBlueAccent);
      if (month == 4 && date == 7) return CopticEvent("Annonciation", Colors.pink);
      if (month == 4 && date == 8) return CopticEvent("Pâques", Colors.pink);
      if ((month == 4 && date >= 9) || (month == 5 && date <= 26)) {
        if (month == 4 && date == 15) return CopticEvent("Dimanche de Thomas", Colors.brown);
        if (month == 5 && date == 17) return CopticEvent("Ascension", Colors.pink);
        return CopticEvent("Cinquantaire", Colors.purple);
      }
      if (month == 5 && date == 27) return CopticEvent("Pentecôte", Colors.pink);
      if ((month == 5 && date >= 28) || (month == 6) || (month == 7 && date <= 11)) return CopticEvent("Jeûne des Apôtres", Colors.blue);
      if (month == 7 && date == 12) return CopticEvent("Fête des Apôtres", Colors.green);
      if (month == 11 && date >= 25 || month == 12) return CopticEvent("Jeûne de la Nativité", Colors.blue);
    }

    if (year == 2030) {
      if (month == 1 && date <= 3) return CopticEvent("Jeûne de la Nativité", Colors.blue);
      if (month == 1 && date >= 4 && date <= 6) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 7) return CopticEvent("Noël", Colors.pink);
      if (month == 1 && date == 18) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 19) return CopticEvent("Théophanie", Colors.pink);
      if (month == 2 && date == 15) return CopticEvent("Entrée au Temple", Colors.brown);
      if (month == 2 && date >= 18 && date <= 20) return CopticEvent("Jeûne de Ninive", Colors.blue);
      if (month == 2 && date == 21) return CopticEvent("Fête de Jonas", Colors.green);
      if ((month == 3 && date >= 4) || (month == 4 && date <= 19)) {
        if (month == 3 && date == 19) return CopticEvent("Fête de la Ste Croix", Colors.green);
        if (month == 4 && date == 7) return CopticEvent("Annonciation", Colors.pink);
        return CopticEvent("Grand Carême", Colors.blue);
      }
      if (month == 4 && date == 20) return CopticEvent("Samedi de Lazare", Colors.green);
      if (month == 4 && date == 21) return CopticEvent("Dimanche des Rameaux", Colors.pink);
      if (month == 4 && date >= 22 && date <= 27) return CopticEvent("Semaine Sainte", Colors.lightBlueAccent);
      if (month == 4 && date == 28) return CopticEvent("Pâques", Colors.pink);
      if ((month == 4 && date >= 29) || (month == 5) || (month == 6 && date <= 16)) {
        if (month == 5 && date == 5) return CopticEvent("Dimanche de Thomas", Colors.brown);
        if (month == 6 && date == 6) return CopticEvent("Ascension", Colors.pink);
        if (month == 6 && date == 16) return CopticEvent("Pentecôte", Colors.pink);
        return CopticEvent("Cinquantaire", Colors.purple);
      }
      if ((month == 6 && date >= 17) || (month == 7 && date <= 11)) return CopticEvent("Jeûne des Apôtres", Colors.blue);
      if (month == 7 && date == 12) return CopticEvent("Fête des Apôtres", Colors.green);
      if (month == 11 && date >= 25 || month == 12) return CopticEvent("Jeûne de la Nativité", Colors.blue);
    }

    if (year == 2031) {
      if (month == 1 && date <= 5) return CopticEvent("Jeûne de la Nativité", Colors.blue);
      if (month == 1 && date == 6) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 7) return CopticEvent("Noël", Colors.pink);
      if (month == 1 && date == 14) return CopticEvent("Circoncision", Colors.brown);
      if (month == 1 && (date == 17 || date == 18)) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 19) return CopticEvent("Théophanie", Colors.pink);
      if (month == 1 && date == 21) return CopticEvent("Miracle de Cana", Colors.brown);
      if (month == 2 && date >= 3 && date <= 5) return CopticEvent("Jeûne de Ninive", Colors.blue);
      if (month == 2 && date == 6) return CopticEvent("Fête de Jonas", Colors.green);
      if (month == 2 && date == 15) return CopticEvent("Entrée au Temple", Colors.brown);
      if ((month == 2 && date >= 17) || month == 3 || (month == 4 && date <= 4)) {
        if (month == 3 && date == 19) return CopticEvent("Fête de la Ste Croix", Colors.green);
        return CopticEvent("Grand Carême", Colors.blue);
      }
      if (month == 4 && date == 5) return CopticEvent("Samedi de Lazare", Colors.green);
      if (month == 4 && date == 6) return CopticEvent("Dimanche des Rameaux", Colors.pink);
      if (month == 4 && date >= 7 && date <= 12) {
        if (date == 7) return CopticEvent("Annonciation", Colors.pink);
        return CopticEvent("Semaine Sainte", Colors.lightBlueAccent);
      }
      if (month == 4 && date == 13) return CopticEvent("Pâques", Colors.pink);
      if ((month == 4 && date >= 14) || month == 5 || (month == 6 && date == 1)) {
        if (month == 4 && date == 20) return CopticEvent("Dimanche de Thomas", Colors.brown);
        if (month == 5 && date == 22) return CopticEvent("Ascension", Colors.pink);
        if (month == 6 && date == 1) return CopticEvent("Pentecôte", Colors.pink);
        return CopticEvent("Cinquantaire", Colors.purple);
      }
      if ((month == 6 && date >= 2) || (month == 7 && date <= 11)) return CopticEvent("Jeûne des Apôtres", Colors.blue);
      if (month == 7 && date == 12) return CopticEvent("Fête des Apôtres", Colors.green);
      if (month == 9 && date == 12) return CopticEvent("Nouvel An Copte", Colors.green);
      if (month == 11 && date >= 26 || month == 12) return CopticEvent("Jeûne de la Nativité", Colors.blue);
    }

    if (year == 2032) {
      if (month == 1 && date <= 6) return CopticEvent("Jeûne de la Nativité", Colors.blue);
      if (month == 1 && date == 7) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 8) return CopticEvent("Noël", Colors.pink);
      if (month == 1 && date == 19) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 20) return CopticEvent("Théophanie", Colors.pink);
      if (month == 2 && date == 16) return CopticEvent("Entrée au Temple", Colors.brown);
      if (month == 2 && date >= 23 && date <= 25) return CopticEvent("Jeûne de Ninive", Colors.blue);
      if (month == 2 && date == 26) return CopticEvent("Fête de Jonas", Colors.green);
      if ((month == 3 && date >= 8) || (month == 4 && date <= 23)) {
        if (month == 3 && date == 19) return CopticEvent("Fête de la Ste Croix", Colors.green);
        if (month == 4 && date == 7) return CopticEvent("Annonciation", Colors.pink);
        return CopticEvent("Grand Carême", Colors.blue);
      }
      if (month == 4 && date == 24) return CopticEvent("Samedi de Lazare", Colors.green);
      if (month == 4 && date == 25) return CopticEvent("Dimanche des Rameaux", Colors.pink);
      if (month == 4 && date >= 26 || (month == 5 && date == 1)) return CopticEvent("Semaine Sainte", Colors.lightBlueAccent);
      if (month == 5 && date == 2) return CopticEvent("Pâques", Colors.pink);
      if ((month == 5 && date >= 3) || (month == 6 && date <= 19)) {
        if (month == 5 && date == 9) return CopticEvent("Dimanche de Thomas", Colors.brown);
        if (month == 6 && date == 10) return CopticEvent("Ascension", Colors.pink);
        return CopticEvent("Cinquantaire", Colors.purple);
      }
      if (month == 6 && date == 20) return CopticEvent("Pentecôte", Colors.pink);
      if ((month == 6 && date >= 21) || (month == 7 && date <= 11)) return CopticEvent("Jeûne des Apôtres", Colors.blue);
      if (month == 7 && date == 12) return CopticEvent("Fête des Apôtres", Colors.green);
      if (month == 11 && date >= 25 || month == 12) return CopticEvent("Jeûne de la Nativité", Colors.blue);
    }

    if (year == 2033) {
      if (month == 1 && date <= 5) return CopticEvent("Jeûne de la Nativité", Colors.blue);
      if (month == 1 && date == 6) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 7) return CopticEvent("Noël", Colors.pink);
      if (month == 1 && date == 18) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 19) return CopticEvent("Théophanie", Colors.pink);
      if (month == 2 && date >= 14 && date <= 16) {
        if (date == 15) return CopticEvent("Entrée au Temple", Colors.brown);
        return CopticEvent("Jeûne de Ninive", Colors.blue);
      }
      if (month == 2 && date == 17) return CopticEvent("Fête de Jonas", Colors.green);
      if ((month == 2 && date >= 28) || month == 3 || (month == 4 && date <= 15)) {
        if (month == 3 && date == 19) return CopticEvent("Fête de la Ste Croix", Colors.green);
        if (month == 4 && date == 7) return CopticEvent("Annonciation", Colors.pink);
        return CopticEvent("Grand Carême", Colors.blue);
      }
      if (month == 4 && date == 16) return CopticEvent("Samedi de Lazare", Colors.green);
      if (month == 4 && date == 17) return CopticEvent("Dimanche des Rameaux", Colors.pink);
      if (month == 4 && date >= 18 && date <= 23) return CopticEvent("Semaine Sainte", Colors.lightBlueAccent);
      if (month == 4 && date == 24) return CopticEvent("Pâques", Colors.pink);
      if ((month == 4 && date >= 25) || month == 5 || (month == 6 && date <= 11)) {
        if (month == 5 && date == 1) return CopticEvent("Dimanche de Thomas", Colors.brown);
        if (month == 6 && date == 2) return CopticEvent("Ascension", Colors.pink);
        return CopticEvent("Cinquantaire", Colors.purple);
      }
      if (month == 6 && date == 12) return CopticEvent("Pentecôte", Colors.pink);
      if ((month == 6 && date >= 13) || (month == 7 && date <= 11)) return CopticEvent("Jeûne des Apôtres", Colors.blue);
      if (month == 7 && date == 12) return CopticEvent("Fête des Apôtres", Colors.green);
      if (month == 11 && date >= 25 || month == 12) return CopticEvent("Jeûne de la Nativité", Colors.blue);
    }

    if (year == 2034) {
      if (month == 1 && date <= 5) return CopticEvent("Jeûne de la Nativité", Colors.blue);
      if (month == 1 && date == 6) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 7) return CopticEvent("Noël", Colors.pink);
      if (month == 1 && date == 18) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 19) return CopticEvent("Théophanie", Colors.pink);
      if ((month == 1 && date >= 30) || (month == 2 && date == 1)) return CopticEvent("Jeûne de Ninive", Colors.blue);
      if (month == 2 && date == 2) return CopticEvent("Fête de Jonas", Colors.green);
      if (month == 2 && date == 15) return CopticEvent("Entrée au Temple", Colors.brown);
      if ((month == 2 && date >= 13) || month == 3) {
        if (month == 3 && date == 19) return CopticEvent("Fête de la Ste Croix", Colors.green);
        return CopticEvent("Grand Carême", Colors.blue);
      }
      if (month == 4 && date == 1) return CopticEvent("Samedi de Lazare", Colors.green);
      if (month == 4 && date == 2) return CopticEvent("Dimanche des Rameaux", Colors.pink);
      if (month == 4 && date >= 3 && date <= 8) {
        if (date == 7) return CopticEvent("Annonciation", Colors.pink);
        return CopticEvent("Semaine Sainte", Colors.lightBlueAccent);
      }
      if (month == 4 && date == 9) return CopticEvent("Pâques", Colors.pink);
      if ((month == 4 && date >= 10) || (month == 5 && date <= 27)) {
        if (month == 4 && date == 16) return CopticEvent("Dimanche de Thomas", Colors.brown);
        if (month == 5 && date == 18) return CopticEvent("Ascension", Colors.pink);
        return CopticEvent("Cinquantaire", Colors.purple);
      }
      if (month == 5 && date == 28) return CopticEvent("Pentecôte", Colors.pink);
      if ((month == 5 && date >= 29) || (month == 6) || (month == 7 && date <= 11)) return CopticEvent("Jeûne des Apôtres", Colors.blue);
      if (month == 7 && date == 12) return CopticEvent("Fête des Apôtres", Colors.green);
      if (month == 11 && date >= 25 || month == 12) return CopticEvent("Jeûne de la Nativité", Colors.blue);
    }

    if (year == 2035) {
      if (month == 1 && date <= 4) return CopticEvent("Jeûne de la Nativité", Colors.blue);
      if (month == 1 && (date == 5 || date == 6)) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 7) return CopticEvent("Noël", Colors.pink);
      if (month == 1 && date == 14) return CopticEvent("Circoncision", Colors.brown);
      if (month == 1 && date == 18) return CopticEvent("Paramoun", Colors.orange);
      if (month == 1 && date == 19) return CopticEvent("Théophanie", Colors.pink);
      if (month == 1 && date == 21) return CopticEvent("Miracle de Cana", Colors.brown);
      if (month == 2 && date == 15) return CopticEvent("Entrée au Temple", Colors.brown);
      if (month == 2 && date >= 19 && date <= 21) return CopticEvent("Jeûne de Ninive", Colors.blue);
      if (month == 2 && date == 22) return CopticEvent("Fête de Jonas", Colors.green);
      if ((month == 3 && date >= 5) || (month == 4 && date <= 20)) {
        if (month == 3 && date == 19) return CopticEvent("Fête de la Ste Croix", Colors.green);
        if (month == 4 && date == 7) return CopticEvent("Annonciation", Colors.pink);
        return CopticEvent("Grand Carême", Colors.blue);
      }
      if (month == 4 && date == 21) return CopticEvent("Samedi de Lazare", Colors.green);
      if (month == 4 && date == 22) return CopticEvent("Dimanche des Rameaux", Colors.pink);
      if (month == 4 && date >= 23 && date <= 28) return CopticEvent("Semaine Sainte", Colors.lightBlueAccent);
      if (month == 4 && date == 29) return CopticEvent("Pâques", Colors.pink);
      if ((month == 4 && date == 30) || month == 5 || (month == 6 && date <= 17)) {
        if (month == 5 && date == 6) return CopticEvent("Dimanche de Thomas", Colors.brown);
        if (month == 6 && date == 7) return CopticEvent("Ascension", Colors.pink);
        if (month == 6 && date == 17) return CopticEvent("Pentecôte", Colors.pink);
        return CopticEvent("Cinquantaire", Colors.purple);
      }
      if ((month == 6 && date >= 18) || (month == 7 && date <= 11)) return CopticEvent("Jeûne des Apôtres", Colors.blue);
      if (month == 7 && date == 12) return CopticEvent("Fête des Apôtres", Colors.green);
      if (month == 9 && date == 12) return CopticEvent("Nouvel An Copte", Colors.green);
      if (month == 9 && date >= 28 && date <= 30) return CopticEvent("Fête de la Ste Croix", Colors.green);
      if (month == 11 && date >= 26 || month == 12) return CopticEvent("Jeûne de la Nativité", Colors.blue);
    }

    return null;
  }
}

// ==========================================
// POINT D'ENTRÉE
// ==========================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const CoptiCalApp());
}

class CoptiCalApp extends StatelessWidget {
  const CoptiCalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('fr', 'FR'),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF8E2424),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// ==========================================
// NAVIGATION PRINCIPALE ET LOGIQUE ÉCRAN
// ==========================================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Correction de la gestion d'index pour éviter les boucles infinies
  int _selectedIndex = 0;
  final List<int> _history = [0];

  final List<String> _titles = ["Calendrier", "Fêtes", "Jeûnes", "Le saviez-vous ?", "Paramètres"];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  final List<int> _filterYears = [2026, 2027, 2028, 2029, 2030, 2031, 2032, 2033, 2034, 2035];

  // LOGIQUE DE NAVIGATION CORRIGÉE
  void _onSelectItem(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        _history.add(index);
      });
    }
    // Ferme le tiroir (Drawer) s'il est ouvert
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Permet de gérer le bouton "Retour" du téléphone sans quitter l'app directement
  Future<bool> _onWillPop() async {
    if (_history.length > 1) {
      setState(() {
        _history.removeLast();
        _selectedIndex = _history.last;
      });
      return false; // Ne ferme pas l'app
    }
    return true; // Ferme l'app si on est au début
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return PopScope(
      canPop: _history.length <= 1,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onWillPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selectedIndex], style: const TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: const Color(0xFF121212),
          elevation: 0,
          actions: _selectedIndex == 0 ? [
            IconButton(
              icon: const Icon(Icons.today, color: Color(0xFFD4AF37)),
              onPressed: () => setState(() { _focusedDay = DateTime.now(); _selectedDay = DateTime.now(); }),
            ),
            PopupMenuButton<int>(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onSelected: (year) => setState(() => _focusedDay = DateTime(year, _focusedDay.month, 1)),
              itemBuilder: (context) => _filterYears.map((y) => PopupMenuItem(value: y, child: Text("Année $y"))).toList(),
            ),
          ] : [],
        ),
        drawer: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: _buildModernDrawer(isLandscape)
        ),
        body: _buildBody(isLandscape),
      ),
    );
  }

  Widget _buildBody(bool isLandscape) {
    switch (_selectedIndex) {
      case 0: return _buildCalendarHome(isLandscape);
      case 1: return const FeastsScreen();
      case 2: return const FastsScreen();
      case 3: return const DidYouKnowScreen();
      case 4: return const SettingsScreen();
      default: return _buildCalendarHome(isLandscape);
    }
  }

  // --- ÉCRAN CALENDRIER PRINCIPAL ---
  Widget _buildCalendarHome(bool isLandscape) {
    final event = CopticData.getEventForDay(_selectedDay ?? _focusedDay);
    final displayEvent = (event != null && FilterManager.isVisible(event.name))
        ? event
        : CopticEvent("Jour ordinaire", Colors.grey);

    if (isLandscape) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFF161616), borderRadius: BorderRadius.circular(20)),
                child: _buildTableCalendar(isLandscape),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              child: Column(
                children: [
                  _buildEventDetailCard(displayEvent),
                  _buildSectionTitle("LÉGENDE DES ÉVÉNEMENTS"),
                  Expanded(child: _buildPostItLegend(isLandscape)),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF161616), borderRadius: BorderRadius.circular(20)),
            child: _buildTableCalendar(isLandscape)
        ),
        _buildEventDetailCard(displayEvent),
        _buildSectionTitle("LÉGENDE DES ÉVÉNEMENTS"),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 15),
            child: _buildPostItLegend(isLandscape),
          ),
        ),
      ],
    );
  }

  // --- WIDGET TABLE CALENDAR ---
  Widget _buildTableCalendar(bool isLandscape) {
    return TableCalendar(
      locale: 'fr_FR',
      firstDay: DateTime.utc(2026, 1, 1),
      lastDay: DateTime.utc(2035, 12, 31),
      focusedDay: _focusedDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      rowHeight: isLandscape ? 32 : 45,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: const TextStyle(color: Colors.white),
        weekendTextStyle: const TextStyle(color: Colors.white70),
        selectedDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD4AF37), width: 2),
        ),
        selectedTextStyle: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        todayDecoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
      ),
      headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)
      ),
      onDaySelected: (selected, focused) => setState(() { _selectedDay = selected; _focusedDay = focused; }),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final event = CopticData.getEventForDay(day);
          if (event != null && FilterManager.isVisible(event.name)) {
            return Center(
                child: Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(color: event.color, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text('${day.day}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))
                )
            );
          }
          return null;
        },
      ),
    );
  }

  // --- CARTE DÉTAIL ÉVÉNEMENT ---
  Widget _buildEventDetailCard(CopticEvent event) {
    bool isOrdinary = event.name == "Jour ordinaire";
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: event.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: event.color.withOpacity(0.5))
      ),
      child: Row(children: [
        Icon(isOrdinary ? Icons.calendar_today : Icons.auto_awesome, color: event.color, size: 22),
        const SizedBox(width: 12),
        Expanded(child: Text(event.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white))),
      ]),
    );
  }

  // --- LÉGENDE POST-IT ---
  Widget _buildPostItLegend(bool isLandscape) {
    final List<Map<String, dynamic>> items = [
      {"color": Colors.pink, "label": "GRANDE FÊTE"},
      {"color": Colors.brown, "label": "PETITE FÊTE"},
      {"color": Colors.blue, "label": "JEÛNE"},
      {"color": Colors.lightBlueAccent, "label": "SEMAINE SAINTE"},
      {"color": Colors.green, "label": "AUTRE FÊTE"},
      {"color": Colors.orange, "label": "PARAMOUN"},
      {"color": Colors.purple, "label": "CINQUANTAIRE"},
      {"color": Colors.grey, "label": "JOUR ORDINAIRE"},
    ];

    double borderRadiusValue = FilterManager.postItStyle == 'Moderne' ? 25.0 : 5.0;
    BoxBorder? borderStyle = FilterManager.postItStyle == 'Bordure Or'
        ? Border.all(color: const Color(0xFFD4AF37), width: 2)
        : Border(left: BorderSide(color: const Color(0xFFD4AF37), width: FilterManager.postItStyle == 'Minimaliste' ? 8 : 4));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FilterManager.postItColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadiusValue),
          topRight: Radius.circular(borderRadiusValue),
          bottomLeft: Radius.circular(borderRadiusValue),
          bottomRight: Radius.circular(FilterManager.postItStyle == 'Minimaliste' ? borderRadiusValue : 40),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(4, 4)
          )
        ],
        border: borderStyle,
      ),
      child: Stack(
        children: [
          if (FilterManager.postItStyle == 'Classique' || FilterManager.postItStyle == 'Papier')
            Positioned(
              right: 0, bottom: 0,
              child: Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate((items.length / 2).ceil(), (index) {
                return Row(
                  children: [
                    Expanded(child: _buildLegendCell(items[index * 2], isLandscape)),
                    if (index * 2 + 1 < items.length)
                      Expanded(child: _buildLegendCell(items[index * 2 + 1], isLandscape))
                    else
                      const Expanded(child: SizedBox.shrink()),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendCell(Map<String, dynamic> item, bool isLandscape) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isLandscape ? 2.0 : 6.0),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: item["color"], shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(item["label"],
                style: TextStyle(fontSize: isLandscape ? 10 : 12, color: Colors.white, fontWeight: FontWeight.w900, overflow: TextOverflow.ellipsis)
            ),
          ),
        ],
      ),
    );
  }

  // --- NAVIGATION (DRAWER) ---
  Widget _buildModernDrawer(bool isLandscape) {
    return Drawer(
      backgroundColor: const Color(0xFF0F0F0F),
      child: Column(children: [
        _buildDrawerHeader(isLandscape),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _drawerItem(0, Icons.calendar_today_rounded, "Calendrier", isLandscape),
              _drawerItem(1, Icons.auto_awesome_rounded, "Fêtes", isLandscape),
              _drawerItem(2, Icons.hourglass_top_rounded, "Jeûnes", isLandscape),
              _drawerItem(3, Icons.lightbulb_outline_rounded, "Le saviez-vous ?", isLandscape),
              const Divider(color: Colors.white10, indent: 20, endIndent: 20),
              _drawerItem(4, Icons.settings_rounded, "Paramètres", isLandscape),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildDrawerHeader(bool isLandscape) {
    return Container(
      height: isLandscape ? 110 : 170,
      width: double.infinity,
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF8E2424), Color(0xFF3A0808)])),
      child: Stack(
        children: [
          Positioned(right: -10, bottom: -10, child: Opacity(opacity: 0.1, child: Icon(Icons.church, size: isLandscape ? 70 : 110, color: Colors.white))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD4AF37), width: 1.5)),
                    child: const Icon(Icons.church, color: Color(0xFFD4AF37), size: 20),
                  ),
                  const SizedBox(height: 10),
                  const Text("CoptiCal", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (!isLandscape) const Text("Calendrier Orthodoxe", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(int index, IconData icon, String title, bool isLandscape) {
    bool isSelected = _selectedIndex == index;
    return ListTile(
      dense: isLandscape,
      leading: Icon(icon, color: isSelected ? const Color(0xFFD4AF37) : Colors.white60),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white60, fontSize: 14)),
      onTap: () => _onSelectItem(index),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
        child: Align(alignment: Alignment.centerLeft, child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))))
    );
  }
}