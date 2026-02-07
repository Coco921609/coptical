import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'main.dart'; // Pour accéder à FilterManager

class FeastItem {
  final String name;
  final String content;
  final Color color;

  FeastItem({
    required this.name,
    required this.content,
    required this.color,
  });
}

class FeastsScreen extends StatefulWidget {
  const FeastsScreen({super.key});

  @override
  State<FeastsScreen> createState() => _FeastsScreenState();
}

class _FeastsScreenState extends State<FeastsScreen> {
  late PageController _pageController;
  double _currentPageValue = 0.0;
  bool _isMenuOpen = false;
  final int _loopFactor = 10000;

  // --- LISTE COMPLÈTE DES 19 FÊTES (Design original conservé) ---
  final List<FeastItem> _allFeasts = [
    FeastItem(
      name: "Noël",
      color: Colors.pink,
      content: "C'est une Grande fête Seigneuriale, elle est fêtée le 29 du mois de Kiahk du Calendrier Copte.\n\nL'incarnation révèle tout l'amour divin. En effet, Dieu a envoyé Son Fils unique. Par Son incarnation, Il a rendu à l'humanité son honneur et a sanctifié notre vie quotidienne, offrant Sa vie comme un sacrifice pour notre salut.\n\nEt la parole a été faite chair, et elle a habité parmi nous, pleine de grâce et de vérité ; et nous avons contemplé sa gloire, une gloire comme la gloire du Fils unique venu du Père. (Jean 1 : 14)",
    ),
    FeastItem(
      name: "Circoncision",
      color: Colors.brown,
      content: "La circoncision est une petite fête Seigneuriale, elle est fêtée le 6 du mois de Toubah du Calendrier Copte.\n\nLa Circoncision est célébrée le huitième jour après Noël. Durant cette fête nous nous souvenons que Jésus le Verbe de Dieu incarné, qui nous a donné la loi, s'est Lui-même soumis à cette loi, l'accomplissant pour nous permettre de l'accomplir à notre tour d'une manière spirituelle.\n\nEt c'est en lui que vous avez été circoncis d'une circoncision que la main n'a pas faite, mais de la circoncision de Christ, qui consiste dans le dépouillement du corps de la chair. (Colossiens 2 : 11)",
    ),
    FeastItem(
      name: "Théophanie",
      color: Colors.pink,
      content: "La Théophanie est une grande fête Seigneuriale, elle est fêtée le 11 du mois de Toubah du Calendrier Copte.\n\nLors de la fête de la Théophanie, la liturgie de bénédiction de l'eau est réalisée et le prêtre bénit le peuple avec l'eau en commémoration du baptême du Christ. Par Son incarnation, Il est devenu un vrai homme alors qu'Il n'était encore que le Fils unique de Dieu, et par le baptême, nous devenons à notre tour enfants de Dieu.\n\nDès que Jésus eut été baptisé, il sortit de l'eau. Et voici, les cieux s'ouvrirent, et il vit l'Esprit de Dieu descendre comme une colombe et venir sur lui. (Matthieu 3 : 16-17)",
    ),
    FeastItem(
      name: "Noces de Cana",
      color: Colors.brown,
      content: "Le Miracle des Noces de Cana en Galilée est une petite fête Seigneuriale, elle est fêtée le 13 du mois de Toubah du Calendrier Copte.\n\nC'est le premier miracle réalisé par notre Seigneur Jésus-Christ Qui, à la demande de Sa mère la Vierge Marie, changea de l'eau en vin. Cet événement eut lieu lors d'un mariage auquel ils étaient invités.\n\nIl manifesta sa gloire, et ses disciples mirent leur foi en lui. (Jean 2 : 1-12)",
    ),
    FeastItem(
      name: "Présentation au Temple",
      color: Colors.brown,
      content: "La présentation de notre Seigneur et Sauveur Jésus Christ au temple est une petite fête Seigneuriale, elle est fêtée le 5 du mois de Amshir du Calendrier Copte.\n\nNous nous souvenons que la Parole de Dieu est devenue un homme, ainsi nous ne devons pas être négligents dans notre vie. Nous pourrons ainsi nous écrier avec Siméon : \" Maintenant, Seigneur, Tu laisses ton serviteur S'en aller en paix, selon Ta parole. Car mes yeux ont vu Ton salut. \"\n\nEt, quand les jours de leur purification furent accomplis, Joseph et Marie le portèrent à Jérusalem, pour le présenter au Seigneur. (Luc 2 : 22)",
    ),
    FeastItem(
      name: "Découverte de la Sainte Croix",
      color: Colors.green,
      content: "L'église célèbre le 10 du mois de Baramhat du Calendrier Copte la Découverte de la Sainte Croix.\n\nNous célébrons la découverte, en 326, de la Sainte Croix par l'Impératrice Hélène, mère de Constantin le grand. Cette dernière alla à Jérusalem pour retrouver la croix de notre Seigneur Jésus Christ.\n\nCar la prédication de la croix est une folie pour ceux qui périssent ; mais pour nous qui sommes sauvés, elle est une puissance de Dieu. (1 Corinthiens 1 : 18)",
    ),
    FeastItem(
      name: "Annonciation",
      color: Colors.pink,
      content: "L'Annonciation de l'ange Gabriel à la Vierge Marie est une grande fête Seigneuriale célébrée le 29 de Baramhat du Calendrier Copte.\n\nNous commémorons l'accomplissement des prophéties de l'Ancien Testament et l'attente du peuple de Dieu depuis des générations, à savoir la venue de la Parole de Dieu incarnée dans le ventre de la Vierge.\n\nJe vous le dis en vérité, beaucoup de prophètes et de justes ont désiré voir ce que vous voyez, et ne l'ont pas vu. (Matthieu 13 : 17)",
    ),
    FeastItem(
      name: "Dimanche des Rameaux",
      color: Colors.pink,
      content: "Le Dimanche des Rameaux est une grande fête Seigneuriale célébrée une semaine avant la fête de Pâques.\n\nL'Eglise commémore l'entrée de Jésus-Christ au sein de notre Jérusalem intérieure. Grâce à cette entrée, notre Seigneur Jésus-Christ a pu établir Son Royaume en nous et rassembler tous les siens en Lui.\n\nHosanna au Fils de David ! Béni soit celui qui vient au nom du Seigneur ! Hosanna dans les lieux très hauts ! (Matthieu 21 : 9)",
    ),
    FeastItem(
      name: "Jeudi Saint",
      color: Colors.lightBlueAccent,
      content: "Le Jeudi Saint est une petite fête Seigneuriale célébrée le Jeudi de la Semaine Sainte.\n\nNous y commémorons la création du sacrement de l'Eucharistie par notre Seigneur Jésus, offrant Son corps et Son sang comme un sacrifice vivant et efficace, capable de sanctifier nos cœurs.\n\nJe suis le pain vivant qui est descendu du ciel. Si quelqu'un mange de ce pain, il vivra éternellement. (Jean 6 : 51)",
    ),
    FeastItem(
      name: "Pâques",
      color: Colors.pink,
      content: "La Fête de Pâques est une grande fête Seigneuriale.\n\nConsidérée par l'Eglise comme la fête la plus importante du Christianisme. Nous y célébrons la résurrection de notre Seigneur Jésus Christ, qui par Sa mort a vaincu la mort et a donné la vie à ceux qui étaient dans les tombeaux.\n\nComme Christ est ressuscité des morts par la gloire du Père, de même nous aussi nous marchions en nouveauté de vie. (Romains 6 : 4)",
    ),
    FeastItem(
      name: "Dimanche de Thomas",
      color: Colors.brown,
      content: "Il s'agit du dimanche suivant Pâques. Durant ce jour, Jésus apparut aux disciples. Saint Thomas, n'étant pas présent, ne voulut pas y croire car il ne l'avait pas vu. Jésus revint alors spécialement pour lui.\n\nJésus lui dit : Parce que tu m'as vu, tu as cru. Heureux ceux qui n'ont pas vu, et qui ont cru ! (Jean 20 : 29)",
    ),
    FeastItem(
      name: "La Fuite en Egypte",
      color: Colors.brown,
      content: "La fuite en Egypte est une petite fête Seigneuriale célébrée le 24 du mois de Bashan du calendrier Copte.\n\nL'Eglise Copte orthodoxe est particulièrement fière que le Christ ait choisi l'Egypte comme unique pays, hormis l'Israël, pour le visiter.\n\nLève-toi, prends le petit enfant et sa mère, fuis en Egypte, et restes-y jusqu'à ce que je te parle. (Matthieu 2 : 13)",
    ),
    FeastItem(
      name: "L'Ascension",
      color: Colors.pink,
      content: "L'Ascension est une grande fête Seigneuriale célébrée 40 jours après la fête de Pâques.\n\nElle commémore la montée au ciel de notre Seigneur Jésus Christ. Nous nous rappelons de Celui qui nous a relevé d'entre les morts et nous a élevé afin que nous puissions nous asseoir à Ses côtés dans le ciel.\n\nIl nous a ressuscités ensemble, et nous a fait asseoir ensemble dans les lieux célestes, en Jésus-Christ. (Eph. 2 : 6)",
    ),
    FeastItem(
      name: "La Pentecôte",
      color: Colors.pink,
      content: "La Pentecôte est une grande fête Seigneuriale célébrée 50 jours après la fête de Pâques.\n\nNous commémorons la descente de l'Esprit Saint sur les apôtres et la Vierge Marie. Cette fête représente l'anniversaire de l'Église chrétienne. Il a envoyé Son Saint Esprit habiter en Son Eglise, lui offrant son existence, ses conseils et sa sanctification.\n\nDes langues, semblables à des langues de feu, leur apparurent et se posèrent sur chacun d'eux. (Actes 2 : 3)",
    ),
    FeastItem(
      name: "La fête des Apôtres",
      color: Colors.green,
      content: "La fête des Apôtres est célébrée le 5 de Abib du calendrier Copte.\n\nC'est la fête du martyr de Saint Pierre et Saint Paul. Durant cette fête, la liturgie de bénédiction de l'eau a lieu, où le prêtre lave les pieds de son peuple pour se souvenir de ce que le Christ a fait. Le prêtre se souvient qu'il est un serviteur.\n\nLe serviteur n'est pas plus grand que son seigneur, ni l'apôtre plus grand que celui qui l'a envoyé. (Jean 13 : 16)",
    ),
    FeastItem(
      name: "La Transfiguration",
      color: Colors.brown,
      content: "La Transfiguration est une petite fête Seigneuriale célébrée le 13 de Misra du calendrier Copte.\n\nL'unité des deux Testaments s'est manifestée car Moïse et Élie se sont réunis avec Pierre, Jacques et Jean. La gloire de notre Seigneur a été révélée pour satisfaire l'âme de ceux qui sont montés avec Lui.\n\nPendant qu'il priait, l'aspect de son visage changea et son vêtement devint d'une blancheur éclatante. (Luc 9 : 29)",
    ),
    FeastItem(
      name: "Assomption de la Vierge",
      color: Colors.green,
      content: "L'Assomption de la Sainte Vierge Marie est célébrée le 16 de Misra du calendrier Copte.\n\nElle correspond à la montée au ciel de son corps. La tradition rapporte que Sainte Marie est morte entourée des apôtres. Thomas, arrivé plus tard, demande à voir la tombe, mais celle-ci était vide ; les apôtres en déduisirent qu'elle fut emportée au ciel.\n\nUn grand signe parut dans le ciel : une femme enveloppée du soleil, la lune sous ses pieds. (Apocalypse 12 : 1)",
    ),
    FeastItem(
      name: "Nouvel An",
      color: Colors.green,
      content: "Fête de Nayrouz, célébrée le 1er jour du mois de Tout du Calendrier Copte.\n\nLe calendrier commence au début du règne de Dioclétien en l'an 284, en souvenir des martyrs coptes. Son règne est considéré comme une époque dorée où l'église a offert de véritables témoins du Christ.\n\nRendez grâces en toutes choses, car c'est à votre égard la volonté de Dieu en Jésus Christ. (1 Corinthiens 5 : 18)",
    ),
    FeastItem(
      name: "Fête de la Sainte Croix",
      color: Colors.green,
      content: "Elle débute le 17 du mois de Tout et dure 3 jours.\n\nNous commémorons l'édification de la première église dédiée à la Sainte Croix par l'impératrice Hélène.\n\nNous, nous prêchons Christ crucifié ; scandale pour les Juifs et folie pour les païens, mais puissance de Dieu. (1 Corinthiens 1 : 23)",
    ),
  ];

  @override
  void initState() {
    super.initState();
    int initialPage = _allFeasts.length * (_loopFactor ~/ 2);
    _pageController = PageController(initialPage: initialPage);
    _currentPageValue = initialPage.toDouble();
    _pageController.addListener(() => setState(() => _currentPageValue = _pageController.page!));
  }

  void _goToPage(int realIndex) {
    int currentPage = _pageController.page!.round();
    int currentRealIndex = currentPage % _allFeasts.length;
    int offset = realIndex - currentRealIndex;
    _pageController.animateToPage(
        currentPage + offset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate
    );
    setState(() => _isMenuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    String effect = FilterManager.effects['Fêtes'] ?? 'Par défaut';

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
                double position = _currentPageValue - index;
                return _buildAnimatedPage(index, position, effect);
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

  Widget _buildAnimatedPage(int index, double position, String effect) {
    final realIndex = index % _allFeasts.length;
    Widget page = _buildBookPage(realIndex);

    switch (effect) {
      case 'Perspective':
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(position.clamp(-1.0, 1.0) * 0.45),
          alignment: Alignment.center,
          child: page,
        );
      case 'Rotation':
        return Transform.rotate(
          angle: position * 0.5,
          child: page,
        );
      case 'Compressé':
        return Transform.scale(
          scale: 1.0 - (position.abs() * 0.3),
          child: page,
        );
      case 'Boite':
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(position * 1.5),
          alignment: position > 0 ? Alignment.centerRight : Alignment.centerLeft,
          child: page,
        );
      case 'Retourner':
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(position * math.pi),
          alignment: Alignment.center,
          child: page,
        );
      case 'Moulin à vent':
        return Transform(
          transform: Matrix4.identity()
            ..rotateZ(position * 2)
            ..scale(1.0 - position.abs().clamp(0.0, 0.5)),
          alignment: Alignment.center,
          child: page,
        );
      case 'Page':
        return Transform.translate(
          offset: Offset(position * 100, 0),
          child: page,
        );
      default: // Par défaut
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(position.clamp(-1.0, 1.0) * 0.5),
          alignment: Alignment.center,
          child: page,
        );
    }
  }

  Widget _buildBookPage(int realIndex) {
    final feast = _allFeasts[realIndex];
    final String firstLetter = feast.content.substring(0, 1);
    final String restOfContent = feast.content.substring(1);
    double customFontSize = FilterManager.fontSizes['Fêtes'] ?? 18.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("FÊTE ${realIndex + 1} / ${_allFeasts.length}",
                    style: TextStyle(color: feast.color.withOpacity(0.4), letterSpacing: 4, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  feast.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: feast.color),
                ),
              ),
              const Center(child: SizedBox(width: 100, child: Divider(color: Color(0xFFD4AF37), thickness: 2))),
              const SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(color: const Color(0xFF444444), fontSize: customFontSize, height: 1.4),
                  children: [
                    WidgetSpan(
                      child: Text(firstLetter,
                          style: TextStyle(fontSize: customFontSize * 3, fontWeight: FontWeight.bold, height: 0.8, color: feast.color)),
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
      bottom: 20,
      child: SafeArea(
        child: Container(
          width: 220,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.98),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15)],
            border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _allFeasts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(_allFeasts[index].name,
                      style: TextStyle(color: _allFeasts[index].color, fontWeight: FontWeight.bold, fontSize: 13)),
                  onTap: () => _goToPage(index),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}