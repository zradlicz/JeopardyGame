
// Define a function to calculate the score
function calculateScore(correctAnswer, playerAnswer) {
  const similarityThreshold = 0.7; // You can adjust this threshold based on how close you want the answer to be

  // Convert both answers to lowercase for case-insensitive comparison
  const correctAnswerLower = correctAnswer.toLowerCase();
  const playerAnswerLower = playerAnswer.toLowerCase();

  if (playerAnswerLower === correctAnswerLower) {
    return 2; // Exactly correct, award 2 points
  } else {
    // Calculate the similarity using Levenshtein distance or another method
    const similarity = calculateSimilarity(correctAnswerLower, playerAnswerLower);

    if (similarity >= similarityThreshold) {
      return 1; // Close enough, award 1 point
    } else {
      return 0; // Incorrect, no points awarded
    }
  }
}

// Function to calculate similarity between two strings (you can use other methods as well)
function calculateSimilarity(str1, str2) {
  const longer = str1.length > str2.length ? str1 : str2;
  const shorter = str1.length > str2.length ? str2 : str1;
  const longerLength = longer.length;

  if (longerLength === 0) {
    return 1.0;
  }

  return (longerLength - calculateLevenshteinDistance(longer, shorter)) / parseFloat(longerLength);
}

// Function to calculate Levenshtein distance between two strings
function calculateLevenshteinDistance(str1, str2) {
  const matrix = [];
  const len1 = str1.length + 1;
  const len2 = str2.length + 1;

  for (let i = 0; i < len1; i++) {
    matrix[i] = [i];
  }
  for (let j = 0; j < len2; j++) {
    matrix[0][j] = j;
  }

  for (let i = 1; i < len1; i++) {
    for (let j = 1; j < len2; j++) {
      const cost = str1.charAt(i - 1) === str2.charAt(j - 1) ? 0 : 1;
      matrix[i][j] = Math.min(
        matrix[i - 1][j] + 1,
        matrix[i][j - 1] + 1,
        matrix[i - 1][j - 1] + cost
      );
    }
  }

  return matrix[len1 - 1][len2 - 1];
}

module.exports = calculateScore;