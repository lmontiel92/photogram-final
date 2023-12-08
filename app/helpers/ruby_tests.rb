response = ""

the_photo = [john, mark, luke]

the_photo.fans.each_with_index do |a_fan, count| 
  
  if count < the_photo.fans.count-1
    response = response + a_fan.username.to_s + ", "

  elsif count == the_photo.fans.count
    response = response + a_fan.username.to_s + ", and "

  else
    response = response + a_fan.username.to_s

end

pp response
