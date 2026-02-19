
# AI Hafiz - Your Personal Quran Coach

AI Hafiz acts as a virtual Quran teacher, listening to your recitation and correcting mistakes in real-time, just like a Hafiz would.

## Features

- **Prompt Mode**: Supportive coaching with quick hints.
- **Test Mode**: Strict checking for self-evaluation.
- **Real-time Correction**: Detects mistakes and asks to repeat.
- **Offline Data**: Works with local Quran text and audio (pending download).
- **Premium UI**: Modern dark-themed interface.

## Tech Stack

- **Framework**: Flutter
- **State Management**: Bloc / Cubit
- **Audio Recording**: `record` package
- **Speech-to-Text**: Google Cloud Speech-to-Text API
- **Comparison Logic**: Levenshtein Distance Algorithm (Custom)

## Getting Started

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/mkkm88/ai-hafiz.git
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

## Development Status

See [TODO.md](TODO.md) for detailed progress tracking.
