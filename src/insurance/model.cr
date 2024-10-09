# insurance.cr
require "pg"
require "json"

class Insurance
  # Atributos do modelo
  property id : Int32?
  property user_id : Int32
  property type : String
  property max_coverage : Float64
  property start_date : String
  property end_date : String

  # Construtor
  def initialize(@user_id : Int32, @type : String, @max_coverage : Float64, @start_date : String, @end_date : String)
  end

  # Método para salvar um novo seguro no banco de dados
  def save(db)
    db.exec("INSERT INTO insurance (user_id, type, max_coverage, start_date, end_date) VALUES ($1, $2, $3, $4, $5)",
      @user_id, @type, @max_coverage, @start_date, @end_date)
  end

  # Método para obter um seguro pelo ID
  def self.get(db, id : Int32) : Insurance?
    result = db.query("SELECT id, user_id, type, max_coverage, start_date, end_date FROM seguros WHERE id = $1", id)

    if result.any?
      row = result.first
      return Insurance.new(row["user_id"].to_i32, row["type"].to_s, row["max_coverage"].to_f64,
        row["start_date"].to_s, row["end_date"].to_s)
    end

    return nil
  end

  # Método para obter todos os seguros
  def self.get_all(db) : Array(Insurance)
    insurances = [] of Insurance
    result = db.query("SELECT id, user_id, type, max_coverage, start_date, end_date FROM seguros")

    result.each do
      insurance = {
        "id"           => result.read(Int32),
        "user_id"      => result.read(Int32),
        "type"         => result.read(String),
        "max_coverage" => result.read(Float64),
        "start_date"   => result.read(String),
        "end_date"     => result.read(String),
      }

      #insuranceObject = Insurance.new(insurance["id"], insurance["user_id"], insurance["type"], insurance["max_coverage"], insurance["start_date"], insurance["end_date"])

      #insurances << insuranceObject
    end
    return insurances
  end
end
