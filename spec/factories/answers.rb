FactoryBot.define do
  sequence :answer_body do |n|
    "Answer Body #{n}"
  end

  factory :answer do
    body { generate(:answer_body) }
    question
    user
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    question
    user
  end

end
