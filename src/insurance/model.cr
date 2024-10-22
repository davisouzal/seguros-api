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

  # Método para obter todos os seguros
  def self.get_all(db)
    result = db.exec("SELECT * FROM insurance")

    insurances = [] of Insurance

    result.each do |row|
      insurance = Insurance.new(
        row["user_id"].to_i32,
        row["type"],
        row["max_coverage"].to_f64,
        row["start_date"],
        row["end_date"]
      )
      insurance.id = row["id"].to_i32
      insurances << insurance
    end

    insurances
  end

  def to_json(*)
    {
      "id" => @id,
      "user_id" => @user_id,
      "type" => @type,
      "max_coverage" => @max_coverage,
      "start_date" => @start_date,
      "end_date" => @end_date
    }.to_json
  end
end
