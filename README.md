# Vocabulary Quiz

A PowerShell script for interactive vocabulary study with support for custom input files, multiple topics, flexible word ordering, and dynamic topic switching.

## Overview

Vocabulary Quiz is an educational tool that helps users study word-definition pairs from a customizable text file. It offers an interactive quiz experience where words can be organized by topic and presented in either random or sequential order. Users can specify custom input files, switch between topics and change word ordering on-the-fly during the quiz.

## Features

- ðŸ“ **Custom Input Files**: Specify any text file as input (defaults to wordlist.txt)
- ðŸ“š **Multiple Topics**: Organize words into categories
- ðŸ”€ **Flexible Ordering**: Choose between random or sequential word order
- ðŸŽ¯ **Dynamic Switching**: Change topics or order modes during the quiz
- âŒ¨ï¸ **Interactive Commands**: Built-in commands for quiz control
- ðŸ“Š **Word Count Display**: See how many words you're studying
- ðŸ†˜ **Built-in Help**: Access command reference at any time
- ðŸŽ¨ **Color-Coded Output**: Easy-to-read colored terminal output

## Requirements

- PowerShell 3.0 or later
- A text file containing word-definition pairs (default name: `wordlist.txt`, customizable via -File parameter)
- Read access to the input file

## Installation

1. Ensure you have the `vocabularyquiz.ps1` script
2. Create a `wordlist.txt` file in the same directory (see [File Format](#file-format)), or provide any other text file
3. Run the script:
   ```powershell
   .\vocabularyquiz.ps1
   ```
   Or with a custom file:
   ```powershell
   .\vocabularyquiz.ps1 -File mywords.txt
   ```

## File Format

The script reads from a file specified by the `-File` parameter, defaulting to `wordlist.txt`. The expected format is:

```
[TopicName]
word1: definition1
word2: definition2

[AnotherTopic]
word3: definition3
word4: definition4
```

### Format Rules

- **Topic Headers**: Must be enclosed in square brackets `[TopicName]`
- **Word-Definition Pairs**: One per line, separated by a colon `:`
- **Empty Lines**: Are ignored and can be used for readability
- **Multiple Topics**: Any number of topics can be defined in a single file
- **File Name**: Can be anything (e.g., wordlist.txt, spanish.txt, vocabulary.txt)

### Example File

```
[Animals]
dog: a four-legged domestic animal
cat: a feline pet animal
bird: an animal with wings and feathers

[Colors]
red: the color of fire or blood
blue: the color of the sky
green: the color of grass and trees

[Fruits]
apple: a round red or green fruit
banana: a yellow curved tropical fruit
orange: a citrus fruit with a thick skin
```

## Usage

### Basic Commands

#### Start with Default Settings
```powershell
.\vocabularyquiz.ps1
```
Starts the quiz with the default file (wordlist.txt) and all topics in random order.

#### Use a Custom Input File
```powershell
.\vocabularyquiz.ps1 -File spanish.txt
```
Starts the quiz with a custom file.

#### Select a Specific Topic
```powershell
.\vocabularyquiz.ps1 -Topic Animals
```
Starts the quiz with only the Animals topic from the default file.

#### Select Multiple Topics
```powershell
.\vocabularyquiz.ps1 -Topic "Animals Colors"
```
or
```powershell
.\vocabularyquiz.ps1 -Topic "Animals,Colors,Fruits"
```
Starts the quiz with multiple topics combined.

#### Custom File with Specific Topic
```powershell
.\vocabularyquiz.ps1 -File vocabulary.txt -Topic Animals
```
Uses a custom file with a specific topic.

#### Set Word Order to Sequential
```powershell
.\vocabularyquiz.ps1 -Order List
```
Words are presented in the order they appear in the file.

#### Combine All Arguments
```powershell
.\vocabularyquiz.ps1 -File spanish.txt -Topic "Verbs Nouns" -Order List
```
Starts with a custom file, multiple topics, and sequential order.

#### Display Help
```powershell
.\vocabularyquiz.ps1 -Help
```
Shows comprehensive help information and command reference.

## Interactive Commands

Commands are **only available** after you view the translation. When the script displays "Press Enter to see the translation...", only the Enter key is accepted. After viewing the translation and seeing "Press Enter for the next word or enter a command...", you can enter the following commands:

### `info`
Displays the quiz header showing:
- Current topic(s)
- Current word order mode
- Total word count
- Available topics (if viewing all)

**Usage:**
```
Translation: a four-legged domestic animal
Press Enter for the next word or enter a command...
info
```

### `topic` (interactive)
Prompts you to enter a topic name interactively.

**Usage:**
```
Translation: the color of the sky
Press Enter for the next word or enter a command...
topic
Available topics: Animals, Colors, Fruits
Enter topic name(s) separated by spaces (or 'All'): Colors
Switched to topic: Colors
Word Count: 3
```

### `topic <TopicName>`
Directly switches to the specified topic(s). Multiple topics can be separated by spaces.

**Usage:**
```
Translation: a four-legged domestic animal
Press Enter for the next word or enter a command...
topic Colors
Switched to topic: Colors
Word Count: 3
```

or

```
Translation: a four-legged domestic animal
Press Enter for the next word or enter a command...
topic Animals Colors
Switched to topic(s): Animals, Colors
```

### `order` (interactive)
Prompts you to choose between Random and List order.

**Usage:**
```
Translation: a four-legged domestic animal
Press Enter for the next word or enter a command...
order
Enter order: 'Random' or 'List': List
Switched to order: List
```

### `order <OrderType>`
Directly switches to the specified order mode. Supports:
- `Random` or `r` - Random order
- `List` or `l` - Sequential order

**Usage:**
```
Translation: a four-legged domestic animal
Press Enter for the next word or enter a command...
order List
Switched to order: List
```

### `help`
Displays the command reference with descriptions of all available quiz commands and current settings.

**Usage:**
```
Translation: a four-legged domestic animal
Press Enter for the next word or enter a command...
help
```

### `refresh`
Reloads the word list from the file. This is useful if you have edited the word list file while the quiz is running. The current topic and word order settings are maintained after refresh.

**Usage:**
```
Translation: a four-legged domestic animal
Press Enter for the next word or enter a command...
refresh
Word list refreshed successfully
Word Count: 45
```

### `restart`
Restarts the current topic from the beginning. If in Random mode, the words are reshuffled. If in List mode, the quiz starts from the first word again.

**Usage:**
```
Translation: a four-legged domestic animal
Press Enter for the next word or enter a command...
restart
Topic restarted
Topic: Animals
Order: Random
Word Count: 15
```

### `quit` or `exit`
Stops the quiz and exits the script.

**Usage:**
```
Translation: a four-legged domestic animal
Press Enter for the next word or enter a command...
quit
Thanks for studying!
```

## Word Order Modes

### Random Mode (Default)
- Words are displayed in random order using PowerShell's `Get-Random`
- Each time the quiz runs, words appear in a different sequence
- When switching back to Random mode, words are reshuffled
- Best for: Testing knowledge comprehensively

### List Mode
- Words are displayed in the sequential order they appear in the file
- Within each file section, words maintain their original order
- When switching to List mode, starts from the first word of the selected topic(s)
- Best for: Learning new words systematically

## Workflow

1. **Start**: Run the script with desired parameters
2. **Display Word**: Script shows a word from the selected topic(s)
3. **Press Enter**: User presses Enter (commands NOT available at this stage)
4. **Display Translation**: Script displays the word's translation
5. **Enter Commands**: User can now enter commands (info, topic, order, help, quit) or press Enter to continue
6. **Next Word**: Next word is selected and displayed
7. **Repeat**: Steps 2-6 continue until user quits

## Examples

### Example 1: Basic Usage with Default File
```powershell
PS C:\vocab> .\vocabularyquiz.ps1
Vocabulary Quiz
===============
Available topics: Animals, Colors, Fruits
Topic: All
Order: Random
Word Count: 9

Word: bird - Press Enter to see the definition...
[Press Enter]
Definition: an animal with wings and feathers
Press Enter for the next word or enter a command...
```

### Example 2: Custom File with Specific Topic
```powershell
PS C:\vocab> .\vocabularyquiz.ps1 -File spanish.txt -Topic Colors -Order List
Vocabulary Quiz
===============
Topic: Colors
Order: List
Word Count: 3

Word: rojo - Press Enter to see the definition...
```

### Example 3: Multiple Topics from Custom File
```powershell
PS C:\vocab> .\vocabularyquiz.ps1 -File vocabulary.txt -Topic "Animals Colors"
```

### Example 4: Topic Switching During Quiz
```powershell
Word: dog - Press Enter to see the definition...
topic Colors
Switched to topic: Colors
Word Count: 3

Word: blue - Press Enter to see the definition...
```

### Example 5: Getting Help
```powershell
PS C:\vocab> .\vocabularyquiz.ps1 -Help
Vocabulary Quiz - Help
======================

Command Line Arguments:
  -File <FileName>          Input file containing word-definition pairs.
                            Default: 'wordlist.txt'
  -Topic <TopicName>        Select topic(s). Use spaces or commas for multiple.
                            Examples: 'Animals' or 'Animals,Colors' or 'Animals Colors'
                            Default: 'All' (all topics)
  ...
```

## Tips and Tricks

### ðŸ’¡ Study Efficiently
- Start with all topics in Random mode for comprehensive review
- Switch to List mode when learning new vocabulary
- Use multiple quiz sessions with different topic combinations

### ðŸ”„ Practice Strategies
1. **Review New Words**: Start with List mode to memorize definitions sequentially
2. **Test Knowledge**: Switch to Random mode to test recall
3. **Focus Areas**: Use the `topic` command to concentrate on weak areas

### âš¡ Quick Navigation
- Type command shortcuts: `r` for Random, `l` for List
- Use multiple topics at once: `topic Animals Colors Fruits`
- Switch back to all topics anytime: `topic All`

### ðŸ“ File Organization
- Organize words by difficulty: `[Easy]`, `[Medium]`, `[Hard]`
- Group by category: `[Verbs]`, `[Nouns]`, `[Adjectives]`
- Mix and match topics in a single session

## Troubleshooting

### Error: "File not found"
- Ensure the file is in the current directory or provide full path
- Check file name spelling and extension
- Verify read access to the file
- Default file should be named `wordlist.txt` if no -File parameter is specified

### Error: "Topic not found"
- Check topic name spelling (matching case is not required)
- Use `info` command to see available topics
- Ensure topic header is properly formatted: `[TopicName]`

### No words appearing
- Verify file format: each word-definition pair needs a colon
- Check for syntax errors in the input file
- Ensure topic headers are on their own lines in square brackets
- Confirm the file has proper read permissions

### Script won't start
- Ensure PowerShell execution policy allows running scripts:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

## Command Reference Table

| Command | Mode | Function | Example |
|---------|------|----------|---------|
| `info` | Any prompt | Show quiz header | `info` |
| `topic` | Any prompt | Switch topics (interactive) | `topic` |
| `topic X` | Any prompt | Switch to topic X | `topic Animals` |
| `order` | Any prompt | Switch order (interactive) | `order` |
| `order random` | Any prompt | Switch to random order | `order random` |
| `order list` | Any prompt | Switch to list order | `order list` |
| `help` | Any prompt | Show command help | `help` |
| `quit` \| `exit` | Any prompt | Exit quiz | `quit` |

## Performance Notes

- Script performance depends on file size and word count
- Typical file with 100-200 words loads instantly
- Random shuffling is fast even with large word sets
- No noticeable lag when switching topics or order modes

## Limitations

- Commands are case-insensitive but topic names preserve case
- Maximum practical word count depends on terminal scrollback
- No persistence of quiz progress between sessions
- Custom file must be in a readable text format

## Future Enhancements

Possible improvements could include:
- Score tracking and statistics
- Timed quiz modes
- Progress saving
- Custom file selection
- Spaced repetition algorithm
- Multiple choice answers
- Word search/filter functionality

## License

This script is provided as-is for educational purposes.

## Support

For issues or questions:
1. Check the TLDR.txt file for quick reference
2. Run the script with `-Help` flag for detailed information
3. Use the `help` command during the quiz
4. Review the format requirements in this README

## Version History

### Version 1.0
- Initial release
- Core quiz functionality
- Topic support
- Random and List ordering
- Interactive commands
- Built-in help system
- Multi-topic selection
- Dynamic topic switching
- Order mode switching

---

**Happy studying!** ðŸŽ“
