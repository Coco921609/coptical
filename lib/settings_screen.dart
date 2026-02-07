import 'package:flutter/material.dart';
import 'main.dart'; // Accès au FilterManager

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> _effectsList = [
    'Par défaut', 'Perspective', 'Compressé', 'Boite',
    'Retourner', 'Rotation', 'Page', 'Moulin à vent'
  ];

  // --- LOGIQUE DE RÉCUPÉRATION ---
  String _getFontSizeLabel(String key) {
    double size = FilterManager.fontSizes[key] ?? 18.0;
    return size == 18.0 ? "Par défaut" : "${size.toInt()} px";
  }

  String _getEffectLabel(String key) {
    return FilterManager.effects[key] ?? 'Par défaut';
  }

  // --- RÉINITIALISATION GLOBALE ---
  void _resetAllCustomization() {
    setState(() {
      ['Saviez-vous ?', 'Fêtes', 'Jeûnes'].forEach((key) {
        FilterManager.fontSizes[key] = 18.0;
        FilterManager.effects[key] = 'Par défaut';
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Réglages réinitialisés"),
        backgroundColor: Color(0xFFD4AF37),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // --- DIALOGUE TAILLE DE POLICE ---
  void _showFontSizeDialog(int initialIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161616),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DefaultTabController(
          length: 3,
          initialIndex: initialIndex,
          child: StatefulBuilder(builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Taille du texte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  const TabBar(
                    isScrollable: true,
                    indicatorColor: Color(0xFFD4AF37),
                    labelColor: Color(0xFFD4AF37),
                    unselectedLabelColor: Colors.white24,
                    tabs: [
                      Tab(child: Text("SAVIEZ-VOUS ?", style: TextStyle(fontSize: 11))),
                      Tab(child: Text("FÊTES", style: TextStyle(fontSize: 11))),
                      Tab(child: Text("JEÛNES", style: TextStyle(fontSize: 11))),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 120,
                    child: TabBarView(
                      children: [
                        _buildFontSlider("Saviez-vous ?", Colors.orange, setModalState),
                        _buildFontSlider("Fêtes", Colors.pink, setModalState),
                        _buildFontSlider("Jeûnes", Colors.blue, setModalState),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildFontSlider(String key, Color color, Function setModalState) {
    double fontSize = FilterManager.fontSizes[key] ?? 18.0;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Aperçu", style: TextStyle(color: Colors.white, fontSize: fontSize)),
            Text("${fontSize.toInt()} px", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: fontSize,
          min: 14.0, max: 35.0,
          activeColor: color,
          onChanged: (val) {
            setModalState(() => FilterManager.fontSizes[key] = val);
            setState(() {});
          },
        ),
      ],
    );
  }

  // --- DIALOGUE EFFETS (ADAPTATIF) ---
  void _showEffectDialog(int initialIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161616),
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DefaultTabController(
          length: 3,
          initialIndex: initialIndex,
          child: StatefulBuilder(builder: (context, setModalState) {
            bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
            return Container(
              padding: const EdgeInsets.only(top: 15),
              height: MediaQuery.of(context).size.height * (isLandscape ? 0.95 : 0.75),
              child: Column(
                children: [
                  const Text("Effet de transition", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  const TabBar(
                    isScrollable: true,
                    indicatorColor: Color(0xFFD4AF37),
                    labelColor: Color(0xFFD4AF37),
                    unselectedLabelColor: Colors.white24,
                    tabs: [
                      Tab(child: Text("SAVIEZ-VOUS ?", style: TextStyle(fontSize: 11))),
                      Tab(child: Text("FÊTES", style: TextStyle(fontSize: 11))),
                      Tab(child: Text("JEÛNES", style: TextStyle(fontSize: 11))),
                    ],
                  ),
                  Expanded(
                    child: isLandscape
                        ? Row(children: [
                      Expanded(child: Center(child: _buildPreviewZone(context))),
                      Expanded(flex: 2, child: _buildEffectGridContainer(setModalState)),
                    ])
                        : Column(children: [
                      const SizedBox(height: 20),
                      _buildPreviewZone(context),
                      Expanded(child: _buildEffectGridContainer(setModalState)),
                    ]),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildPreviewZone(BuildContext context) {
    final index = DefaultTabController.of(context).index;
    final keys = ['Saviez-vous ?', 'Fêtes', 'Jeûnes'];
    final currentEffect = FilterManager.effects[keys[index]] ?? 'Par défaut';
    return Container(
      height: 100, width: 140,
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
      child: Center(child: _buildAnimatedPreview(currentEffect)),
    );
  }

  Widget _buildEffectGridContainer(Function setModalState) {
    return TabBarView(
      children: [
        _buildEffectGrid("Saviez-vous ?", setModalState),
        _buildEffectGrid("Fêtes", setModalState),
        _buildEffectGrid("Jeûnes", setModalState),
      ],
    );
  }

  Widget _buildAnimatedPreview(String effect) {
    return TweenAnimationBuilder(
      key: ValueKey(effect),
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, double value, child) {
        double rotY = 0; double rotZ = 0; double scale = 1.0;
        if (effect == 'Rotation') rotZ = value * 6.28;
        if (effect == 'Compressé') scale = 1.0 - (value * 0.4);
        if (effect == 'Perspective') rotY = value * 0.8;
        if (effect == 'Moulin à vent') rotZ = value * 3.14;
        if (effect == 'Retourner') rotY = value * 3.14;
        if (effect == 'Boite') scale = 0.6 + (value * 0.4);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..setEntry(3, 2, 0.002)..rotateY(rotY)..rotateZ(rotZ)..scale(scale),
          child: Container(
            width: 60, height: 40,
            decoration: BoxDecoration(color: const Color(0xFFD4AF37), borderRadius: BorderRadius.circular(6), boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)]),
            child: const Icon(Icons.auto_stories, color: Colors.black, size: 20),
          ),
        );
      },
    );
  }

  Widget _buildEffectGrid(String key, Function setModalState) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemCount: _effectsList.length,
      itemBuilder: (context, index) {
        final effect = _effectsList[index];
        final isSelected = (FilterManager.effects[key] ?? 'Par défaut') == effect;
        return GestureDetector(
          onTap: () { setModalState(() => FilterManager.effects[key] = effect); setState(() {}); },
          child: Container(
            decoration: BoxDecoration(color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_getEffectIcon(effect), color: isSelected ? Colors.black : Colors.white54, size: 18),
                Text(effect, style: TextStyle(color: isSelected ? Colors.black : Colors.white54, fontSize: 7), textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getEffectIcon(String effect) {
    switch (effect) {
      case 'Perspective': return Icons.flip_to_back;
      case 'Compressé': return Icons.zoom_in_map;
      case 'Boite': return Icons.view_in_ar;
      case 'Retourner': return Icons.refresh;
      case 'Rotation': return Icons.rotate_right;
      case 'Page': return Icons.menu_book;
      case 'Moulin à vent': return Icons.toys;
      default: return Icons.view_carousel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle("Application"),
          _buildInfoCard("Version", "1.1.0"),
          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle("Personnalisation"),
              TextButton.icon(
                onPressed: _resetAllCustomization,
                icon: const Icon(Icons.restore, color: Colors.white38, size: 12),
                label: const Text("RÉINIT.", style: TextStyle(color: Colors.white38, fontSize: 9)),
              )
            ],
          ),

          // --- SECTION TAILLES ---
          _buildSubCategoryLabel("TAILLES DU TEXTE"),
          _buildClickableSetting(Icons.format_size, "Saviez-vous ?", _getFontSizeLabel("Saviez-vous ?"), () => _showFontSizeDialog(0)),
          _buildSpacing(),
          _buildClickableSetting(Icons.format_size, "Fêtes", _getFontSizeLabel("Fêtes"), () => _showFontSizeDialog(1)),
          _buildSpacing(),
          _buildClickableSetting(Icons.format_size, "Jeûnes", _getFontSizeLabel("Jeûnes"), () => _showFontSizeDialog(2)),

          const SizedBox(height: 20),

          // --- SECTION EFFETS ---
          _buildSubCategoryLabel("EFFETS DE TRANSITION"),
          _buildClickableSetting(Icons.auto_awesome_motion, "Saviez-vous ?", _getEffectLabel("Saviez-vous ?"), () => _showEffectDialog(0)),
          _buildSpacing(),
          _buildClickableSetting(Icons.auto_awesome_motion, "Fêtes", _getEffectLabel("Fêtes"), () => _showEffectDialog(1)),
          _buildSpacing(),
          _buildClickableSetting(Icons.auto_awesome_motion, "Jeûnes", _getEffectLabel("Jeûnes"), () => _showEffectDialog(2)),

          const SizedBox(height: 30),

          _buildSectionTitle("Filtres du calendrier"),

          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              "Activez ou désactivez les catégories pour personnaliser l'affichage de votre calendrier.",
              style: TextStyle(color: Colors.white38, fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ),

          _buildCategoryGroup("GRANDES FÊTES", Colors.pink, ["Noël", "Théophanie", "Annonciation", "Dimanche des Rameaux", "Pâques", "Ascension", "Pentecôte", "Transfiguration"]),
          _buildCategoryGroup("PETITES FÊTES", Colors.brown, ["Circoncision", "Miracle de Cana", "Entrée au Temple", "Dimanche de Thomas", "Fuite en Égypte"]),
          _buildCategoryGroup("PARAMOUN", Colors.orange, ["Paramoun"]),
          _buildCategoryGroup("JEÛNES", Colors.blue, ["Jeûne de la Nativité", "Jeûne de Ninive", "Grand Carême", "Jeûne des Apôtres", "Jeûne de la Vierge"]),
          _buildCategoryGroup("AUTRES FÊTES", Colors.green, ["Nouvel An Copte", "Fête de la Ste Croix", "Fête de Jonas", "Samedi de Lazare", "Fête des Apôtres", "Fête de la Vierge"]),
          _buildCategoryGroup("SEMAINE SAINTE", Colors.lightBlueAccent, ["Semaine Sainte"]),
          _buildCategoryGroup("CINQUANTAIRE", Colors.purple, ["Cinquantaire"]),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildSpacing() => const SizedBox(height: 8);

  Widget _buildSectionTitle(String title) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(title.toUpperCase(), style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.5)));
  }

  Widget _buildSubCategoryLabel(String title) {
    return Padding(padding: const EdgeInsets.only(left: 5, bottom: 8, top: 5), child: Text(title, style: const TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.2)));
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF161616), borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(color: Colors.white70)), Text(value, style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold))]));
  }

  Widget _buildClickableSetting(IconData icon, String title, String value, VoidCallback onTap) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF161616), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)), child: Row(children: [Icon(icon, color: Colors.white54, size: 20), const SizedBox(width: 15), Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14))), Text(value, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.bold)), const Icon(Icons.chevron_right, color: Colors.white24, size: 16)])));
  }

  Widget _buildCategoryGroup(String title, Color color, List<String> events) {
    bool isAnyEnabled = events.any((name) => FilterManager.isVisible(name));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        GestureDetector(onTap: () => setState(() { for (var e in events) isAnyEnabled ? FilterManager.disabledEvents.add(e) : FilterManager.disabledEvents.remove(e); }), child: Text(isAnyEnabled ? "MASQUER TOUT" : "AFFICHER TOUT", style: TextStyle(color: color.withOpacity(0.5), fontSize: 9))),
      ]),
      const SizedBox(height: 8),
      ...events.map((e) => _buildEventSwitch(e, color)).toList(),
    ]);
  }

  Widget _buildEventSwitch(String name, Color color) {
    bool isEnabled = FilterManager.isVisible(name);
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(color: const Color(0xFF161616), borderRadius: BorderRadius.circular(10)),
      child: SwitchListTile(dense: true, title: Text(name, style: const TextStyle(color: Colors.white, fontSize: 13)), secondary: Icon(Icons.circle, color: color, size: 8), activeColor: color, value: isEnabled, onChanged: (val) => setState(() { if (val) FilterManager.disabledEvents.remove(name); else FilterManager.disabledEvents.add(name); })),
    );
  }
}