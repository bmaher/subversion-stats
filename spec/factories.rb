FactoryGirl.define do
  factory :project do
    name        "project name"
    description "project description"
  end
  
  factory :user do
    name        "test user"
    association :project
  end
  
  factory :commit do
    revision     1234
    datetime     "01/01/2011"
    message      "message"
    association  :user
  end
  
  factory :change do
    revision     1
    status       "A"
    project_root "/target"
    filepath     "/target/src/main"
    fullpath     "/target/src/main/file.txt"
    association  :commit
  end
  
  sequence :projectId do |n|
    "project#{n}"
  end
  
  sequence :userId do |n|
    "user#{n}"
  end
  
  sequence :revisionId
end