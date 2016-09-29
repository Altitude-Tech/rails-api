unless @group.name.nil?
  json.name @group.name
end

json.admin @group.admin.email

json.users @group.users.each do |user|
  json.name user.name
  json.email user.email
end
