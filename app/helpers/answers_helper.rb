module AnswersHelper
  def best_answer_class(answer)
    'best-answer' if answer.best
  end
end
