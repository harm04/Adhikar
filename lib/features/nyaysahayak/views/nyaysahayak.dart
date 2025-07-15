import 'dart:io';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/nyaysahayak/views/nyaysahayak_chat.dart';
import 'package:adhikar/theme/image_theme.dart';
import 'package:adhikar/theme/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Nyaysahayak extends ConsumerStatefulWidget {
  const Nyaysahayak({super.key});

  @override
  ConsumerState<Nyaysahayak> createState() => _NyaysahayakState();
}

class _NyaysahayakState extends ConsumerState<Nyaysahayak>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  bool isTyping = false;
  String typingText = '';
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;

  XFile? pickedImage;
  File? pickedFile;
  String extractedText = '';
  String summaryText = '';
  bool scanning = false;

  final ImagePicker imagePicker = ImagePicker();
  TextEditingController languageController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  final FocusNode _languageFocusNode = FocusNode();

  // //chat
  // final chatModel = GenerativeModel(
  //   model: 'gemini-2.0-flash',
  //   apiKey: AppwriteConstants.geminiApi,
  //   generationConfig: GenerationConfig(temperature: 0.7, topP: 0.9),
  // );

  // List<ChatBubble> chatBubbles = [
  //   const ChatBubble(
  //     direction: Direction.left,
  //     message:
  //         'Hello, I am Nyaysahayak. How can I assist you solve legal trouble?',
  //     photoUrl: 'https://i.pravatar.cc/150?img=47',
  //     type: BubbleType.alone,
  //   ),
  // ];

  // List<Content> chatHistory = [
  //   Content.text(
  //     "You are NyaySahayak, an AI legal assistant specializing in Indian law."
  //     "Your role is to provide clear, direct, and actionable legal solutions based strictly on the Indian Constitution and the Bharatiya Nyay Sanhita."
  //     "Always respond concisely with legal references and practical steps the user can take."
  //     "Your responses should be structured as follows:"
  //     "1. Relevant legal articles, sections, or precedents related to the user's issue."
  //     "2. Specific legal actions the user can take (filing complaints, contacting authorities, necessary documents, etc.)."
  //     "Avoid generic advice like 'stay calm' and focus on tangible legal remedies."
  //     "Respond in English",
  //   ),
  // ];

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

  @override
  void initState() {
    super.initState();

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
    languageController.dispose();
    _languageFocusNode.dispose();
    flutterTts.stop();
    super.dispose();
  }

  // // send message
  // Future<void> sendMessage() async {
  //   if (messageController.text.trim().isEmpty) return;

  //   String userMessage = messageController.text.trim();

  //   setState(() {
  //     chatBubbles = [
  //       ...chatBubbles,
  //       ChatBubble(
  //         direction: Direction.right,
  //         message: userMessage,
  //         photoUrl: null,
  //         type: BubbleType.alone,
  //       ),
  //     ];
  //     isLoading = true;
  //     isTyping = true;
  //     typingText = '';
  //   });

  //   chatHistory.add(Content.text("User: $userMessage"));

  //   try {
  //     final responseAI = await chatModel.generateContent(chatHistory);
  //     String aiResponse =
  //         responseAI.text?.replaceAll('*', '') ??
  //         'Sorry, I didn’t understand that.';

  //     //suggest Expert if query is complex
  //     if (aiResponse.length > 700 ||
  //         aiResponse.contains('legal advice') ||
  //         aiResponse.contains('consult')) {
  //       aiResponse +=
  //           "\n\n*If your query is complex or you need personalized legal help, please consult an expert using the 'Expert' tab in the Adhikar app.*";
  //     }

  //     chatHistory.add(Content.text("AI: $aiResponse"));

  //     // Typing animation
  //     await _showTypingAnimation(aiResponse);
  //   } catch (e) {
  //     String errorMsg = 'An error occurred. Please try again.';
  //     if (e.toString().contains('model is overloaded') ||
  //         e.toString().contains('Server Error [503]')) {
  //       errorMsg = 'The AI service is busy. Please try again later.';
  //     }
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text(errorMsg)));
  //     print('Error during message processing: $e');
  //     setState(() {
  //       isTyping = false;
  //     });
  //   } finally {
  //     messageController.clear();
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> _showTypingAnimation(String aiResponse) async {
  //   setState(() {
  //     typingText = '';
  //     isTyping = true;
  //   });
  //   for (int i = 0; i < aiResponse.length; i++) {
  //     await Future.delayed(const Duration(milliseconds: 18));
  //     setState(() {
  //       typingText = aiResponse.substring(0, i + 1);
  //     });
  //   }
  //   setState(() {
  //     chatBubbles = [
  //       ...chatBubbles,
  //       ChatBubble(
  //         direction: Direction.left,
  //         message: aiResponse,
  //         photoUrl: 'https://i.pravatar.cc/150?img=47',
  //         type: BubbleType.alone,
  //       ),
  //     ];
  //     isTyping = false;
  //     typingText = '';
  //   });
  // }

  // Speech to Text for Chat

  // Document
  Future<void> pickFile() async {
    // Check if language is selected
    if (languageController.text.isEmpty) {
      showSnackbar(
        context,
        'Please select a language before uploading a document.',
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        String extension = result.files.single.extension?.toLowerCase() ?? '';

        setState(() {
          pickedFile = file;
          pickedImage = null; // Reset image for display
        });

        if (['jpg', 'jpeg', 'png'].contains(extension)) {
          // Handle image files
          setState(() {
            pickedImage = XFile(file.path);
          });
          await performTextRecognition();
        } else if (extension == 'pdf') {
          // Handle PDF files
          await performPdfTextExtraction();
        }
      }
    } catch (e) {
      showSnackbar(context, 'Error picking file: $e');
    }
  }

  // Method to reset and start new document upload
  void startNewDocument() {
    setState(() {
      pickedFile = null;
      pickedImage = null;
      extractedText = '';
      summaryText = '';
      languageController.clear();
      scanning = false;
    });
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

  // PDF text extraction method
  Future<void> performPdfTextExtraction() async {
    setState(() {
      scanning = true;
      summaryText = '';
      extractedText = '';
    });

    try {
      final bytes = await pickedFile!.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      String pdfText = '';
      PdfTextExtractor extractor = PdfTextExtractor(document);
      pdfText = extractor.extractText();

      document.dispose();

      setState(() {
        extractedText = pdfText.trim();
        scanning = false;
      });

      if (extractedText.isNotEmpty) {
        await generateSummary();
      } else {
        showSnackbar(context, 'No text found in the PDF document.');
        setState(() {
          scanning = false;
        });
      }
    } catch (e) {
      setState(() {
        scanning = false;
      });
      showSnackbar(context, 'Failed to extract text from PDF: $e');
      print('Error during PDF text extraction: $e');
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
    if (isSpeakerOn) {
      // If currently speaking, stop the speech
      await flutterTts.stop();
      setState(() {
        isSpeakerOn = false;
      });
    } else {
      // If not speaking, start the speech
      if (summaryText.isNotEmpty) {
        setState(() {
          isSpeakerOn = true;
        });
        await flutterTts.setLanguage("en-IN");
        await flutterTts.setSpeechRate(0.5);
        await flutterTts.speak(summaryText);
      }
    }
  }

  // Language picker method
  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Select Language',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: languages.length,
                      itemBuilder: (context, index) {
                        final language = languages[index];
                        return ListTile(
                          title: Text(
                            language,
                            style: TextStyle(color: context.textPrimaryColor),
                          ),
                          onTap: () {
                            setState(() {
                              languageController.text = language;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/svg/chat.svg',
              color: context.iconPrimaryColor,
              height: 25,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NyaysahayakChat();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              // Show language picker and upload button only if no document is processed
              if (pickedFile == null && summaryText.isEmpty) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: context.secondaryColor),
                            color: context.surfaceColor,
                          ),
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              _showLanguagePicker();
                            },
                            child: Container(
                              height: 55,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      languageController.text.isEmpty
                                          ? 'Select your language'
                                          : languageController.text,
                                      style: TextStyle(
                                        color: languageController.text.isEmpty
                                            ? context.textHintColor
                                            : context.textPrimaryColor,
                                        fontSize:
                                            languageController.text.isEmpty
                                            ? 14
                                            : 16,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: context.iconPrimaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: GestureDetector(
                          onTap: () => pickFile(),
                          child: Card(
                            elevation: 4,
                            color: languageController.text.isEmpty
                                ? context.surfaceColor
                                : context.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Upload Document',
                                style: TextStyle(
                                  color: languageController.text.isEmpty
                                      ? context.textSecondaryColor
                                      : context.textPrimaryColor,
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
              ],

              // Show "New Document" button if a document has been processed
              if (pickedFile != null || summaryText.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  height: 55,
                  child: GestureDetector(
                    onTap: startNewDocument,
                    child: Card(
                      elevation: 4,
                      color: context.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: context.textPrimaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'New Document',
                              style: TextStyle(
                                color: context.textPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),

              scanning
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView(
                        children: [
                          if (pickedFile != null) ...[
                            SizedBox(height: 10),
                            pickedFile!.path.toLowerCase().endsWith('.pdf')
                                ? Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: context.surfaceColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: context.secondaryColor,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          pickedFile!.path
                                                  .toLowerCase()
                                                  .endsWith('.pdf')
                                              ? Icons.picture_as_pdf
                                              : Icons.image,
                                          color:
                                              pickedFile!.path
                                                  .toLowerCase()
                                                  .endsWith('.pdf')
                                              ? Colors.red
                                              : context.iconPrimaryColor,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Selected File:',
                                                style: TextStyle(
                                                  color: context
                                                      .textSecondaryColor,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                pickedFile!.path
                                                    .split('/')
                                                    .last,
                                                style: TextStyle(
                                                  color:
                                                      context.textPrimaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ],
                          if (pickedImage != null &&
                              !pickedFile!.path.toLowerCase().endsWith(
                                '.pdf',
                              )) ...[
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

                          SizedBox(height: 20),
                          if (summaryText.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Summary:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: context.textPrimaryColor,
                                        ),
                                      ),
                                      if (languageController
                                          .text
                                          .isNotEmpty) ...[
                                        Text(
                                          "Language: ${languageController.text}",
                                          style: TextStyle(
                                            color: context.textSecondaryColor,
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: speakSummary,
                                  child: Icon(
                                    isSpeakerOn
                                        ? Icons.volume_up_rounded
                                        : Icons.volume_off_rounded,
                                    color: isSpeakerOn
                                        ? context.successColor
                                        : context.iconSecondaryColor,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                summaryText,
                                style: TextStyle(
                                  color: context.textPrimaryColor,
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
    );
  }
}
