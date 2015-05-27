# metadata.rb


description      "Installs Encoder App"
version          "1.0"

# I'll add more!
%w{ ubuntu debian }.each do |os|
    supports os
end
