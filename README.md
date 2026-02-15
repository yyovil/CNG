# Project Description

CNG is a video essay content generation engine. The user provides a script/diarized transcription of multiple speakers in a `script.txt` file, and CNG outputs a produced MP4 video.

## How does it work

1. CNG ingests the `script.txt` provided by the user and generates a `draft.md` file that contains the predicted scene plan.
2. The user reviews `draft.md` and finalizes it by making any edits needed for their taste.
3. After `draft.md` finalization, CNG executes post-production tasks like burning captions, applying transitions, and generating voiceover via an online TTS service over visuals (provided as local file paths).
4. Finally, it outputs the produced MP4 video.

## Scene format (`draft.md`)

Each scene is described in `draft.md` using a compact, human-editable block:

```md
scene #n
chapter: time range in HH:MM:SS format
transition: transition-name
query: a brief query to use to search image online
url: local file path to the image/video content to be used as the visual
caption: transcription to be burned in this video section
```

## Script input conventions (`script.txt`)

- Separate scenes using a line that contains exactly `---`.
- If timestamps are not provided, CNG estimates `chapter` timing from word count at ~150 wpm.
- Default transition is `fade-in-out` when no scene type is specified.
- `query` is auto-generated; `url` is left blank for a local file path.

## Rendering (experimental)

The renderer uses **FFmpeg** under the hood and expects local media paths in `url`.

Example usage:

```bash
python -m cng render --draft draft.md --output output.mp4
```

Optional flags:

- `--workdir .cng` to keep temporary segments.
- `--font /path/to/font.ttf` to control caption font.
- `--width`, `--height`, `--fps` to control output format.
- `--caption-max-words` to limit words per on-screen caption chunk (default: 5).
- `--caption-max-lines` to limit caption lines per chunk (default: 1).
- `--caption-max-chars` to limit characters per line (default: 50).
- `--tts/--no-tts` to enable/disable ElevenLabs narration (default: enabled).
- `--tts-voice-id`, `--tts-model-id`, `--tts-output-format` to control TTS settings (use `mp3_44100_128`).
- `--tts-stability`, `--tts-similarity` to tune voice characteristics.
- `--audio-gain` to boost narration volume (default: 1.5).
- `--scene-index` to render only specific scenes (repeatable).
- `--no-concat` to skip concatenation (useful for single-scene tests).

### ElevenLabs voiceover

Set your API key before rendering:

```.env
ELEVENLABS_API_KEY=your_key_here
```

CNG will read `ELEVENLABS_API_KEY` from your environment or a local `.env` file in the repo root.

### Fast single-scene audio testing

Render only scene 1 without concatenation:

```zsh
python -m cng render --draft draft.md --scene-index 1 --no-concat --output scene_001_test.mp4
```

Or directly mux an existing scene video with its audio:

```zsh
python -m cng mix --video .cng/segments/scene_001.mp4 --audio .cng/audio/scene_001.mp3 --output scene_001_mix.mp4
```
