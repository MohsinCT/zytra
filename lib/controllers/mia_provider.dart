import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zytranow/mock_data/mock_mia_engine.dart';
import 'package:zytranow/models/mia_models.dart';

class MiaProvider extends ChangeNotifier {
  final MiaEngineService _engine;

  MiaProvider({MiaEngineService? engine})
      : _engine = engine ?? MockMiaEngine.instance {
    _initialize();
  }

  // ─── Interaction & UI State ──────────────────────────────────────────────
  MiaInteractionMode _mode = MiaInteractionMode.voice;
  MiaInteractionMode get mode => _mode;

  bool _isListening = false;
  bool get isListening => _isListening;

  bool _isTranscribing = false;
  bool get isTranscribing => _isTranscribing;

  String _transcriptionText = '';
  String get transcriptionText => _transcriptionText;

  bool _isAITyping = false;
  bool get isAITyping => _isAITyping;

  // ─── Dynamic Canvas Data ─────────────────────────────────────────────────
  MiaProductCard? _activeProduct;
  MiaProductCard? get activeProduct => _activeProduct;

  MiaIngredientAnalysis? _activeIngredientAnalysis;
  MiaIngredientAnalysis? get activeIngredientAnalysis =>
      _activeIngredientAnalysis;

  bool _isParsingInstagram = false;
  bool get isParsingInstagram => _isParsingInstagram;

  String _instagramExtractionStatus =
      'Reading post contents & analyzing ingredients...';
  String get instagramExtractionStatus => _instagramExtractionStatus;

  // ─── Conversation History (Silent Mode) ──────────────────────────────────
  final List<MiaMessage> _messages = [];
  List<MiaMessage> get messages => List.unmodifiable(_messages);

  // ─── Controllers & Simulation Timers ─────────────────────────────────────
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Timer? _listeningSimulationTimer;
  Timer? _audioRippleTimer;
  double _audioWaveLevel = 0.5;
  double get audioWaveLevel => _audioWaveLevel;

  int _simulatedPhraseIndex = 0;
  final List<String> _simulatedVoicePhrases = [
    'Night-party lipsticks',
    'Show me Honey Shade',
    'Switch to Berry Burst',
    'Switch to Ruby Velvet',
    'Switch to Coral Sunset',
    'Is this safe for sensitive lips?',
  ];

  void _initialize() async {
    _activeProduct = await _engine.getFeaturedLipstickProduct();
    // Pre-populate an initial welcome message in conversation history
    _messages.add(
      MiaMessage(
        id: 'msg_welcome',
        sender: MiaSender.mia,
        text:
            'Hello! I am Mia, your AI beauty & retail concierge. Speak to explore shades hands-free, or paste an Instagram link to break down cosmetic ingredients.',
        timestamp: DateTime.now(),
        product: _activeProduct,
        suggestedFollowUps: _engine.getSuggestedVoiceTriggers(),
      ),
    );
    notifyListeners();
  }

  // ─── Mode Switching ───────────────────────────────────────────────────────
  void setMode(MiaInteractionMode newMode) {
    if (_mode == newMode) return;
    _mode = newMode;
    if (_mode == MiaInteractionMode.silent && _isListening) {
      stopListening();
    }
    notifyListeners();
  }

  /// Triggered whenever the user inputs text in the search/input bar.
  /// Immediate switch to Silent Chat Mode as per spec.
  void onTextInputChanged(String text) {
    if (text.isNotEmpty && _mode != MiaInteractionMode.silent) {
      _mode = MiaInteractionMode.silent;
      if (_isListening) {
        stopListening();
      }
      notifyListeners();
    }
  }

  // ─── Voice Mode & Simulation ──────────────────────────────────────────────
  void toggleListening() {
    if (_isListening) {
      stopListening();
    } else {
      startListening();
    }
  }

  void startListening([String? customPhrase]) {
    // Ensure we are in Voice Mode when mic is triggered
    _mode = MiaInteractionMode.voice;
    _isListening = true;
    _isTranscribing = true;
    _transcriptionText = 'Listening...';
    notifyListeners();

    // Start ripple animation wave pulsing
    _audioRippleTimer?.cancel();
    _audioRippleTimer =
        Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!_isListening) {
        timer.cancel();
        return;
      }
      _audioWaveLevel = 0.3 + (DateTime.now().millisecond % 70) / 100.0;
      notifyListeners();
    });

    // Simulate speech-to-text recognition after brief natural audio delay
    _listeningSimulationTimer?.cancel();
    final phrase = customPhrase ??
        _simulatedVoicePhrases[
            _simulatedPhraseIndex % _simulatedVoicePhrases.length];
    _simulatedPhraseIndex++;

    _listeningSimulationTimer = Timer(const Duration(milliseconds: 800), () {
      if (!_isListening) return;
      _transcriptionText = 'Transcribing: "$phrase"';
      notifyListeners();

      _listeningSimulationTimer = Timer(const Duration(milliseconds: 900), () {
        if (!_isListening) return;
        _isListening = false;
        _isTranscribing = false;
        _audioRippleTimer?.cancel();
        _transcriptionText = phrase;
        notifyListeners();

        // Process the transcribed voice phrase
        _executeVoicePhrase(phrase);
      });
    });
  }

  void stopListening() {
    _isListening = false;
    _isTranscribing = false;
    _listeningSimulationTimer?.cancel();
    _audioRippleTimer?.cancel();
    notifyListeners();
  }

  /// Quick simulated voice trigger chips for instant zero-touch UX demo.
  void simulateVoiceTrigger(String phrase) {
    startListening(phrase);
  }

  Future<void> _executeVoicePhrase(String phrase) async {
    _isAITyping = true;
    notifyListeners();

    // Add user voice input into messages
    _messages.add(
      MiaMessage(
        id: 'msg_u_${DateTime.now().millisecondsSinceEpoch}',
        sender: MiaSender.user,
        text: phrase,
        timestamp: DateTime.now(),
        isVoice: true,
      ),
    );

    // Call decoupled engine
    final response = await _engine.processQuery(
      query: phrase,
      isVoice: true,
      currentProduct: _activeProduct,
    );

    if (response.product != null) {
      _activeProduct = response.product;
    }
    if (response.ingredientAnalysis != null) {
      _activeIngredientAnalysis = response.ingredientAnalysis;
    }

    _messages.add(response);
    _isAITyping = false;
    notifyListeners();
  }

  // ─── Zero-Touch Shade Switching ───────────────────────────────────────────
  void switchShade(int index, {bool fromVoice = false}) {
    if (_activeProduct == null) return;
    if (index < 0 || index >= _activeProduct!.shades.length) return;

    _activeProduct = _activeProduct!.copyWith(activeShadeIndex: index);

    final selected = _activeProduct!.shades[index];
    if (fromVoice) {
      _messages.add(
        MiaMessage(
          id: 'msg_v_${DateTime.now().millisecondsSinceEpoch}',
          sender: MiaSender.mia,
          text:
              'Seamlessly switched to "${selected.name}" (${selected.undertone}). Skin swatch updated dynamically.',
          timestamp: DateTime.now(),
          isVoice: true,
          product: _activeProduct,
        ),
      );
    }
    notifyListeners();
  }

  void switchShadeByName(String shadeName) {
    if (_activeProduct == null) return;
    final lower = shadeName.toLowerCase();
    final index = _activeProduct!.shades.indexWhere(
      (s) => s.name.toLowerCase().contains(lower),
    );
    if (index != -1) {
      switchShade(index, fromVoice: true);
    }
  }

  // ─── Silent Mode & Text Submission ────────────────────────────────────────
  Future<void> submitTextQuery([String? customText]) async {
    final query = (customText ?? textController.text).trim();
    if (query.isEmpty) return;

    textController.clear();
    focusNode.unfocus();

    // Ensure we are in silent mode for text chats
    _mode = MiaInteractionMode.silent;

    _messages.add(
      MiaMessage(
        id: 'msg_u_${DateTime.now().millisecondsSinceEpoch}',
        sender: MiaSender.user,
        text: query,
        timestamp: DateTime.now(),
        isVoice: false,
      ),
    );

    _isAITyping = true;
    notifyListeners();

    // Check if query is an Instagram link
    if (query.toLowerCase().contains('instagram.com') ||
        query.toLowerCase().contains('instagr.am')) {
      await parseInstagramUrl(query);
      _isAITyping = false;
      notifyListeners();
      return;
    }

    final response = await _engine.processQuery(
      query: query,
      isVoice: false,
      currentProduct: _activeProduct,
    );

    if (response.product != null) {
      _activeProduct = response.product;
    }
    if (response.ingredientAnalysis != null) {
      _activeIngredientAnalysis = response.ingredientAnalysis;
    }

    _messages.add(response);
    _isAITyping = false;
    notifyListeners();
  }

  // ─── Instagram Link & Ingredient Parser (Mock Flow) ───────────────────────
  Future<void> pasteAndParseInstagramFromClipboard() async {
    String clipboardUrl = '';
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null &&
          (clipboardData!.text!.contains('instagram.com') ||
              clipboardData.text!.contains('instagr.am'))) {
        clipboardUrl = clipboardData.text!.trim();
      }
    } catch (_) {}

    // Fallback to high-fidelity mock Instagram URL if clipboard didn't have one
    if (clipboardUrl.isEmpty) {
      clipboardUrl =
          'https://www.instagram.com/reel/C3x9L7vM_evermi_lip_breakdown/';
    }

    await parseInstagramUrl(clipboardUrl);
  }

  Future<void> parseInstagramUrl(String url) async {
    _isParsingInstagram = true;
    _instagramExtractionStatus =
        'Reading post contents & analyzing ingredients...';
    notifyListeners();

    // Simulate realistic multi-stage extraction loader
    await Future.delayed(const Duration(milliseconds: 600));
    _instagramExtractionStatus =
        'Scanning OCR frames for INCI ingredient list...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _instagramExtractionStatus =
        'Evaluating dermatological safety & comedogenic indices...';
    notifyListeners();

    final analysis = await _engine.parseInstagramUrl(url);

    _activeIngredientAnalysis = analysis;
    if (analysis.matchedProduct != null) {
      _activeProduct = analysis.matchedProduct;
    }

    _messages.add(
      MiaMessage(
        id: 'msg_ig_${DateTime.now().millisecondsSinceEpoch}',
        sender: MiaSender.mia,
        text:
            'Extracted INCI breakdown from Instagram post by ${analysis.authorHandle}. Overall safety score: ${analysis.overallSafetyScore}%.',
        timestamp: DateTime.now(),
        isVoice: false,
        ingredientAnalysis: analysis,
        product: _activeProduct,
        suggestedFollowUps: const [
          'Show me Honey Shade',
          'Switch to Berry Burst',
          'Is this safe for sensitive lips?',
        ],
      ),
    );

    _isParsingInstagram = false;
    notifyListeners();
  }

  void clearIngredientAnalysis() {
    _activeIngredientAnalysis = null;
    notifyListeners();
  }

  void resetCanvas() async {
    _activeIngredientAnalysis = null;
    _activeProduct = await _engine.getFeaturedLipstickProduct();
    _messages.clear();
    _initialize();
    notifyListeners();
  }

  @override
  void dispose() {
    _listeningSimulationTimer?.cancel();
    _audioRippleTimer?.cancel();
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
