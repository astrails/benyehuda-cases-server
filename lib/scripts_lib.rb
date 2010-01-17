module ScriptsLib
  def self.import_volunteers(filename)
    csv = FasterCSV.read(filename)
    titles = csv[1].compact
    users = []
    csv[2..-1].each do |row|
      user = {}
      titles.each_with_index do |title, i|
        user[title] = row[i]
      end
      users << user.symbolize_keys
    end
    puts "#{users.size} users found in csv, keys are: #{titles.inspect}\nimporting..."

    user_properties = {}
    ["address", "phone", "mobile phone", "comments"].each do |k|
      user_properties[k] = Property.find_by_title_and_parent_type(k, "User")
    end
    volunteer_properties = {}
    ["msd", "tasks you want to participate"].each do |k|
      volunteer_properties[k] = Property.find_by_title_and_parent_type(k, "Volunteer")
    end

    users.each do |user|
      u = User.find_by_email(user[:email])
      if u
        puts "skipped user = #{_user_info(user)} email already in use"
        next
      end

      opts = {:name => user[:name], :email => _parse_email(user[:email])}
      opts.trust(:name, :email)
      User.transaction do
        new_user = User.new(opts)
        new_user.is_volunteer = true
        unless new_user.save
          puts "skipped user = #{_user_info(user)}: #{new_user.errors.full_messages.to_a.join(",")}"
        else
          user_properties.keys.each do |k|
            if user[k.to_sym]
              new_user.user_properties.create(:property_id => user_properties[k].id, :custom_value => user[k.to_sym])
            end
          end
          volunteer_properties.keys.each do |k|
            if user[k.to_sym]
              new_user.volunteer_properties.create(:property_id => volunteer_properties[k].id, :custom_value => user[k.to_sym])
            end
          end
        end
      end
    end
  end

  protected
  def self._parse_email(email)
    email = email.split(";").first if email =~ /;/
    email = $1 if email =~ /<(.+)>/
    email = $1 if email =~ /\[(.+)\]/
    email.to_s.strip
  end

  def self._user_info(user)
    "#{user[:msd]} / #{user[:name]} / <#{user[:email]}>"
  end
end