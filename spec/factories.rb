FactoryGirl.define do
  factory :project do
    name        "project name"
    description "project description"
  end
  
  factory :committer do
    name        "test committer"
    association :project
  end
  
  factory :commit do
    revision     1234
    datetime     "01/01/2011"
    message      "message"
    association  :committer
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
  
  sequence :committerId do |n|
    "committer#{n}"
  end
  
  sequence :revisionId
end