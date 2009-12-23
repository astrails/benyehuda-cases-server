namespace :gettext do
  task :load_array_find_index do
    require 'array_find_index'
  end

  # GetText's :find task uses Array#find_index which is not available
  # in 1.8.6. preload a backward compat version
  task :find => :load_array_find_index

  desc "sync .po files to db"
  task :sync do
    folder = ENV['FOLDER']||'locale'

    gem 'grosser-pomo', '>=0.5.1'
    require 'pomo'
    require 'pathname'

    #find all files we want to read
    po_files = []
    Pathname.new(folder).find do |p|
      next unless p.to_s =~ /\.po$/
      po_files << p
    end

    #insert all their translation into the db
    po_files.each do |p|
      #read translations from po-files
      locale = p.dirname.basename.to_s
      next unless locale =~ /^[a-z]{2}([-_][a-z]{2})?$/i
      puts "Reading #{p.to_s}"
      translations = Pomo::PoFile.parse(p.read)

      debugger
      #add all non-fuzzy translations to the database
      translations.reject(&:fuzzy?).each do |t|
        next if t.msgid.blank? #atm do not insert metadata

        key = TranslationKey.find_or_create_by_key(t.msgid)
        #do not overwrite existing translations
        next if key.translations.detect{|text| text.locale == locale}

        #store translations
        puts "Creating text #{locale}:#{t.msgid} = #{t.msgstr}"
        key.translations.create!(:locale=>locale, :text=>t.msgstr)
      end
    end
  end

end

