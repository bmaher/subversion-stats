FactoryGirl.define do
  factory :project do
    name        "project name"
    association :user
  end
  
  factory :committer do
    name        "test committer"
    association :project
  end
  
  factory :commit do
    revision     1234
    datetime     "2012-01-01T00:00:00.000000A"
    message      "message"
    association  :committer
    association  :project
  end
  
  factory :change do
    revision     1
    status       "A"
    project_root "/target"
    filepath     "/target/src/main"
    fullpath     "/target/src/main/file.txt"
    association  :commit
  end

  factory :user do
    username
    email
    password              "password"
    password_confirmation "password"
    remember_me           true
  end

  sequence :project_id do |n|
    "project#{n}"
  end
  
  sequence :committer_id do |n|
    "committer#{n}"
  end
  
  sequence :revision

  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :username do |n|
    "user#{n}"
  end
end