class User < ApplicationRecord
  audited

  attribute :role, :string

  enum :role, {
    adm_master: "adm_master",
    dono_da_quadra: "dono_da_quadra",
    tecnico_do_time: "tecnico_do_time",
    jogador_do_time: "jogador_do_time"
  }, default: :adm_master

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
