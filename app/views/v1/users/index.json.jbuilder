json.users @users.each do |user|
  json.call(user, :name, :email)
end
