# claim/model.cr
require "pg"
require "json"

class Claim
  alias ListOfClaims = Array(Hash(String, Float64 | Int32 | String | Time | Nil))
  alias Claim = Hash(String, Float64 | Int32 | String | Time | Nil)
  alias DBConnection = PG::Connection
  alias DBResult = PG::ResultSet

  # Atributos do modelo
  property id : Int32?
  property insurance_id : Int32
  property claim_number : Float64
  property claim_date : String
  property end_date : String?
  property claim_amount : Float64
  property status : String

  # Construtor
  def initialize(@insurance_id : Int32, @claim_number : Float64, @claim_date : String, @end_date : String?, @claim_amount : Float64, @status : String)
  end

  # Método para salvar um novo sinistro (claim) no banco de dados
  def save(db)
    db.exec("INSERT INTO claim (insurance_id, claim_number, claim_date, end_date, claim_amount, status) VALUES ($1, $2, $3, $4, $5, $6)",
      @insurance_id, @claim_number, @claim_date, @end_date, @claim_amount, @status)
  end

  # Método para obter todos os sinistros
  def self.get_all(db) : ListOfClaims
    self.transform_claims(db.query(%{
      SELECT
        *
      FROM claim
      ORDER BY id
    }))
  end

  def self.get_by_id(db, id : Int32)
    result = db.query(%{
      SELECT
        id, insurance_id, claim_number, claim_date, end_date, claim_amount, status
      FROM claim
      WHERE id = $1
    }, id)

    self.transform_claims(result)
  end

  def self.get_by_insurance_id(db, insurance_id : Int32)
    result = db.query(%{
      SELECT
        id, insurance_id, claim_number, claim_date, end_date, claim_amount, status
      FROM claim
      WHERE insurance_id = $1
    }, insurance_id)

    self.transform_claims(result)
  end

  def update(db, id : Int32)
    db.exec(%{
      UPDATE claim
      SET insurance_id = $1, claim_number = $2, claim_date = $3, end_date = $4, claim_amount = $5, status = $6
      WHERE id = $7
    }, @insurance_id, @claim_number, @claim_date, @end_date, @claim_amount, @status, id)
  end

  def self.delete(db, id : Int32)
    db.exec(%{
      DELETE FROM claim
      WHERE id = $1
    }, id)
  end

  def self.transform_claims(claims : DBResult) : ListOfClaims
    list_of_claims = ListOfClaims.new
  
    claims.each do
      claim = {
        "id"           => claims.read(Int32),
        "insurance_id" => claims.read(Int32),
        "claim_number" => claims.read(Float64),
        "claim_date"   => claims.read(Time),
        "end_date"     => claims.read(Time?),
        "claim_amount" => claims.read(Float64),
        "status"       => claims.read(String)
      }
      list_of_claims << claim
    end
  
    list_of_claims
  end
  
end
