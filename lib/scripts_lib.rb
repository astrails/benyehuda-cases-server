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

    users.each do |user|
      u = User.find_by_email(user[:email])
      if u
        puts "skipped user = #{_user_info(user)} email already in use"
        next
      end

      opts = {:name => user[:name], :email => _parse_email(user[:email])}
      opts.trust(:name, :email)
      u = User.new(opts)
      u.is_volunteer = true
      unless u.save
        puts "skipped user = #{_user_info(user)}: #{u.errors.full_messages.to_a.join(",")}"
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