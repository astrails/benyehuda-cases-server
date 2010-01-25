module GettextI18nRails


  # flatter a i18n style translation hash into a single level hash (join levels with '.')
  def flatten_yml_translations(h, prefix = nil)
    h.inject({}) do |res,e|
      k, v = e
      k = "#{prefix}.#{k}" if prefix
      res.merge v.is_a?(Hash) ? flatten_yml_translations(v, k) : {k => v}
    end
  end

  def store_yml_translations(rb_filename, default_locale_po_file)

    po = Pomo::PoFile.parse(File.read(default_locale_po_file))
    po_index = po.index_by(&:msgid)

    File.open(rb_filename, "w") do |rb_file|

      I18n.load_path.flatten.each do |yml_file|
        next unless File.exists?(yml_file)

        translations = YAML.load(File.read(yml_file))
        next unless translations["en"]

        messages = flatten_yml_translations(translations["en"])

        messages.each do |k, v|
          # we dont' support non-string translations 'yet'
          # need to add JSON support to the .mo backend first
          next unless v.is_a?(String)
          # store _("...") into the rb_file so that "rake gettext:find" will find it
          # and add it to the locale/app.pot file
          # We need this because otherwise we  can't add translations to locale/LOC/app.po files
          # since msgmerge will remove anything that is not in the locale/app.pot
          rb_file.puts "_(#{k.inspect})"

          # add translation to the .po File
          if translation = po_index[k]
            translation.msgstr = v if translation.msgstr.blank?
          else
            translation = Pomo::Translation.new
            translation.comment = ": " + yml_file
            translation.msgid = k
            translation.msgstr = v
            po << po_index[k] = translation
          end

        end
      end

    end

    File.open(default_locale_po_file, "w") {|f| f.write Pomo::PoFile.to_text(po.sort_by{|x| [*x.msgid].first || ""})}
  end

end
