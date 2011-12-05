Factory.define :user do |user|
  user.username "Test User"
end

Factory.sequence :id do |n|
  "user#{n}"
end

Factory.define :commit do |commit|
  commit.revision     1234
  commit.datetime     "01/01/2011"
  commit.message      "message"
  commit.association  :user
end