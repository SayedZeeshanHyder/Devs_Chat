/// Defines the various appearance styles for the chat app bar.
///
/// Use these enum values to customize the look and feel of your chat app bar
/// when using the [ChatAppBar] widget.
enum ChatAppBarType {
  /// Default app bar with standard layout and styling
  defaultAppBar,
  
  /// App bar with gradient background color
  gradientAppBar,
  
  /// Compact app bar with reduced height
  compactAppBar,
  
  /// App bar with prominent avatar display
  avatarAppBar,
  
  /// App bar with modern design elements
  modernAppBar,
  
  /// Business-oriented app bar design
  businessAppBar,
  
  /// Professional app bar with formal styling
  professionaAppBar,
  
  /// Minimal app bar with essential elements only
  minimalAppBar,
  
  /// App bar styled similar to iOS design guidelines
  iosStyleAppBar,
}

/// Defines the appearance styles for chat message cards.
///
/// Use these enum values to customize the visual presentation of chat messages
/// when using the [ChatCard] widget.
enum ChatCardType {
  /// Simple message card with basic styling
  simpleChatCard,
  
  /// Message card with gradient background
  gradientChatCard,
  
  /// Message card with bubble-like appearance
  bubbleChatCard,
  
  /// Message card with card-like appearance and elevation
  cardChatCard,
  
  /// Message card with modern design elements
  modernChatCard,
  
  /// Message card styled similar to iOS design guidelines
  iosStyleChatCard,
  
  /// Message card following Material Design guidelines
  materialChatCard,
}

/// Defines the appearance styles for the chat input field.
///
/// Use these enum values to customize the input field appearance
/// when creating a chat interface.
enum InputFieldType {
  /// Default input field with standard styling
  defaultInput,
  
  /// Input field with rounded corners
  roundedInput,
  
  /// Input field with attachment button
  attachmentInput,
  
  /// Input field with voice recording button
  voiceInput,
}

/// Defines the overall theme of the chat interface.
///
/// Use these enum values to set the general appearance theme
/// of the entire chat interface.
enum ChatTheme {
  /// Light theme with bright background and dark text
  light,
  
  /// Dark theme with dark background and light text
  dark,
  
  /// Custom theme with user-defined colors and styles
  custom,
}