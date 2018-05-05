module AnswersHelper
  def best_answer_class(answer)
    'best-answer' if answer.question.answer_id == answer.id
  end
end
