desc "synchronise po files with db, creating keys and translations that do not exist"
task :sync_po_to_db => :environment do
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

  # In most cases translations can easily fit in memory. we can greatly improve
  # performance of this task by preloading them all at once
  keys = TranslationKey.all(:include => :translations).index_by(&:key)

  #insert all their translation into the db
  po_files.each do |p|
    #read translations from po-files
    locale = p.dirname.basename.to_s
    next unless locale =~ /^[a-z]{2}([-_][a-z]{2})?$/i
    puts "Reading #{p.to_s}"
    translations = Pomo::PoFile.parse(p.read)

    #add all non-fuzzy translations to the database
    translations.reject(&:fuzzy?).each do |t|
      next if t.msgid.blank? #atm do not insert metadata

      msgid = t.msgid.to_json

      if key = keys[msgid]
        #do not overwrite existing translations
        next if key.translations.detect{|text| text.locale == locale}
      else
        key = keys[msgid] = TranslationKey.create!(:key => t.msgid)
      end

      #store translations
      puts "Creating text #{locale}:#{msgid} = #{t.msgstr.to_json}"
      key.translations.create!(:locale => locale, :text => t.msgstr)
    end
  end
end