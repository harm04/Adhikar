import 'dart:io';

import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/nyaysahayak/widget/chat_bubble.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Nyaysahayak extends ConsumerStatefulWidget {
  const Nyaysahayak({super.key});

  @override
  ConsumerState<Nyaysahayak> createState() => _NyaysahayakState();
}

class _NyaysahayakState extends ConsumerState<Nyaysahayak>
    with SingleTickerProviderStateMixin {
  TextEditingController messageController = TextEditingController();
  bool isLoading = false;
  bool isTyping = false;
  String typingText = '';
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;

  XFile? pickedImage;
  String extractedText = '';
  String summaryText = '';
  bool scanning = false;

  final ImagePicker imagePicker = ImagePicker();
  TextEditingController languageController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();

  //chat
  final chatModel = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: AppwriteConstants.geminiApi,
    generationConfig: GenerationConfig(temperature: 0.7, topP: 0.9),
  );

  List<ChatBubble> chatBubbles = [
    const ChatBubble(
      direction: Direction.left,
      message:
          'Hello, I am Nyaysahayak. How can I assist you solve legal trouble?',
      photoUrl: 'https://i.pravatar.cc/150?img=47',
      type: BubbleType.alone,
    ),
  ];

  List<Content> chatHistory = [
    Content.text(
      "You are NyaySahayak, an AI legal assistant specializing in Indian law."
      "Your role is to provide clear, direct, and actionable legal solutions based strictly on the Indian Constitution and the Bharatiya Nyay Sanhita."
      "Always respond concisely with legal references and practical steps the user can take."
      "Your responses should be structured as follows:"
      "1. Relevant legal articles, sections, or precedents related to the user's issue."
      "2. Specific legal actions the user can take (filing complaints, contacting authorities, necessary documents, etc.)."
      "Avoid generic advice like 'stay calm' and focus on tangible legal remedies."
      "Respond in English",
    ),
  ];

  //Document
  final docModel = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: AppwriteConstants.geminiApi,
    generationConfig: GenerationConfig(temperature: 0.7, topP: 0.9),
  );

  final List<String> languages = [
    "Hindi",
    "Marathi",
    "English",
    "Bengali",
    "Tamil",
    "Telugu",
    "Gujarati",
    "Kannada",
    "Malayalam",
    "Punjabi",
  ];

  bool isSpeakerOn = false;
  late TabController _tabController;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTab = _tabController.index;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeakerOn = false;
      });
    });
    flutterTts.setCancelHandler(() {
      setState(() {
        isSpeakerOn = false;
      });
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        isSpeakerOn = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    languageController.dispose();
    messageController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  // send message
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    String userMessage = messageController.text.trim();

    setState(() {
      chatBubbles = [
        ...chatBubbles,
        ChatBubble(
          direction: Direction.right,
          message: userMessage,
          photoUrl: null,
          type: BubbleType.alone,
        ),
      ];
      isLoading = true;
      isTyping = true;
      typingText = '';
    });

    chatHistory.add(Content.text("User: $userMessage"));

    try {
      final responseAI = await chatModel.generateContent(chatHistory);
      String aiResponse =
          responseAI.text?.replaceAll('*', '') ??
          'Sorry, I didn’t understand that.';

      //suggest Expert if query is complex
      if (aiResponse.length > 700 ||
          aiResponse.contains('legal advice') ||
          aiResponse.contains('consult')) {
        aiResponse +=
            "\n\n*If your query is complex or you need personalized legal help, please consult an expert using the 'Expert' tab in the Adhikar app.*";
      }

      chatHistory.add(Content.text("AI: $aiResponse"));

      // Typing animation
      await _showTypingAnimation(aiResponse);
    } catch (e) {
      String errorMsg = 'An error occurred. Please try again.';
      if (e.toString().contains('model is overloaded') ||
          e.toString().contains('Server Error [503]')) {
        errorMsg = 'The AI service is busy. Please try again later.';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
      print('Error during message processing: $e');
      setState(() {
        isTyping = false;
      });
    } finally {
      messageController.clear();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showTypingAnimation(String aiResponse) async {
    setState(() {
      typingText = '';
      isTyping = true;
    });
    for (int i = 0; i < aiResponse.length; i++) {
      await Future.delayed(const Duration(milliseconds: 18));
      setState(() {
        typingText = aiResponse.substring(0, i + 1);
      });
    }
    setState(() {
      chatBubbles = [
        ...chatBubbles,
        ChatBubble(
          direction: Direction.left,
          message: aiResponse,
          photoUrl: 'https://i.pravatar.cc/150?img=47',
          type: BubbleType.alone,
        ),
      ];
      isTyping = false;
      typingText = '';
    });
  }

  // Speech to Text for Chat
  Future<void> startListening() async {
    bool available = await speech.initialize(
      onStatus: (val) {
        if (val == 'done' || val == 'notListening') {
          setState(() => isListening = false);
        }
      },
      onError: (val) {
        setState(() => isListening = false);
      },
    );
    if (available) {
      setState(() => isListening = true);
      speech.listen(
        onResult: (val) {
          setState(() {
            messageController.text = val.recognizedWords;
          });
        },
      );
    }
  }

  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  // Document
  Future<void> getImage(ImageSource source) async {
    XFile? result = await imagePicker.pickImage(source: source);
    if (result != null) {
      setState(() {
        pickedImage = result;
      });
      await performTextRecognition();
    }
  }

  Future<void> performTextRecognition() async {
    setState(() {
      scanning = true;
      summaryText = '';
    });
    try {
      final inputImage = InputImage.fromFilePath(pickedImage!.path);
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        extractedText = recognizedText.text;
        scanning = false;
      });

      if (extractedText.isNotEmpty) {
        await generateSummary();
      }
    } catch (e) {
      setState(() {
        scanning = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to extract text from image.')),
      );
      print('Error during recognizing text: $e');
    }
  }

  Future<void> generateSummary() async {
    if (extractedText.trim().isEmpty) return;

    String selectedLanguage = languageController.text.isNotEmpty
        ? languageController.text
        : "English";

    List<Content> docHistory = [
      Content.text(
        "You are NyaySahayak, an AI legal assistant specializing in Indian law and bhartiya nyay Sanhita."
        "Summarize the given legal document accurately."
        "Ensure the response is in $selectedLanguage."
        "Document text: $extractedText",
      ),
    ];

    setState(() {
      scanning = true;
      summaryText = '';
    });

    try {
      final responseAI = await docModel.generateContent(docHistory);
      String aiSummary =
          responseAI.text?.replaceAll('*', '') ??
          'Could not generate a summary.';

      setState(() {
        summaryText = aiSummary;
        scanning = false;
      });
    } catch (e) {
      setState(() {
        scanning = false;
      });
      String errorMsg = 'An error occurred. Please try again.';
      if (e.toString().contains('model is overloaded') ||
          e.toString().contains('Server Error [503]')) {
        errorMsg = 'The AI service is busy. Please try again later.';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
      print('Error during summary generation: $e');
    }
  }

  // Text to Speech for Summary
  Future<void> speakSummary() async {
    if (summaryText.isNotEmpty) {
      setState(() {
        isSpeakerOn = true;
      });
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(summaryText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nyaysahayak'),
          leading: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(ImageTheme.defaultAdhikarLogo),
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Pallete.secondaryColor,
            labelColor: Pallete.secondaryColor,
            unselectedLabelColor: Pallete.whiteColor.withOpacity(0.7),
            labelStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                icon: SvgPicture.asset(
                  'assets/svg/chat.svg',
                  colorFilter: ColorFilter.mode(
                    selectedTab == 0
                        ? Pallete.secondaryColor
                        : Pallete.whiteColor,
                    BlendMode.srcIn,
                  ),
                ),
                text: "Chat",
              ),
              Tab(
                icon: SvgPicture.asset(
                  'assets/svg/scan.svg',
                  colorFilter: ColorFilter.mode(
                    selectedTab == 1
                        ? Pallete.secondaryColor
                        : Pallete.whiteColor,
                    BlendMode.srcIn,
                  ),
                ),
                text: "Document",
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            //chat tab
            Column(
              children: [
                Expanded(
                  child: SizedBox(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      padding: const EdgeInsets.all(10),
                      children: [
                        if (isTyping && typingText.isNotEmpty)
                          ChatBubble(
                            direction: Direction.left,
                            message: typingText,
                            photoUrl: 'https://i.pravatar.cc/150?img=47',
                            type: BubbleType.alone,
                          ),
                        ...chatBubbles.reversed,
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Pallete.searchBarColor,
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          isListening ? stopListening : startListening();
                          setState(() {
                            isListening = !isListening;
                          });
                        },

                        child: SvgPicture.asset(
                          isListening
                              ? 'assets/svg/mic_filled.svg'
                              : 'assets/svg/mic_outline.svg',
                          colorFilter: ColorFilter.mode(
                            isListening ? Pallete.whiteColor : Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                          ),
                          minLines: 1,
                          maxLines: 4,
                        ),
                      ),
                      isLoading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: Loader(),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: Pallete.whiteColor,
                              ),
                              onPressed: sendMessage,
                            ),
                    ],
                  ),
                ),
              ],
            ),
            //Document tab
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Pallete.secondaryColor,
                                ),
                                color: Pallete.searchBarColor,
                              ),
                              alignment: Alignment.centerLeft,
                              child: DropDownField(
                                enabled: true,
                                textStyle: const TextStyle(
                                  color: Pallete.whiteColor,
                                  fontSize: 16,
                                ),
                                controller: languageController,
                                hintText: 'Select your language',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                items: languages,
                                itemsVisibleInDropdown: 4,
                                onValueChanged: (value) {
                                  setState(() {
                                    languageController.text = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            child: GestureDetector(
                              onTap: () => getImage(ImageSource.gallery),
                              child: Card(
                                elevation: 4,
                                color: Pallete.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Upload Document',
                                    style: TextStyle(
                                      color: Pallete.whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    scanning
                        ? const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Pallete.whiteColor,
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView(
                              children: [
                                if (pickedImage != null) ...[
                                  SizedBox(height: 10),
                                  SizedBox(
                                    height: 260,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(pickedImage!.path),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                if (extractedText.isNotEmpty) ...[
                                  SizedBox(height: 10),
                                  Text(
                                    "Extracted Text:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      extractedText,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                                SizedBox(height: 20),
                                if (summaryText.isNotEmpty) ...[
                                  Row(
                                    children: [
                                      const Text(
                                        "Summary:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      GestureDetector(
                                        onTap: speakSummary,
                                        child: Icon(
                                          isSpeakerOn
                                              ? Icons.volume_up_rounded
                                              : Icons.volume_off_rounded,
                                          color: isSpeakerOn
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      summaryText,
                                      style: const TextStyle(
                                        color: Pallete.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
