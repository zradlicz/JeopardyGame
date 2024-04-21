const Groq = require('groq-sdk');

const groq = new Groq();

async function main() {
  return groq.chat.completions
    .create({
      messages: [
        {
          role: 'system',
          content: "You are a trivia question generator. You generate trivia questions of medium difficulty in the format: { question: 'Question', answer: 'Answer' } Only respond with the question and answer in the requested format, nothing else. Answers should be a word or a short phrase. Remember to close the curly bracket!",
        },
        {
          role: 'user',
          content: promptGenerator(),
        },
      ],

      model: 'mixtral-8x7b-32768',

      // Optional parameters
      temperature: 1,
      max_tokens: 1024,
      top_p: 1,
      stop: null,
      stream: false,
      seed: Math.floor(Math.random() * 500),
    })
    .then((chatCompletion) => {
      return chatCompletion;
    });
}

function promptGenerator()
{
    const verbs = [
        "generate",
        "produce",
        "make",
        "craft",
        "form",
        "build",
        "develop",
        "fabricate",
        "design",
        "construct"
    ];
    const adjectives = [
        "silly",
        "weird",
        "great",
        "interesting",
        "crazy",
        "funny",
        "beautiful",
        "clever",
        "amazing",
        "fantastic",
        "colorful",
        "awesome",
        "fabulous",
        "brilliant",
        "unique",
        "creative",
        "wonderful",
        "exciting",
        "delightful",
        "charming",
        "charismatic",
        "enchanting",
        "captivating",
        "magnificent",
        "remarkable",
        "extraordinary",
        "dazzling",
        "marvelous",
        "breathtaking",
        "splendid"
    ];
    const triviaCategories = [
        "History",
        "Geography",
        "Science",
        "Literature",
        "Movies",
        "Music",
        "Art",
        "Sports",
        "Animals",
        "Food and Drink",
        "Technology",
        "Mathematics",
        "Mythology",
        "Language",
        "Politics",
        "Celebrities",
        "TV Shows",
        "Video Games",
        "Books",
        "Space",
        "Cars",
        "Fashion",
        "Culture",
        "Religion",
        "Architecture",
        "Inventions",
        "Famous Quotes",
        "Plants",
        "Psychology",
        "Weather",
        "Money",
        "Medicine",
        "Mystery",
        "Gaming",
        "Travel",
        "Crime",
        "Sports Teams",
        "Languages",
        "Comics",
        "Anime",
        "History of Art",
        "Philosophy",
        "Economics",
        "Music Genres",
        "Mythical Creatures",
        "Holidays",
        "Board Games",
        "Fashion Designers",
        "Science Fiction",
        "Board Games"
    ];
    const randomVerbsIndex = Math.floor(Math.random() * verbs.length);
    const randomAdjectivesIndex = Math.floor(Math.random() * adjectives.length);
    const randomCategoriesIndex = Math.floor(Math.random() * triviaCategories.length);
    prompt = verbs[randomVerbsIndex].concat(' a ',adjectives[randomAdjectivesIndex]," trivia question with the category: ", triviaCategories[randomCategoriesIndex]);
    console.log(prompt);
    return prompt
}

module.exports = main;
