import 'package:flutter/material.dart';
import 'main.dart'; // Pour FilterManager

class FastItem {
  final String name;
  final String content;
  final Color color;

  FastItem({
    required this.name,
    required this.content,
    required this.color,
  });
}

class FastsScreen extends StatefulWidget {
  const FastsScreen({super.key});

  @override
  State<FastsScreen> createState() => _FastsScreenState();
}

class _FastsScreenState extends State<FastsScreen> {
  late PageController _pageController;
  double _currentPageValue = 0.0;
  bool _isMenuOpen = false;
  final int _loopFactor = 10000;

  final List<FastItem> _allFasts = [
    FastItem(
      name: "Jeûne de l'Avent",
      color: Colors.blueAccent,
      content: "Le jeûne de l'avent dure 43 jours. Il nous prépare à accueillir la naissance du Christ dans notre cœur.\n\nEn fait, ce jeûne dure 40 jours auxquels nous avons ajouté 3 jours en commémoration du jeûne réalisé par les fidèles coptes. C'est, en effet, sous le règne d'El Moëz, que ces fidèles jeûnèrent trois jours dans le but de déplacer la montagne d'El Muquattam.",
    ),
    FastItem(
      name: "Jeûne de Jonas",
      color: Colors.orangeAccent,
      content: "Ce jeûne dure trois jours et débute deux semaines avant le grand carême. Il se réfère au jeûne que Jonas réalisa quand il était à l'intérieur du ventre de la baleine.\n\nNous lisons dans le livre de Jonas que tout le peuple de Ninive jeûna aussi, hommes, femmes, enfants et mêmes les animaux, afin que Dieu pardonne leurs péchés et ne les punisse pas. Prenons donc exemple sur le peuple de Ninive et jeûnons avec ferveur pour que Dieu aie pitié de nous.",
    ),
    FastItem(
      name: "Grand Carême",
      color: Colors.purpleAccent,
      content: "Le Grand carême est composé d'une semaine de préparation, suivie de quarante jours de jeûne, relatifs à ceux effectués par notre Seigneur Jésus-Christ à la montagne, puis de la semaine Sainte.\n\nCe jeûne a deux objectifs. Le premier est de nous préparer à recevoir avec joie l'annonce de Sa résurrection. Le second est de préparer les catéchumènes, traditionnellement baptisés la veille de Pâques. C'est le jeûne le plus important de l'église puisqu'il a été réalisé par le Christ Jésus Lui-même.",
    ),
    FastItem(
      name: "Jeûne des Apôtres",
      color: Colors.lightGreen,
      content: "Il commence le lendemain de la Pentecôte et se poursuit jusqu'à la fête commémorant les martyrs de Saint Pierre et de Saint Paul.\n\nLe but de ce jeûne est de remplir l'âme de ferveur et de zèle afin de prêcher la Parole de Dieu avec une pensée et une intention droite et apostolique.\n\nAllez, faites de toutes les nations des disciples, les baptisant au nom du Père, du Fils et du Saint-Esprit. (Matthieu 28 : 19)",
    ),
    FastItem(
      name: "Jeûne de la Vierge Marie",
      color: Colors.lightBlue,
      content: "Le jeûne de la Vierge Marie dure deux semaines, il précède la fête de la Sainte Vierge. C'est un jeûne très populaire en Egypte qui est même pratiqué par certains musulmans.\n\nIl est accompagné de chants et de louanges dédiés à la Vierge, ainsi que de processions. C'est l'occasion pour nous de dire avec le sainte Vierge :\n\nMarie dit : Je suis la servante du Seigneur ; qu'il me soit fait selon ta parole ! (Luc 1 : 38).",
    ),
  ];

  @override
  void initState() {
    super.initState();
    int initialPage = _allFasts.length * (_loopFactor ~/ 2);
    _pageController = PageController(initialPage: initialPage);
    _currentPageValue = initialPage.toDouble();
    _pageController.addListener(() => setState(() => _currentPageValue = _pageController.page!));
  }

  void _goToPage(int realIndex) {
    int currentPage = _pageController.page!.round();
    int currentRealIndex = currentPage % _allFasts.length;
    int offset = realIndex - currentRealIndex;
    _pageController.animateToPage(currentPage + offset, duration: const Duration(milliseconds: 600), curve: Curves.decelerate);
    setState(() => _isMenuOpen = false);
  }

  // --- NOUVELLE FONCTION POUR LES EFFETS ---
  Matrix4 _applyEffect(int index, String effect) {
    Matrix4 matrix = Matrix4.identity();
    double diff = _currentPageValue - index;

    switch (effect) {
      case 'Perspective':
        matrix.setEntry(3, 2, 0.001);
        matrix.rotateY(diff * 0.4);
        break;
      case 'Compressé':
        double scale = 1.0 - (diff.abs() * 0.3);
        matrix.scale(scale, scale);
        break;
      case 'Boite':
        matrix.setEntry(3, 2, 0.001);
        matrix.rotateY(diff * 1.5);
        break;
      case 'Retourner':
        matrix.setEntry(3, 2, 0.001);
        matrix.rotateY(diff * 3.14);
        break;
      case 'Rotation':
        matrix.rotateZ(diff * 0.5);
        break;
      case 'Moulin à vent':
        matrix.rotateZ(diff * 2);
        matrix.scale(1.0 - diff.abs().clamp(0.0, 0.5));
        break;
      case 'Page':
        matrix.translate(diff * 100);
        break;
      default: // Par défaut (ton effet original)
        matrix.setEntry(3, 2, 0.001);
        matrix.rotateY(diff * 0.5);
    }
    return matrix;
  }

  @override
  Widget build(BuildContext context) {
    // Lecture de l'effet dans FilterManager
    String currentEffect = FilterManager.effects['Jeûnes'] ?? 'Par défaut';

    return GestureDetector(
      onTap: () {
        if (_isMenuOpen) setState(() => _isMenuOpen = false);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4ECD8),
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                final realIndex = index % _allFasts.length;

                return Transform(
                  // Utilisation de la nouvelle fonction d'effet
                  transform: _applyEffect(index, currentEffect),
                  alignment: Alignment.center,
                  child: _buildBookPage(realIndex),
                );
              },
            ),

            Positioned(
              top: 10,
              right: 10,
              child: SafeArea(
                child: IconButton(
                  icon: Icon(_isMenuOpen ? Icons.close : Icons.auto_stories,
                      color: const Color(0xFFD4AF37), size: 28),
                  onPressed: () {
                    setState(() => _isMenuOpen = !_isMenuOpen);
                  },
                ),
              ),
            ),

            if (_isMenuOpen) _buildTableOfContents(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookPage(int realIndex) {
    final fast = _allFasts[realIndex];
    // Lecture de la taille dans FilterManager
    double currentFontSize = FilterManager.fontSizes['Jeûnes'] ?? 18.0;

    final String firstLetter = fast.content.substring(0, 1);
    final String restOfContent = fast.content.substring(1);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("JEÛNE ${realIndex + 1}",
                    style: TextStyle(color: fast.color.withOpacity(0.4), letterSpacing: 4, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  fast.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: fast.color
                  ),
                ),
              ),
              const Center(child: SizedBox(width: 100, child: Divider(color: Color(0xFFD4AF37), thickness: 2))),
              const SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  // Utilisation de currentFontSize ici
                  style: TextStyle(color: const Color(0xFF444444), fontSize: currentFontSize, height: 1.4),
                  children: [
                    WidgetSpan(
                      child: Text(firstLetter,
                          style: TextStyle(fontSize: currentFontSize * 3, fontWeight: FontWeight.bold, height: 0.8, color: fast.color)),
                    ),
                    TextSpan(text: restOfContent),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Center(child: Text("- ${realIndex + 1} -", style: const TextStyle(color: Colors.grey))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableOfContents() {
    return Positioned(
      top: 60,
      right: 15,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.98),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15)],
              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _allFasts.asMap().entries.map((entry) {
                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(entry.value.name,
                      style: TextStyle(color: entry.value.color, fontWeight: FontWeight.bold, fontSize: 12)),
                  onTap: () => _goToPage(entry.key),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}