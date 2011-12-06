Factory.define :user do |user|
  user.username "Test User"
end

Factory.sequence :userId do |n|
  "user#{n}"
end

Factory.sequence :revisionId

Factory.define :commit do |commit|
  commit.revision     1234
  commit.datetime     "01/01/2011"
  commit.message      "message"
  commit.association  :user
end

Factory.define :change do |change|
  change.revision     1
  change.status       "A"
  change.project_root "/target"
  change.filepath     "/target/src/main"
  change.fullpath     "/target/src/main/file.txt"
  change.association  :commit
end