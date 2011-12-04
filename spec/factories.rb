Factory.define :user do |user|
  user.username "Test User"
end

Factory.define :commit do |commit|
  commit.revision     "r1234"
  commit.user_id      "1234"
  commit.datetime     "01/01/2011"
  commit.message      "message"
  commit.association  :user
end