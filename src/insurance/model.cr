# insurance.cr
require "pg"
require "json"

class Insurance
  alias ListOfInsurances = Array(Hash(String, Float64 | Int32 | String | Time))
  alias Insurance = Hash(String, Float64 | Int32 | String | Time)
  alias DBConnection = PG::Connection
  alias DBResult = PG::ResultSet
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

  # Método para obter todos os seguros
  def self.get_all(db) : ListOfInsurances
    self.transform_insurances(db.query(%{
    SELECT
      *
    FROM insurance
    ORDER BY id
  }))
  end

  def self.get_by_id(db, id : Int32)
    result = db.query(%{
      SELECT
        id, user_id , type, max_coverage, start_date, end_date
      FROM insurance
      WHERE id = $1
    }, id)

    self.transform_insurances(result)
  end

  def self.transform_insurances(insurances : DBResult) : ListOfInsurances
    list_of_insurances = ListOfInsurances.new

    insurances.each do
      insurance = {
        "id"           => insurances.read(Int32),
        "user_id"      => insurances.read(Int32),
        "type"         => insurances.read(String),
        "max_coverage" => insurances.read(Float64),
        "start_date"   => insurances.read(Time),
        "end_date"     => insurances.read(Time),
      }

      !p insurance

      list_of_insurances << insurance
    end
    list_of_insurances
  end  
end
