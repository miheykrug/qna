FactoryBot.define do
  sequence :question_title do |n|
    "Question #{n}"
  end

  sequence :question_body do |n|
    "Question Body #{n}"
  end

  factory :question do
    title { generate(:question_title) }
    body { generate(:question_body) }
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
