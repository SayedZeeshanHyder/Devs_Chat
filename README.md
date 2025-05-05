
# Devs Chat

A powerful, customizable Flutter chat UI package with seamless Firebase Firestore integration.

[![pub package](https://img.shields.io/pub/v/devs_chat.svg)](https://pub.dev/packages/devs_chat)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<a href="https://buymeacoffee.com/thelegend101" ><img src="https://www.buymeacoffee.com/assets/img/guidelines/download-assets-1.svg" width="150" height="75"/> </a>


## 🌟 Features

- **Real-time Messaging** - Instant chat updates via Firebase Firestore
- **Beautiful UI** - Pre-designed chat cards and app bars
- **Highly Customizable** - Flexible styling and behavior options
- **Easy Integration** - Minimal setup required
- **Responsive Design** - Works across all screen sizes

---
Chat Card Types
<table>
  <tr>
    <td align="center">
      <img src="https://i.ibb.co/WWkrYksL/Modern-Chat-Card.jpg" width="200"/><br>
      <sub>Modern Chat Card</sub>
    </td>
    <td align="center">
      <img src="https://i.ibb.co/3yXjtsj2/Material-Chat-Card.jpg" width="200"/><br>
      <sub>Material Chat Card</sub>
    </td>
    <td align="center">
      <img src="https://i.ibb.co/VckQyhmZ/IOSStyled.jpg" width="200"/><br>
      <sub>IOS Chat Card</sub>
    </td>
    <td align="center">
      <img src="https://i.ibb.co/dwNPd2nh/Gradient-Chat-Card.jpg" width="200"/><br>
      <sub>Gradient Chat Card</sub>
    </td>
    <td align="center">
      <img src="https://i.ibb.co/WwYPVx7/Cardchatcard.jpg" width="200"/><br>
      <sub>Card Chat Card</sub>
    </td>
    <td align="center">
      <img src="https://i.ibb.co/jZyQHFKd/Background-Image.jpg" width="200"/><br>
      <sub>Chat Background</sub>
    </td>
  </tr>
</table>

Other Features
<table>
  <tr>
    <td align="center">
      <img src="https://i.ibb.co/pjFdP4Q5/Link.jpg" width="200"/><br>
      <sub>Message Links</sub>
    </td>
    <td align="center">
      <img src="https://i.ibb.co/QjTpNnhT/Voice-Button.jpg" width="200"/><br>
      <sub>Voice Chat TextField</sub>
    </td>
    <td align="center">
      <img src="https://i.ibb.co/5Xr94Gmq/Document-Button.jpg" width="200"/><br>
      <sub>Document Adding Text Field</sub>
    </td>
    <td align="center">
      <img src="https://i.ibb.co/1tCtFm2m/Gradient-App-Bar.jpg" width="200"/><br>
      <sub>Gradient App Bar</sub>
    </td>
  </tr>
</table>

## 📦 Installation

Add devs_chat to your pubspec.yaml:

```yaml
dependencies:
  devs_chat: ^0.0.4
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
appBar: ChatAppBarType.defaultAppBar,  // App bar style
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

### UI Customization

| Parameter | Type | Description |
|-----------|------|-------------|
| `chatCardType` | `ChatCardType?` | Predefined chat bubble style |
| `chatCardWidget` | `Widget?` | Custom chat bubble widget |
| `appBar` | `ChatAppBarType?` | Predefined app bar style |
| `appBarWidget` | `PreferredSizeWidget?` | Custom app bar widget |
| `chatBackgroundColor` | `Color?` | Background color for chat area |
| `chatBackgroundImage` | `ImageProvider<Object>?` | Background image for chat area |
| `sendMessageButtonWidget` | `Widget?` | Custom send button widget |

### Optional Configuration

| Parameter | Type | Description |
|-----------|------|-------------|
| `documentId` | `String?` | Custom document ID (auto-generated if null) |
| `timestampKey` | `String?` | Field name for message timestamp |
| `onSendMessageButtonPressed` | `void Function(Map)?` | Callback after message is sent |

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
  appBar: ChatAppBarType.defaultAppBar
  ```

- **ChatAppBarType.gradientAppBar**  
  App bar with gradient background effect

  ```dart
  appBar: ChatAppBarType.gradientAppBar
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

        // UI customization
        chatCardType: ChatCardType.simpleChatCard,
        appBar: ChatAppBarType.defaultAppBar,
        chatBackgroundColor: Colors.grey[100],

        // Optional configuration
        timestampKey: 'timestamp',
        onSendMessageButtonPressed: (Map message) {
          print("Message sent: ${message['message']}");
          // Perform additional actions if needed
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
chatCardWidget: Container(
padding: EdgeInsets.all(10),
margin: EdgeInsets.symmetric(vertical: 5),
decoration: BoxDecoration(
color: Colors.blue[100],
borderRadius: BorderRadius.circular(15),
),
child: Text(
// Your message text
),
),
)
```

### Custom App Bar

Use your own app bar design:

```dart
DevsChatScreen(
// Other parameters...
appBarWidget: AppBar(
title: Row(
children: [
CircleAvatar(
backgroundImage: NetworkImage("https://example.com/avatar.jpg"),
),
SizedBox(width: 10),
Text("Chat with John"),
],
),
actions: [
IconButton(
icon: Icon(Icons.call),
onPressed: () {
// Handle call action
},
),
],
),
)
```

### Custom Send Button

Create your own send button:

```dart
DevsChatScreen(
// Other parameters...
sendMessageButtonWidget: Container(
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

---

## ⚠️ Common Issues & Troubleshooting

### Messages Not Appearing

- Check that Firebase is properly initialized
- Verify your Firestore security rules allow read/write
- Ensure collection and document paths are correct

### Styling Conflicts

- Don't use both `chatCardType` and `chatCardWidget` simultaneously
- Don't use both `chatBackgroundColor` and `chatBackgroundImage` together

### Message Order

- Messages are displayed with the most recent at the bottom
- If order is wrong, check your `timestampKey` field

### Performance

- For large chat histories, consider pagination (coming in future releases)

---

## 🧩 Widget Hierarchy

```
DevsChatScreen
  ├── AppBar/Custom AppBarWidget
  ├── Container (Background)
  │   └── Column
  │       ├── StreamBuilder (Firestore stream)
  │       │   └── ListView.builder
  │       │       └── ChatCard/Custom ChatCardWidget
  │       └── TextField (Message input)
  └── FloatingActionButton (Send button)
```

---

## 🗺️ Roadmap

Future features planned:
- Image/file attachments
- Voice messages
- Read receipts
- Typing indicators
- Emoji reactions
- Group chat support

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
