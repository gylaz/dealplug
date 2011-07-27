Factory.define :user do |f|
  f.username   'user'
end

Factory.define :deal do |f|
  f.title        'New Deal'
  f.price        25
  f.url          'http://amazon.com'
  f.description  'Text that is long enough'
  f.association  :user
end

Factory.define :vote do |f|
  f.user_id 1
  f.deal_id 100
end
