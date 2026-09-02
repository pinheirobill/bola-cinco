namespace :data do
  desc "Migrate, reseed users, and import the championship workbooks used for production bootstrap"
  task bootstrap: :environment do
    import_paths = {
      futsal: ENV["BOLA_CINCO_FUTSAL_WORKBOOK"],
      chis_cup: ENV["BOLA_CINCO_CHIS_CUP_WORKBOOK"],
      tranca: ENV["BOLA_CINCO_TRANCA_WORKBOOK"]
    }

    puts "[bootstrap] Running db:migrate"
    Rake::Task["db:migrate"].invoke

    puts "[bootstrap] Running db:seed"
    Rake::Task["db:seed"].invoke

    importers = [
      [:futsal, BolaCinco::ChampionshipWorkbookImporter],
      [:chis_cup, BolaCinco::ChisCupWorkbookImporter],
      [:tranca, BolaCinco::TrancaWorkbookImporter]
    ]

    importers.each do |key, importer_class|
      path = import_paths.fetch(key)
      next if path.blank?

      raise ArgumentError, "Workbook not found: #{path}" unless File.exist?(path)

      puts "[bootstrap] Importing #{key} from #{path}"
      importer_class.new(path: path).call
    end

    puts "[bootstrap] Done"
  end
end
