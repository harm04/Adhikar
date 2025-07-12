import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/nyaysahayak/widget/chat_bubble.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class NyaysahayakChat extends ConsumerStatefulWidget {
  const NyaysahayakChat({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NyaysahayakChatState();
}

class _NyaysahayakChatState extends ConsumerState<NyaysahayakChat> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  String typingText = '';
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;
  bool isTyping = false;
  bool userScrolledUp = false;

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
  bool isSpeakerOn = false;
  final FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    super.initState();

    // Set up scroll controller listener
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        // Check if user has scrolled away from bottom (more than 200 pixels)
        userScrolledUp = scrollController.position.pixels > 200;
      }
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
    messageController.dispose();
    scrollController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  // send message
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    String userMessage = messageController.text.trim();

    // Clear the message field immediately
    messageController.clear();

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

    // Store initial scroll position to check if user was at bottom when typing started
    bool wasAtBottom =
        scrollController.hasClients && scrollController.position.pixels <= 100;

    // Use a different approach: update text in chunks to allow smooth scrolling
    const int chunkSize = 5; // Update every 5 characters
    for (int i = 0; i < aiResponse.length; i += chunkSize) {
      await Future.delayed(const Duration(milliseconds: 90)); // 18ms * 5 = 90ms

      int endIndex = (i + chunkSize > aiResponse.length)
          ? aiResponse.length
          : i + chunkSize;
      setState(() {
        typingText = aiResponse.substring(0, endIndex);
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

    // Only auto-scroll to bottom at the end if user was at bottom when typing started
    // and hasn't scrolled away during typing
    if (wasAtBottom &&
        scrollController.hasClients &&
        scrollController.position.pixels <= 200) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    // Reset scroll state for next message
    userScrolledUp = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NyaySahayak Chat')),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: ListView(
                controller: scrollController,
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send, color: Pallete.whiteColor),
                        onPressed: sendMessage,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
