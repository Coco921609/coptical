import 'package:flutter/material.dart';
import 'main.dart'; // Import indispensable pour FilterManager

class FactItem {
  final String title;
  final String content;
  final Color accentColor;

  FactItem({
    required this.title,
    required this.content,
    required this.accentColor,
  });
}

class DidYouKnowScreen extends StatefulWidget {
  const DidYouKnowScreen({super.key});

  @override
  State<DidYouKnowScreen> createState() => _DidYouKnowScreenState();
}

class _DidYouKnowScreenState extends State<DidYouKnowScreen> {
  late PageController _pageController;
  double _currentPageValue = 0.0;
  bool _isMenuOpen = false;
  final int _loopFactor = 10000;

  final List<FactItem> _allFacts = [
    // ... Garde ta liste _allFacts identique ici ...
    FactItem(
      title: "Qu'est-ce que le Paramoun ?",
      accentColor: const Color(0xFF8E44AD),
      content: "Le Paramoun est le ou les jours de préparations précédant la fête de Noël et de la Théophanie. Ce sont des jours de jeûnes stricts (jeûne de premier degré). Le mot Paramoun vient du grec et signifie « veille ». \n\nDes abstentions et des prosternations sont pratiquées ce jour-là. Mais si la veille de la fête tombe un samedi ou un dimanche alors le Paramoun commence à partir du vendredi (jour de jeûne strict) et se poursuit les jours du week-end (sans abstention, ni prosternation, que ce soit le samedi ou le dimanche). \n\nLe jour de Paramoun, les lectures sont spéciales et l'air est celui de la saison normale. Enfin, si le Paramoun dure plus d'un jour, les mêmes lectures sont répétées.",
    ),
    FactItem(
      title: "Jeûner avant la communion ?",
      accentColor: const Color(0xFFC0392B),
      content: "Dans l'église copte orthodoxe, il faut être à jeun pour pouvoir prendre sa communion. En effet, nous devons préparer notre corps à recevoir le corps et le sang du Christ qui n'est pas une nourriture ordinaire. Nous devons donc être purifiés spirituellement, corporellement et intérieurement. \n\nÊtre à jeun permet de faire de la place pour accueillir le Christ, comme si nous préparions la crèche qui va accueillir le Roi des rois. \n\nNous devons jeûner 9 heures avant de prendre la communion. Ces 9 heures correspondent aux 9 heures de souffrances du Christ, depuis Son arrestation jusqu'à Sa crucifixion (de la troisième heure à la douzième heure).",
    ),
    FactItem(
      title: "Le vendredi et le mercredi ?",
      accentColor: const Color(0xFFD35400),
      content: "L'église copte orthodoxe pratique un jeûne stricte deux jours dans la semaine : \n\n- Le mercredi en souvenir de la trahison de Judas qui a vendu le Christ ce jour-là. \n\n- Le vendredi en souvenir de la crucifixion du Christ. \n\nSeuls durant les 50 jours suivant Pâques, ces jeûnes ne sont pas appliqués. En effet, durant ces 50 jours, l'église se concentre uniquement sur la joie de la résurrection. C'est la raison pour laquelle aucun jeûne n'est réalisé durant cette période. Cette période est appelée la cinquantaine. \n\nUne dernière exception a lieu, si l'une des sept grandes fêtes seigneuriales tombe un mercredi ou un vendredi, dans ce cas-là, on ne jeûne pas.",
    ),
    FactItem(
      title: "Origines du carême ?",
      accentColor: const Color(0xFF2C3E50),
      content: "D'un point de vue général le jeûne dans l'église date de l'époque apostolique et que ce soit dans l'acte des apôtres ou dans les épitres de Saint Paul, beaucoup de références aux jeûnes y sont fait. \n\nSelon la tradition orthodoxe le carême a une origine apostolique suivant la parole du Christ qui a dit : \" Des jours viendront où l'Epoux sera enlevé à ses disciples, et alors ils jeûneront \" (Luc 5, 35). \n\nLe carême a été établi par notre Seigneur Jésus Christ Lui-même lorsqu'il jeûna dans le désert durant quarante jours avant d'être tenté par le diable et avant de commencer son service. \n\nDans l'église primitive les catéchumènes étaient baptisés la veille de Pâques, ainsi ils avaient une préparation de quarante jours précédant leur baptême durant laquelle ils jeûnaient. \n\nSaint Irénée (IIème siècle) parle d'un jeûne d'abstention d'un jour entier ou de deux jours précédant la messe de Pâques. Enfin au concile de Nicée (en 325) le carême précédent Pâques est considéré comme établi depuis longtemps.",
    ),
    FactItem(
      title: "Jeûnes avec ou sans poisson ?",
      accentColor: const Color(0xFF27AE60),
      content: "Le jeûne au départ était composé d'un seul repas par jour constitué d'eau, de pain et de légume. Pourquoi ce régime végétalien ? \n\nPour retourner à notre état initial, en effet Adam et Ève ont été faits végétariens ne mangeant rien provenant d'animaux. Dieu créa l'homme végétarien, aussi lorsqu'Il guida Son peuple dans le désert Il lui donna une nourriture végétale. \n\nAinsi le jeûne dans l'église copte orthodoxe reprend ce principe de s'abstenir de toutes nourritures d'origines animales tel que le lait, le beurre, les œufs... \n\nDeux degrés de jeûnes ont été établis : \n\n- Les jeûnes du premier degré, dit stricts : Le Grand carême, le jeûne de Ninive, les jours de préparation (Paramoune). \n\n- Les jeûnes du second degré (poisson autorisé) : Le jeûne de l'Avent, les jeûnes des apôtres et le jeûne de la Sainte Vierge Marie.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    int initialPage = _allFacts.length * (_loopFactor ~/ 2);
    _pageController = PageController(initialPage: initialPage);
    _currentPageValue = initialPage.toDouble();
    _pageController.addListener(() => setState(() => _currentPageValue = _pageController.page!));
  }

  void _goToPage(int realIndex) {
    int currentPage = _pageController.page!.round();
    int currentRealIndex = currentPage % _allFacts.length;
    int offset = realIndex - currentRealIndex;
    _pageController.animateToPage(
        currentPage + offset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate
    );
    setState(() => _isMenuOpen = false);
  }

  // --- LOGIQUE DES EFFETS DE TRANSITION ---
  Matrix4 _applyEffect(double value, int index, String effect) {
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
        matrix.setEntry(3, 2, 0.001);
        matrix.rotateZ(diff * 2);
        matrix.scale(1.0 - diff.abs());
        break;
      case 'Page':
      // Simule un tournage de page
        double translate = diff * 100;
        matrix.translate(translate);
        break;
      default: // Par défaut (Léger angle)
        matrix.setEntry(3, 2, 0.001);
        matrix.rotateY(diff * 0.3);
    }
    return matrix;
  }

  @override
  Widget build(BuildContext context) {
    // Récupération de l'effet choisi
    String currentEffect = FilterManager.effects['Saviez-vous ?'] ?? 'Par défaut';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
                final realIndex = index % _allFacts.length;
                return Transform(
                  transform: _applyEffect(_currentPageValue, index, currentEffect),
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
                  onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
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
    final fact = _allFacts[realIndex];
    // Récupération de la taille de police choisie
    double currentFontSize = FilterManager.fontSizes['Saviez-vous ?'] ?? 18.0;

    final String firstLetter = fact.content.substring(0, 1);
    final String restOfContent = fact.content.substring(1);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("LE SAVIEZ-VOUS ? ${realIndex + 1}",
                    style: TextStyle(color: fact.accentColor.withOpacity(0.4), letterSpacing: 4, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  fact.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: fact.accentColor),
                ),
              ),
              const Center(child: SizedBox(width: 80, child: Divider(color: Color(0xFFD4AF37), thickness: 2))),
              const SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  // Utilisation de la variable de taille de police ici
                  style: TextStyle(color: const Color(0xFF444444), fontSize: currentFontSize, height: 1.5),
                  children: [
                    WidgetSpan(
                      child: Text(firstLetter,
                          style: TextStyle(fontSize: currentFontSize * 3, fontWeight: FontWeight.bold, height: 0.8, color: fact.accentColor)),
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
        child: Container(
          width: 220,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.98),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15)],
            border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _allFacts.asMap().entries.map((entry) {
                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    title: Text(entry.value.title,
                        style: TextStyle(color: entry.value.accentColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    onTap: () => _goToPage(entry.key),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}