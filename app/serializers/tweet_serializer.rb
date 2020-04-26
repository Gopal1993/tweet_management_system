class TweetSerializer < ActiveModel::Serializer
  attributes :content
  has_one :user, serializer: UserSerializer
end