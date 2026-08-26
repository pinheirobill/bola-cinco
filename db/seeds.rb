import_path = Rails.root.join("db/seeds/bola_cinco_import_2026.json")
raise ArgumentError, "Missing seed import file: #{import_path}" unless import_path.exist?

users = [
  { email: "admin@bola-cinco.local", role: :adm_master },
  { email: "quadra@bola-cinco.local", role: :dono_da_quadra },
  { email: "tecnico@bola-cinco.local", role: :tecnico_do_time },
  { email: "jogador@bola-cinco.local", role: :jogador_do_time }
]

users.each do |attrs|
  user = User.find_or_initialize_by(email: attrs.fetch(:email))
  user.role = attrs.fetch(:role)
  user.password = "password123"
  user.password_confirmation = "password123"
  user.save!
end

BolaCinco::Importer.new(path: import_path).call
load Rails.root.join("db/seeds/atletas_categoria_1.rb")
load Rails.root.join("db/seeds/arbitros_e_campos.rb")
