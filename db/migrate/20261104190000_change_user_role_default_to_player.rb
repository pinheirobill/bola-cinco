class ChangeUserRoleDefaultToPlayer < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :role, from: "adm_master", to: "jogador_do_time"
  end
end
