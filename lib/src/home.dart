import 'dart:math';

import 'package:flutter/material.dart';

import 'context.dart';
import 'migration.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔥 Heads Up, Flutter FCM Users! 🔥')),
      body: Center(
        child: SizedBox(
          width: min(600, context.width),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWarningCard(
                    '🚨 Google has officially disabled the Legacy Cloud Messaging API!',
                  ),
                  const SizedBox(height: 10),
                  _buildRichText(
                    'If you’re still using the old HTTP or XMPP APIs (deprecated since ',
                    boldText: 'June 20, 2023',
                    afterBoldText:
                        '), you must migrate to Firebase Cloud Messaging ',
                    boldText2: 'HTTP v1',
                    afterBoldText2: ' before ',
                    boldText3: 'June 20, 2024!',
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('⚠️ The Big Change:'),
                  _buildRichText(
                    'You can’t use the FCM ',
                    boldText: 'server key',
                    afterBoldText:
                        ' directly in your Flutter project anymore. '
                        'Instead, you need to generate an ',
                    boldText2: 'access token',
                    afterBoldText2:
                        ' to authenticate your requests. '
                        'And let’s be real—getting this token can be a ',
                    boldText3: 'confusing mess 😵‍💫.',
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('💡 The Easy Solution:'),
                  _buildRichText(
                    'What if you could just ',
                    boldText: 'upload your Firebase service account JSON',
                    afterBoldText:
                        ' and get your access token in seconds? 🚀 No more headaches, no more manual setup—just ',
                    boldText2: 'drop your JSON file',
                    afterBoldText2: ' and grab your token instantly!',
                  ),
                  const SizedBox(height: 20),
                  _buildRichText(
                    'Simply ',
                    boldText: 'drag & drop',
                    afterBoldText:
                        ' your Firebase service account JSON file below, or ',
                    boldText2: 'click to browse',
                    afterBoldText2: ' and upload it manually.',
                  ),
                  const SizedBox(height: 20),
                  FcmMigrationScreen(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWarningCard(String text) {
    return Center(
      child: Card(
        color: Colors.red.shade100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRichText(
    String normalText, {
    String? boldText,
    String? afterBoldText,
    String? boldText2,
    String? afterBoldText2,
    String? boldText3,
  }) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(text: normalText),
          if (boldText != null)
            TextSpan(
              text: boldText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          if (afterBoldText != null) TextSpan(text: afterBoldText),
          if (boldText2 != null)
            TextSpan(
              text: boldText2,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          if (afterBoldText2 != null) TextSpan(text: afterBoldText2),
          if (boldText3 != null)
            TextSpan(
              text: boldText3,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
