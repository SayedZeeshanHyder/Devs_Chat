# Devs Chat

A powerful, customizable Flutter chat UI package with seamless Firebase Firestore integration.

[![pub package](https://img.shields.io/pub/v/devs_chat.svg)](https://pub.dev/packages/devs_chat)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-support-yellow.svg)](https://www.buymeacoffee.com/thelegend101)

## 🌟 Features

- **Real-time Messaging** - Instant chat updates via Firebase Firestore
- **Beautiful UI** - Pre-designed chat cards and app bars
- **Highly Customizable** - Flexible styling and behavior options
- **Easy Integration** - Minimal setup required
- **Responsive Design** - Works across all screen sizes

---

## 📦 Installation

Add devs_chat to your pubspec.yaml:

```yaml
dependencies:
  devs_chat: ^0.0.3
```

Run:

```bash
flutter pub get
```

---

## 🔧 Setup

### 1. Firebase Initialization

Initialize Firebase in your app:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

### 2. Required Firebase Dependencies

Make sure these packages are in your pubspec.yaml:

```yaml
dependencies:
  firebase_core: ^2.0.0
  cloud_firestore: ^4.0.0
```

---

## 🚀 Quick Start

Add `DevsChatScreen` to your widget tree:

```dart
DevsChatScreen(
  collectionName: "chats",        // Firestore collection
  userIdKey: 'userId',            // Field name for user ID
  messageKey: 'message',          // Field name for message text
  chatCardType: ChatCardType.simpleChatCard,  // Chat bubble style
  myUserId: 'user1',              // Current user ID
  oppUserId: 'user2',             // Other user ID
  chatListKey: 'chats',           // Field storing message array
)
```

This minimal setup creates a fully functioning chat UI that saves and displays messages from Firestore.

---

## 💬 Chat Screen Options

### Essential Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `collectionName` | `String` | Firestore collection name for chats |
| `userIdKey` | `String` | Field name identifying message sender |
| `messageKey` | `String` | Field name for message content |
| `myUserId` | `String` | ID of current user |
| `oppUserId` | `String` | ID of chat partner |
| `chatListKey` | `String` | Field name for messages array in document |

### Chat Card Customization

| Parameter | Type | Description |
|-----------|------|-------------|
| `chatCardType` | `ChatCardType?` | Predefined chat bubble style |
| `chatCardWidget` | `Widget?` | Custom chat bubble widget |
| `myMessageDecoration` | `BoxDecoration?` | Decoration for current user's messages |
| `otherMessageDecoration` | `BoxDecoration?` | Decoration for other user's messages |
| `myMessageTextStyle` | `TextStyle?` | Text style for current user's messages |
| `otherMessageTextStyle` | `TextStyle?` | Text style for other user's messages |
| `chatCardPadding` | `EdgeInsetsGeometry?` | Padding within chat bubbles |
| `chatCardMargin` | `EdgeInsetsGeometry?` | Margin around chat bubbles |
| `chatCardMaxWidth` | `double?` | Maximum width for chat bubbles |
| `timestampBuilder` | `Widget Function(DateTime)?` | Custom timestamp display builder |

### App Bar Customization

| Parameter | Type | Description |
|-----------|------|-------------|
| `appBarType` | `ChatAppBarType?` | Predefined app bar style |
| `appBarWidget` | `PreferredSizeWidget?` | Custom app bar widget |
| `appBarTitle` | `String?` | Title text for app bar |
| `appBarSubtitle` | `String?` | Subtitle text for app bar |
| `appBarAvatar` | `ImageProvider?` | Avatar image for app bar |
| `appBarBackgroundColor` | `Color?` | Background color for app bar |
| `appBarTextColor` | `Color?` | Text color for app bar |
| `appBarActions` | `List<Widget>?` | Action buttons for app bar |
| `showBackButton` | `bool` | Whether to show back button (default: true) |
| `onBackPressed` | `VoidCallback?` | Action when back button is pressed |

### Input Field Customization

| Parameter | Type | Description |
|-----------|------|-------------|
| `inputFieldType` | `InputFieldType?` | Predefined input field style |
| `customInputField` | `Widget?` | Custom input field widget |
| `inputHintText` | `String?` | Placeholder text for input field |
| `sendButtonWidget` | `Widget?` | Custom send button widget |
| `attachmentButtonWidget` | `Widget?` | Custom attachment button widget |
| `voiceButtonWidget` | `Widget?` | Custom voice button widget |
| `onAttachmentPressed` | `Function()?` | Action when attachment button is pressed |
| `onVoicePressed` | `Function()?` | Action when voice button is pressed |
| `inputDecoration` | `BoxDecoration?` | Custom decoration for input field |
| `inputBackgroundColor` | `Color?` | Background color for input field |
| `inputPadding` | `EdgeInsetsGeometry?` | Padding within input field |
| `inputMargin` | `EdgeInsetsGeometry?` | Margin around input field |
| `showAttachmentButton` | `bool` | Whether to show attachment button (default: false) |
| `showVoiceButton` | `bool` | Whether to show voice button (default: false) |

### Background Customization

| Parameter | Type | Description |
|-----------|------|-------------|
| `chatBackgroundColor` | `Color?` | Background color for chat area |
| `chatBackgroundImage` | `ImageProvider<Object>?` | Background image for chat area |

### List Layout Customization

| Parameter | Type | Description |
|-----------|------|-------------|
| `reverseList` | `bool` | Whether to reverse chat list (default: true) |
| `listPadding` | `EdgeInsetsGeometry?` | Padding around chat list |
| `showScrollToBottomButton` | `bool` | Whether to show scroll-to-bottom button (default: false) |
| `scrollToBottomButtonWidget` | `Widget?` | Custom scroll-to-bottom button widget |
| `scrollController` | `ScrollController?` | Custom scroll controller for the list |

### Optional Configuration

| Parameter | Type | Description |
|-----------|------|-------------|
| `documentId` | `String?` | Custom document ID (auto-generated if null) |
| `timestampKey` | `String?` | Field name for message timestamp |
| `onSendMessageButtonPressed` | `void Function(Map<String, dynamic>)?` | Callback after message is sent |
| `onMessageReceived` | `void Function(Map<String, dynamic>)?` | Callback when new message is received |

---

## 🎨 Available Styles

### Chat Card Types

- **ChatCardType.simpleChatCard**  
  Clean, minimal chat bubbles with different colors for sender/receiver

  ```dart
  chatCardType: ChatCardType.simpleChatCard
  ```

- **ChatCardType.gradientChatCard**  
  Stylish gradient background chat bubbles

  ```dart
  chatCardType: ChatCardType.gradientChatCard
  ```

- **ChatCardType.customChatCard**  
  For advanced customization needs

### App Bar Types

- **ChatAppBarType.defaultAppBar**  
  Standard chat app bar with user info and avatar

  ```dart
  appBarType: ChatAppBarType.defaultAppBar
  ```

- **ChatAppBarType.gradientAppBar**  
  App bar with gradient background effect

  ```dart
  appBarType: ChatAppBarType.gradientAppBar
  ```

### Input Field Types

- **InputFieldType.defaultInput**  
  Standard input field with send button

  ```dart
  inputFieldType: InputFieldType.defaultInput
  ```

- **InputFieldType.richInput**  
  Enhanced input field with attachment and voice options

  ```dart
  inputFieldType: InputFieldType.richInput
  ```

---

## 📋 Complete Example

```dart
import 'package:devs_chat/devs_chat.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DevsChatScreen(
        // Required parameters
        collectionName: "chats",
        userIdKey: 'userId',
        messageKey: 'message',
        myUserId: 'user1',
        oppUserId: 'user2',
        chatListKey: 'chats',
        
        // Chat card customization
        chatCardType: ChatCardType.simpleChatCard,
        myMessageDecoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
        ),
        otherMessageDecoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        myMessageTextStyle: TextStyle(color: Colors.black87),
        otherMessageTextStyle: TextStyle(color: Colors.black87),
        chatCardPadding: EdgeInsets.all(12),
        chatCardMargin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        chatCardMaxWidth: 280,
        
        // App bar customization
        appBarType: ChatAppBarType.defaultAppBar,
        appBarTitle: "John Doe",
        appBarSubtitle: "Online",
        appBarAvatar: NetworkImage("https://example.com/avatar.jpg"),
        appBarBackgroundColor: Colors.blue,
        appBarTextColor: Colors.white,
        appBarActions: [
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {},
          ),
        ],
        
        // Input field customization
        inputFieldType: InputFieldType.richInput,
        inputHintText: "Message...",
        inputBackgroundColor: Colors.grey[100],
        inputPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        inputMargin: EdgeInsets.all(8),
        showAttachmentButton: true,
        showVoiceButton: true,
        onAttachmentPressed: () {
          print("Attachment button pressed");
        },
        onVoicePressed: () {
          print("Voice button pressed");
        },
        
        // Background customization
        chatBackgroundColor: Colors.white,
        
        // List layout customization
        reverseList: true,
        listPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        showScrollToBottomButton: true,
        
        // Optional configuration
        timestampKey: 'timestamp',
        onSendMessageButtonPressed: (Map<String, dynamic> message) {
          print("Message sent: ${message['message']}");
        },
        onMessageReceived: (Map<String, dynamic> message) {
          print("Message received: ${message['message']}");
        },
      ),
    );
  }
}
```

---

## 🗄️ Firestore Structure

### Document Format

The package expects your Firestore documents to follow this structure:

```json
{
  "chats": [  // Value of chatListKey
    {
      "userId": "user1",  // Value of userIdKey (sender ID)
      "message": "Hello!",  // Value of messageKey (content)
      "timestamp": "2023-06-15T10:30:00.000Z"  // Value of timestampKey
    },
    {
      "userId": "user2",
      "message": "Hi there!",
      "timestamp": "2023-06-15T10:31:00.000Z"
    }
  ]
}
```

### Document ID Generation

If `documentId` is not provided, it will be generated by combining the user IDs (ordered by hash code):

```dart
if (myUserId.hashCode > oppUserId.hashCode) {
  documentId = "$myUserId$oppUserId";
} else {
  documentId = "$oppUserId$myUserId";
}
```

This ensures the same two users always share the same chat document.

---

## 🛠️ Advanced Customization

### Custom Chat Card

Create your own chat bubble design:

```dart
DevsChatScreen(
  // Other parameters...
  chatCardWidget: (context, message, isMe) => Container(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
      color: isMe ? Colors.blue[100] : Colors.grey[200],
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          message[messageKey],
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          // Format timestamp
          DateFormat('hh:mm a').format(message[timestampKey].toDate()),
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    ),
  ),
)
```

### Custom Timestamp Display

Create your own timestamp format:

```dart
DevsChatScreen(
  // Other parameters...
  timestampBuilder: (timestamp) => Padding(
    padding: EdgeInsets.only(top: 4),
    child: Text(
      DateFormat('MMM d, h:mm a').format(timestamp),
      style: TextStyle(
        fontSize: 10,
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    ),
  ),
)
```

### Custom Send Button

Create your own send button:

```dart
DevsChatScreen(
  // Other parameters...
  sendButtonWidget: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.purple],
      ),
      shape: BoxShape.circle,
    ),
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Icon(
        Icons.send,
        color: Colors.white,
      ),
    ),
  ),
)
```

### Custom Scroll-to-Bottom Button

```dart
DevsChatScreen(
  // Other parameters...
  showScrollToBottomButton: true,
  scrollToBottomButtonWidget: Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.8),
      shape: BoxShape.circle,
    ),
    child: Icon(
      Icons.keyboard_arrow_down,
      color: Colors.white,
      size: 28,
    ),
  ),
)
```

---

## ⚠️ Common Issues & Troubleshooting

### Messages Not Appearing

- Check that Firebase is properly initialized
- Verify your Firestore security rules allow read/write
- Ensure collection and document paths are correct

### Styling Conflicts

- Don't use both `chatCardType` and `chatCardWidget` simultaneously
- Don't use both `chatBackgroundColor` and `chatBackgroundImage` together
- Don't use both `inputFieldType` and `customInputField` together

### Message Order

- Messages are displayed with the most recent at the bottom by default (when `reverseList` is true)
- If order is wrong, check your `timestampKey` field is correctly set

### Performance

- For large chat histories, consider pagination (coming in future releases)
- If scrolling performance is poor, try setting a smaller `chatCardMaxWidth` value

### Input Field Issues

- If custom input decorations aren't appearing, ensure they don't conflict with the `inputFieldType`
- For custom input actions, use the `onAttachmentPressed` and `onVoicePressed` callbacks

---

## 🧩 Widget Hierarchy

```
DevsChatScreen
  ├── AppBar/Custom AppBarWidget
  ├── Container (Background)
  │   └── Column
  │       ├── StreamBuilder (Firestore stream)
  │       │   └── Stack
  │       │       ├── ListView.builder
  │       │       │   └── ChatCard/Custom ChatCardWidget
  │       │       └── ScrollToBottomButton (if enabled)
  │       └── ChatInputField/CustomInputField
  └── FloatingActionButton (Send button)
```

---

## 🤝 Contributing

Contributions are welcome! If you'd like to contribute:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Sayed Zeeshan Hyder**

- GitHub: [SayedZeeshanHyder](https://github.com/SayedZeeshanHyder)
- Buy Me a Coffee: [zeeshanhyder](https://buymeacoffee.com/thelegend101)