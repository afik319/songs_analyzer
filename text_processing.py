import pronouncing
from nltk.corpus import cmudict

numbers_last_syllable = {"0": "N", "1": "N", "2": "UW1", "3": "IY1", "4": "R", "5": "V", "6": "S", "7": "N", "8": "T", "9": "N"}
LAST_SYLLABLE_INDEX = -1
FINAL_LETTERS = 3

"""
    Retrieves the last syllable of a given word using multiple methods.

    Args:
        word (str): The word to process.

    Returns:
        str or None: The last syllable if found, otherwise None.
"""
def get_last_syllable(word):
    syllables = pronouncing.phones_for_word(word)
    if syllables:
        return syllables[0].split()[LAST_SYLLABLE_INDEX]

    if word.isdigit():
        return numbers_last_syllable[word[LAST_SYLLABLE_INDEX]]

    nltk_result = get_last_syllable_nltk(word)
    if nltk_result:
        return nltk_result

    if len(word) >= FINAL_LETTERS:
        return word[-FINAL_LETTERS:]
    return None

d = cmudict.dict()

"""
    Retrieves the last syllable of a word using the NLTK CMU Pronouncing Dictionary.

    Args:
        word (str): The word to process.

    Returns:
        str or None: The last syllable if found, otherwise None.
"""
def get_last_syllable_nltk(word):
    word = word.lower()
    if word in d:
        phones = d[word][0]
        return phones[LAST_SYLLABLE_INDEX]
    return None

"""
    Splits a paragraph into words while maintaining punctuation and structure.

    Args:
        text (str): The text to split.

    Returns:
        list: A list of words and punctuation from the text.
"""
def split_par(text):
    words = []
    current_word = ""

    start_mode = "start"
    letters_mode = "letters"
    irregular_start_mode = "irregular_start"
    punctuation_mode = "punctuation"

    curr_mode = start_mode

    for char in text:
        if curr_mode == start_mode:
            current_word += char
            if char.isalnum():
                curr_mode = letters_mode
            else:
                curr_mode = irregular_start_mode
        elif curr_mode == letters_mode:
            current_word += char
            if (not char.isalnum()) and (not char == '\n') and (not char in ["'", '"']):
                curr_mode = punctuation_mode
            elif char == '\n':
                words.append(current_word)
                current_word = ""
                curr_mode = start_mode
        elif curr_mode == irregular_start_mode:
            current_word += char
            if char.isalnum():
                curr_mode = letters_mode
        elif curr_mode == punctuation_mode:
            if char.isalnum():
                words.append(current_word)
                current_word = char
                curr_mode = letters_mode
            else:
                current_word += char
                if char == '\n':
                    words.append(current_word)
                    current_word = ""
                    curr_mode = start_mode
    if current_word.strip() != "":
        words.append(current_word)
    return words