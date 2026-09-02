def clear_seed_data!
  tables = ActiveRecord::Base.connection.tables - %w[users schema_migrations ar_internal_metadata]

  ActiveRecord::Base.connection.disable_referential_integrity do
    tables.each do |table_name|
      ActiveRecord::Base.connection.execute("DELETE FROM #{ActiveRecord::Base.connection.quote_table_name(table_name)}")
    end
  end
end

clear_seed_data!

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
