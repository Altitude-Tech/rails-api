json.extract! @error, :error, :message

if @error.key? :user_message
  json.user_message @error[:user_message]
end

json.status @error[:status]
