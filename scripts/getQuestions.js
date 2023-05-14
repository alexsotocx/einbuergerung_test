function getQuestions(startingNumber, endNumber = 310) {
    let questionNumber = startingNumber;
    let currentQuestionNode = null;
    const questions = [];
    for (questionNumber = startingNumber; questionNumber < endNumber; questionNumber++) {
          currentQuestionNode = document.getElementById(`frage-${questionNumber}`);
          if (currentQuestionNode === null) break;
          const currentQuestionJson = {
                text: null,
                link: null,
                answer: null,
                wrongAnswers: [],
                number: questionNumber,
          };


          const questionTextNode = currentQuestionNode.getElementsByClassName("questions-question-text")[0].getElementsByTagName('p')[0];
          currentQuestionJson.text = questionTextNode.textContent;
          if(questionTextNode.hasChildNodes()) {
                currentQuestionJson.link = questionTextNode.childNodes[0].href;
          }



          const answers = currentQuestionNode.getElementsByClassName('question-answers-list')[0].getElementsByTagName('li');
          for(let a of answers) {    
                const isCorrectAnswer = a.getElementsByClassName('question-answer-right').length > 0;
                if (isCorrectAnswer) {
                      currentQuestionJson.answer = a.textContent;
                } else {
                      currentQuestionJson.wrongAnswers.push(a.textContent);
                }
                
          }

          questions.push(currentQuestionJson);
    }

    return questions;
}

let questions = getQuestions(271);
console.log("isCorrect", questions.every(q => q.answer && q.text && q.wrongAnswers.length > 0))

questions
