---
name: draft
description: Generate draft.md scene plans from script.txt using scene delimiters, timing estimates, and default transitions.
---
# CNG Draft Generation Skill

## Purpose
Transform `script.txt` into a structured `draft.md` scene plan for CNG. This skill reads the script, splits it into scenes, and outputs a human-editable draft with timing ranges, transitions, query hints, and captions.

## Inputs
- `script.txt`: Plain text script or diarized transcription.

## Output
- `draft.md`: Scene plan using the format described below.

## Scene delimiter
Split the script into scenes using a **line that contains exactly `---`**.

- Trim whitespace around each scene.
- Ignore empty scenes.
- Number scenes sequentially starting from 1.

## Scene format
Each scene is a block in this exact shape:

```
scene #n
chapter: HH:MM:SS-HH:MM:SS
transition: transition-name
query: brief search query
url:
caption: caption text
```

## Generation rules

### 1) Chapter timing (estimate)
When timestamps are not provided, estimate timing by word count at **150 words per minute**.

- $\text{seconds} = \frac{\text{word\_count}}{150} \times 60$
- Use cumulative time to compute start and end time per scene.
- Format as `HH:MM:SS-HH:MM:SS` (zero-padded).

### 2) Transition
If no scene type markers exist, use a default transition:

- `transition: fade-in-out`

### 3) Query
Auto-generate a short, concrete visual query from each scene’s text.

Guidelines:
- Prefer nouns and named entities.
- Keep it 3–8 words.
- Avoid filler words.

### 4) URL
Leave `url` blank for user to fill with a local file path.

### 5) Caption
Use the scene text as the caption by default.

- If very long, lightly condense while preserving meaning.
- Keep punctuation and sentence casing.

## Example

### Input: `script.txt`
```
The committee reconvenes to debate the tariff proposal.
Members cite inflation and manufacturing impact.
---
In the next segment, the speaker outlines a compromise path.
```

### Output: `draft.md`
```
scene #1
chapter: 00:00:00-00:00:10
transition: fade-in-out
query: congressional committee tariff debate
url:
caption: The committee reconvenes to debate the tariff proposal. Members cite inflation and manufacturing impact.

scene #2
chapter: 00:00:10-00:00:16
transition: fade-in-out
query: speaker outlines compromise path
url:
caption: In the next segment, the speaker outlines a compromise path.
```