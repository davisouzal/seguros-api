# log/model.cr
require "pg"
require "json"

class Logs
  alias ListOfLogs = Array(Hash(String, Int32 | String | Time))
  alias Log = Hash(String, Int32 | String | Time)
  alias DBConnection = PG::Connection
  alias DBResult = PG::ResultSet

  # Atributos do modelo
  property id : Int32?
  property user_id : Int32
  property protocol_number : Int32
  property date : String
  property type : String

  # Construtor
  def initialize(@user_id : Int32, @protocol_number : Int32, @date : String, @type : String)
  end

  # Método para salvar um novo log no banco de dados
  def save(db)
    db.exec("INSERT INTO logs (user_id, protocol_number, date, type) VALUES ($1, $2, $3, $4)",
      @user_id, @protocol_number, @date, @type)
  end

  # Método para obter todos os logs
  def self.get_all(db) : ListOfLogs
    self.transform_logs(db.query(%{
      SELECT
        *
      FROM logs
      ORDER BY id
    }))
  end

  # Método para obter um log por ID
  def self.get_by_id(db, id : Int32)
    result = db.query(%{
      SELECT
        id, user_id, protocol_number, date, type
      FROM logs
      WHERE id = $1
    }, id)

    self.transform_logs(result)
  end

  # Método para atualizar um log
  def update(db, id : Int32)
    db.exec(%{
      UPDATE logs
      SET user_id = $1, protocol_number = $2, date = $3, type = $4
      WHERE id = $5
    }, @user_id, @protocol_number, @date, @type, id)
  end

  # Método para deletar um log
  def self.delete(db, id : Int32)
    db.exec(%{
      DELETE FROM logs
      WHERE id = $1
    }, id)
  end

  # Método para transformar os logs
  def self.transform_logs(logs : DBResult) : ListOfLogs
    list_of_logs = ListOfLogs.new

    logs.each do
      log = {
        "id"             => logs.read(Int32),
        "user_id"        => logs.read(Int32),
        "protocol_number"=> logs.read(Int32),
        "date"           => logs.read(Time),
        "type"           => logs.read(String),
      }
      list_of_logs << log
    end

    list_of_logs
  end
end
