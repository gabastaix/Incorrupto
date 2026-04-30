// lib/l10n/app_strings.dart
//
// Toutes les chaînes de l'appli en FR et EN.
// Utilisation :
//   Text(S.of(context).welcome)
//
// Pour ajouter une nouvelle chaîne :
//   1. Ajoute la clé dans AppStrings
//   2. Ajoute la traduction dans _fr et _en
//   3. Utilise S.of(context).taCle dans les widgets

import 'package:flutter/material.dart';

class S {
  final Map<String, String> _strings;
  S._(this._strings);

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S) ?? S._(_fr);
  }

  String get(String key) => _strings[key] ?? key;

  // ── Navigation ──────────────────────────────
  String get home        => get('home');
  String get profile     => get('profile');
  String get settings    => get('settings');

  // ── Login ────────────────────────────────────
  String get welcome     => get('welcome');
  String get welcomeSub  => get('welcomeSub');
  String get login       => get('login');
  String get register    => get('register');
  String get email       => get('email');
  String get password    => get('password');
  String get confirmPwd  => get('confirmPwd');
  String get firstName   => get('firstName');
  String get lastName    => get('lastName');
  String get birthDate   => get('birthDate');
  String get connect     => get('connect');
  String get createAccount => get('createAccount');
  String get forgotPwd   => get('forgotPwd');
  String get orContinue  => get('orContinue');
  String get continueGoogle => get('continueGoogle');
  String get continueApple  => get('continueApple');
  String get skipDev     => get('skipDev');
  String get loginError  => get('loginError');
  String get registerError => get('registerError');
  String get passwordMismatch => get('passwordMismatch');

  // ── Profil ───────────────────────────────────
  String get myProfile   => get('myProfile');
  String get feedSub     => get('feedSub');
  String get account     => get('account');
  String get notifications => get('notifications');
  String get preferences => get('preferences');
  String get privacyData => get('privacyData');
  String get premium     => get('premium');
  String get helpTrust   => get('helpTrust');
  String get legal       => get('legal');
  String get logout      => get('logout');
  String get logoutConfirm => get('logoutConfirm');
  String get cancel      => get('cancel');
  String get save        => get('save');
  String get send        => get('send');
  String get confirm     => get('confirm');
  String get language    => get('language');
  String get languageSub => get('languageSub');

  // ── Sections profil ──────────────────────────
  String get profileEdit     => get('profileEdit');
  String get profileEditSub  => get('profileEditSub');
  String get notifBreaking   => get('notifBreaking');
  String get notifBreakingSub=> get('notifBreakingSub');
  String get notifEmail      => get('notifEmail');
  String get notifEmailSub   => get('notifEmailSub');
  String get notifTopics     => get('notifTopics');
  String get notifTopicsSub  => get('notifTopicsSub');
  String get accessibility   => get('accessibility');
  String get accessibilitySub=> get('accessibilitySub');
  String get theme           => get('theme');
  String get themeSub        => get('themeSub');
  String get contentFormat   => get('contentFormat');
  String get contentFormatSub=> get('contentFormatSub');
  String get privacyPolicy   => get('privacyPolicy');
  String get privacyPolicySub=> get('privacyPolicySub');
  String get consents        => get('consents');
  String get consentsSub     => get('consentsSub');
  String get cookies         => get('cookies');
  String get cookiesSub      => get('cookiesSub');
  String get downloadData    => get('downloadData');
  String get downloadDataSub => get('downloadDataSub');
  String get rgpd            => get('rgpd');
  String get rgpdSub         => get('rgpdSub');
  String get deleteData      => get('deleteData');
  String get deleteDataSub   => get('deleteDataSub');
  String get mySubscription  => get('mySubscription');
  String get mySubscriptionSub => get('mySubscriptionSub');
  String get invoices        => get('invoices');
  String get invoicesSub     => get('invoicesSub');
  String get cancelSub       => get('cancelSub');
  String get cancelSubSub    => get('cancelSubSub');
  String get cgv             => get('cgv');
  String get cgvSub          => get('cgvSub');
  String get faq             => get('faq');
  String get faqSub          => get('faqSub');
  String get support         => get('support');
  String get supportSub      => get('supportSub');
  String get bugReport       => get('bugReport');
  String get bugReportSub    => get('bugReportSub');
  String get reportContent   => get('reportContent');
  String get reportContentSub=> get('reportContentSub');
  String get aiUsage         => get('aiUsage');
  String get aiUsageSub      => get('aiUsageSub');
  String get editorial       => get('editorial');
  String get editorialSub    => get('editorialSub');
  String get legalNotice     => get('legalNotice');
  String get legalNoticeSub  => get('legalNoticeSub');
  String get cgu             => get('cgu');
  String get cguSub          => get('cguSub');
  String get mediator        => get('mediator');
  String get mediatorSub     => get('mediatorSub');
  String get dsa             => get('dsa');
  String get dsaSub          => get('dsaSub');
  String get deleteConfirmText => get('deleteConfirmText');
  String get delete          => get('delete');
  String get keepPremium     => get('keepPremium');
  String get cancelConfirmText => get('cancelConfirmText');
  String get logoutTitle     => get('logoutTitle');

  // ── Language sheet ────────────────────────────
  String get chooseLanguage  => get('chooseLanguage');
  String get languageChanged => get('languageChanged');
  String get restart         => get('restart');
}

// ─────────────────────────────────────────────
//  TRADUCTIONS
// ─────────────────────────────────────────────

const Map<String, String> _fr = {
  // Navigation
  'home': 'Accueil',
  'profile': 'Profil',
  'settings': 'Réglages',

  // Login
  'welcome': 'Bienvenue 👋',
  'welcomeSub': 'Connecte-toi pour continuer',
  'login': 'Connexion',
  'register': 'Inscription',
  'email': 'Email',
  'password': 'Mot de passe',
  'confirmPwd': 'Confirmer le mot de passe',
  'firstName': 'Prénom',
  'lastName': 'Nom',
  'birthDate': 'Date de naissance',
  'connect': 'Se connecter',
  'createAccount': 'Créer mon compte',
  'forgotPwd': 'Mot de passe oublié ?',
  'orContinue': 'ou',
  'continueGoogle': 'Continuer avec Google',
  'continueApple': 'Continuer avec Apple',
  'skipDev': 'Passer (mode dev)',
  'loginError': 'Email ou mot de passe incorrect.',
  'registerError': 'Inscription impossible. Réessaie.',
  'passwordMismatch': 'Les mots de passe ne correspondent pas.',

  // Profil
  'myProfile': 'Mon profil',
  'feedSub': 'Votre fil est personnalisé selon vos sujets',
  'account': 'Compte',
  'notifications': 'Notifications',
  'preferences': 'Préférences',
  'privacyData': 'Confidentialité et données',
  'premium': 'Premium',
  'helpTrust': 'Aide et confiance',
  'legal': 'Légal',
  'logout': 'Se déconnecter',
  'logoutTitle': 'Se déconnecter',
  'logoutConfirm': 'Voulez-vous vraiment vous déconnecter ?',
  'cancel': 'Annuler',
  'save': 'Enregistrer',
  'send': 'Envoyer',
  'confirm': 'Confirmer',
  'language': 'Langue',
  'languageSub': 'Choisir la langue de l\'application',

  // Rows
  'profileEdit': 'Profil',
  'profileEditSub': 'Nom, email, mot de passe',
  'notifBreaking': 'Breaking news',
  'notifBreakingSub': 'Alertes en temps réel',
  'notifEmail': 'Emails',
  'notifEmailSub': 'Résumés et newsletters',
  'notifTopics': 'Alertes par sujet',
  'notifTopicsSub': 'Sujets que vous suivez',
  'accessibility': 'Accessibilité',
  'accessibilitySub': 'Taille du texte, contraste',
  'theme': 'Thème',
  'themeSub': 'Clair, sombre, automatique',
  'contentFormat': 'Formats de contenu',
  'contentFormatSub': 'Résumés, articles complets, audio',
  'privacyPolicy': 'Politique de confidentialité',
  'privacyPolicySub': 'Comment vos données sont utilisées',
  'consents': 'Gérer mes consentements',
  'consentsSub': 'Analytics, personnalisation',
  'cookies': 'Cookies et traceurs',
  'cookiesSub': 'SDK et partenaires',
  'downloadData': 'Télécharger mes données',
  'downloadDataSub': 'Export de vos données personnelles',
  'rgpd': 'Exercer mes droits RGPD',
  'rgpdSub': 'Accès, rectification, opposition…',
  'deleteData': 'Supprimer mes données',
  'deleteDataSub': 'Effacement de votre compte',
  'mySubscription': 'Mon abonnement',
  'mySubscriptionSub': 'Plan actuel, date de renouvellement',
  'invoices': 'Historique de factures',
  'invoicesSub': 'Télécharger vos reçus',
  'cancelSub': 'Résilier l\'abonnement',
  'cancelSubSub': 'Résiliation en quelques clics',
  'cgv': 'CGV',
  'cgvSub': 'Conditions générales de vente',
  'faq': 'FAQ',
  'faqSub': 'Questions fréquentes',
  'support': 'Contacter le support',
  'supportSub': 'Nous écrire',
  'bugReport': 'Signaler un bug',
  'bugReportSub': 'Aider à améliorer l\'app',
  'reportContent': 'Signaler un contenu / une erreur',
  'reportContentSub': 'Erreur factuelle ou contenu problématique',
  'aiUsage': 'Utilisation de l\'IA',
  'aiUsageSub': 'Comment l\'IA est utilisée',
  'editorial': 'Sources et neutralité',
  'editorialSub': 'Méthodologie éditoriale',
  'legalNotice': 'Mentions légales',
  'legalNoticeSub': 'Éditeur, hébergeur',
  'cgu': 'CGU',
  'cguSub': 'Conditions générales d\'utilisation',
  'mediator': 'Médiateur de la consommation',
  'mediatorSub': 'Réclamation et médiation',
  'dsa': 'Point de contact DSA',
  'dsaSub': 'Digital Services Act',
  'deleteConfirmText': 'Cette action est irréversible. Toutes vos données seront effacées sous 1 mois.',
  'delete': 'Supprimer',
  'keepPremium': 'Garder Premium',
  'cancelConfirmText': 'Votre accès restera actif jusqu\'à la fin de la période en cours.',

  // Language
  'chooseLanguage': 'Choisir la langue',
  'languageChanged': 'La langue sera appliquée après avoir sauvegardé.',
  'restart': 'Sauvegarder',
};

const Map<String, String> _en = {
  // Navigation
  'home': 'Home',
  'profile': 'Profile',
  'settings': 'Settings',

  // Login
  'welcome': 'Welcome 👋',
  'welcomeSub': 'Sign in to continue',
  'login': 'Login',
  'register': 'Sign up',
  'email': 'Email',
  'password': 'Password',
  'confirmPwd': 'Confirm password',
  'firstName': 'First name',
  'lastName': 'Last name',
  'birthDate': 'Date of birth',
  'connect': 'Sign in',
  'createAccount': 'Create my account',
  'forgotPwd': 'Forgot password?',
  'orContinue': 'or',
  'continueGoogle': 'Continue with Google',
  'continueApple': 'Continue with Apple',
  'skipDev': 'Skip (dev mode)',
  'loginError': 'Incorrect email or password.',
  'registerError': 'Registration failed. Please try again.',
  'passwordMismatch': 'Passwords do not match.',

  // Profil
  'myProfile': 'My profile',
  'feedSub': 'Your feed is personalised based on your topics',
  'account': 'Account',
  'notifications': 'Notifications',
  'preferences': 'Preferences',
  'privacyData': 'Privacy & data',
  'premium': 'Premium',
  'helpTrust': 'Help & trust',
  'legal': 'Legal',
  'logout': 'Sign out',
  'logoutTitle': 'Sign out',
  'logoutConfirm': 'Are you sure you want to sign out?',
  'cancel': 'Cancel',
  'save': 'Save',
  'send': 'Send',
  'confirm': 'Confirm',
  'language': 'Language',
  'languageSub': 'Choose the app language',

  // Rows
  'profileEdit': 'Profile',
  'profileEditSub': 'Name, email, password',
  'notifBreaking': 'Breaking news',
  'notifBreakingSub': 'Real-time alerts',
  'notifEmail': 'Emails',
  'notifEmailSub': 'Digests and newsletters',
  'notifTopics': 'Topic alerts',
  'notifTopicsSub': 'Topics you follow',
  'accessibility': 'Accessibility',
  'accessibilitySub': 'Text size, contrast',
  'theme': 'Theme',
  'themeSub': 'Light, dark, automatic',
  'contentFormat': 'Content formats',
  'contentFormatSub': 'Summaries, full articles, audio',
  'privacyPolicy': 'Privacy policy',
  'privacyPolicySub': 'How your data is used',
  'consents': 'Manage my consents',
  'consentsSub': 'Analytics, personalisation',
  'cookies': 'Cookies & trackers',
  'cookiesSub': 'SDKs and partners',
  'downloadData': 'Download my data',
  'downloadDataSub': 'Export your personal data',
  'rgpd': 'Exercise my GDPR rights',
  'rgpdSub': 'Access, rectification, objection…',
  'deleteData': 'Delete my data',
  'deleteDataSub': 'Erase your account',
  'mySubscription': 'My subscription',
  'mySubscriptionSub': 'Current plan, renewal date',
  'invoices': 'Invoice history',
  'invoicesSub': 'Download your receipts',
  'cancelSub': 'Cancel subscription',
  'cancelSubSub': 'Cancel in a few clicks',
  'cgv': 'Terms of sale',
  'cgvSub': 'General terms and conditions',
  'faq': 'FAQ',
  'faqSub': 'Frequently asked questions',
  'support': 'Contact support',
  'supportSub': 'Write to us',
  'bugReport': 'Report a bug',
  'bugReportSub': 'Help improve the app',
  'reportContent': 'Report content / an error',
  'reportContentSub': 'Factual error or problematic content',
  'aiUsage': 'AI usage',
  'aiUsageSub': 'How AI is used',
  'editorial': 'Sources & neutrality',
  'editorialSub': 'Editorial methodology',
  'legalNotice': 'Legal notice',
  'legalNoticeSub': 'Publisher, host',
  'cgu': 'Terms of use',
  'cguSub': 'General terms and conditions of use',
  'mediator': 'Consumer mediator',
  'mediatorSub': 'Complaints and mediation',
  'dsa': 'DSA contact point',
  'dsaSub': 'Digital Services Act',
  'deleteConfirmText': 'This action is irreversible. All your data will be erased within 1 month.',
  'delete': 'Delete',
  'keepPremium': 'Keep Premium',
  'cancelConfirmText': 'Your access will remain active until the end of the current billing period.',

  // Language
  'chooseLanguage': 'Choose language',
  'languageChanged': 'The language will be applied after saving.',
  'restart': 'Save',
};

// ─────────────────────────────────────────────
//  DELEGATE — enregistre S comme Localisation Flutter
// ─────────────────────────────────────────────
class AppLocalizationsDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['fr', 'en'].contains(locale.languageCode);

  @override
  Future<S> load(Locale locale) async {
    if (locale.languageCode == 'en') return S._(_en);
    return S._(_fr);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}