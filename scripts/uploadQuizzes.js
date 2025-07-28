const admin = require("firebase-admin");
const fs = require("fs");
const path = require("path");

const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// 👇 Convert answer letter to index
function convertToIndexedAnswer(questionObj) {
  const letterToIndex = { A: 0, B: 1, C: 2, D: 3 };
  const correctIndex = letterToIndex[questionObj.answer?.toUpperCase()] ?? -1;

  return {
    question: questionObj.question,
    options: questionObj.options,
    correctAnswerIndex: correctIndex
  };
}

const quizzes = JSON.parse(
  fs.readFileSync(path.join(__dirname, "quizzes.json"), "utf8")
);

(async () => {
  for (const quiz of quizzes) {
    try {
      const docRef = await db.collection("quizzes").add({
        title: quiz.title || "Untitled",
        description: quiz.description || "",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        questions: quiz.questions.map(convertToIndexedAnswer)
      });

      console.log(`✅ Uploaded quiz: ${quiz.title} (ID: ${docRef.id})`);
    } catch (error) {
      console.error(`❌ Failed to upload quiz: ${quiz.title}`, error);
    }
  }

  console.log("🎉 Upload complete!");
})();
