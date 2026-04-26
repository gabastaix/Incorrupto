# Description complète de l'arborescence du projet "Incorrupto"

Ce projet est une application Flutter multiplateforme nommée "Incorrupto" (version 1.0.0+1), utilisant Dart SDK ^3.11.0. Il est configuré pour être privé (non publié sur pub.dev) et supporte les plateformes Android, iOS, Web, Windows, Linux et macOS. Le point d'entrée principal est [lib/main.dart](lib/main.dart), qui importe et lance l'application depuis [lib/app/app.dart](lib/app/app.dart).

## Dépendances principales (extrait de [pubspec.yaml](pubspec.yaml))
- **Flutter SDK** : Framework principal pour l'interface utilisateur.
- **share_plus ^10.0.0** : Bibliothèque pour partager du contenu (fichiers, texte, etc.) entre applications.
- **cupertino_icons ^1.0.8** : Icônes iOS style pour l'interface.
- **flutter_lints ^6.0.0** : Outil de linting pour la qualité du code (en dev_dependencies).

## Structure des dossiers et fichiers

### Racine du projet
- [analysis_options.yaml](analysis_options.yaml) : Configuration des règles de linting et d'analyse statique pour Dart/Flutter.
- [flutter](flutter) : Dossier contenant des outils Flutter (probablement généré).
- [pubspec.yaml](pubspec.yaml) : Fichier de configuration du projet (dépendances, version, environnement).
- [README.md](README.md) : Documentation du projet (à lire pour les instructions générales).

### [lib/](lib/) - Code source Dart/Flutter (frontend)
C'est le cœur de l'application où tout le code métier et UI est écrit.
- [lib/main.dart](lib/main.dart) : Point d'entrée de l'app (importe et lance `App()`).
- [lib/app/](lib/app/) : Logique principale de l'application.
  - [lib/app/app.dart](lib/app/app.dart) : Classe principale `App` (probablement le widget racine).
  - [lib/app/shell.dart](lib/app/shell.dart) : Shell de l'application (navigation ou structure globale).
- [lib/design/](lib/design/) : Fichiers liés au design et à l'UI.
  - [lib/design/figma_checklist.dart](lib/design/figma_checklist.dart) : Checklist pour le design Figma.
  - [lib/design/figma_contract.dart](lib/design/figma_contract.dart) : Contrat ou spécifications Figma.
  - [lib/design/screen_map.dart](lib/design/screen_map.dart) : Mapping des écrans.
- [lib/screens/](lib/screens/) : Écrans/pages de l'application.
  - [lib/screens/details/](lib/screens/details/) : Écran de détails (vides pour l'instant).
  - [lib/screens/explorer/](lib/screens/explorer/) : Écran d'exploration.
  - [lib/screens/home/](lib/screens/home/) : Écran d'accueil.
  - [lib/screens/profil/](lib/screens/profil/) : Écran de profil.
  - [lib/screens/sujets/](lib/screens/sujets/) : Écran des sujets.
- [lib/state/](lib/state/) : Gestion d'état.
  - [lib/state/topic_store.dart](lib/state/topic_store.dart) : Store pour les topics (probablement avec un gestionnaire d'état comme Provider ou Riverpod).

### [android/](android/) - Configuration Android native
Généré automatiquement par Flutter pour la plateforme Android.
- [android/app/build.gradle.kts](android/app/build.gradle.kts) : Configuration Gradle pour l'app Android.
- [android/app/src/main/kotlin/com/example/incorrupto/MainActivity.kt](android/app/src/main/kotlin/com/example/incorrupto/MainActivity.kt) : Activité principale Kotlin (point d'entrée natif).
- [android/build.gradle.kts](android/build.gradle.kts), [android/gradle.properties](android/gradle.properties), etc. : Fichiers de build Gradle.
- [android/settings.gradle.kts](android/settings.gradle.kts) : Paramètres du projet Gradle.

### [ios/](ios/) - Configuration iOS native
Généré pour iOS.
- [ios/Runner/](ios/Runner/) : Code Swift/Objective-C pour l'app iOS.
  - [ios/Runner/AppDelegate.swift](ios/Runner/AppDelegate.swift) : Delegate de l'app.
  - [ios/Runner/Info.plist](ios/Runner/Info.plist) : Configuration plist.
- [ios/Runner.xcodeproj/](ios/Runner.xcodeproj/) : Projet Xcode.

### [web/](web/) - Configuration Web
- [web/index.html](web/index.html) : Page HTML principale pour le déploiement web.
- [web/manifest.json](web/manifest.json) : Manifest PWA.
- [web/icons/](web/icons/) : Icônes pour l'app web.

### [windows/](windows/) - Configuration Windows native
- [windows/runner/](windows/runner/) : Code C++ pour l'app Windows.
- [windows/CMakeLists.txt](windows/CMakeLists.txt) : Configuration CMake.

### [linux/](linux/) et [macos/](macos/) - Configurations similaires pour Linux et macOS
- Fichiers CMake et code natif générés.

### [test/](test/) - Tests unitaires/intégration
- [test/widget_test.dart](test/widget_test.dart) : Test de widget de base (généré par Flutter).

## Notes pour l'ingénieur
- **Développement** : Travaille principalement dans [lib/](lib/) pour le code Dart. Utilise `flutter run` depuis la racine pour lancer sur émulateur/appareil.
- **Build** : `flutter build` pour les différentes plateformes (ex. `flutter build apk` pour Android).
- **Dépendances** : Lance `flutter pub get` après clonage pour installer les packages.
- **État actuel** : L'app semble structurée avec des écrans séparés et un store d'état. Vérifie [lib/app/app.dart](lib/app/app.dart) pour la structure globale.
- **Plateformes** : Tout est généré automatiquement ; ne modifie pas les dossiers natifs sauf si nécessaire (ex. permissions Android dans [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml), non listé mais présent).

Si tu as besoin de plus de détails sur un fichier spécifique, fais-le moi savoir ! 📂