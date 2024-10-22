require "kemal"
require "json"
require "pg"
require "./insurance/model.cr"

DB_URL = "postgres://postgres:postgres@localhost/seguros_db"
db = PG.connect(DB_URL)

module Seguros::Api
  VERSION = "0.1.0"

  get "/insurance" do |env|
    begin
      insurances = Insurance.get_all(db) # Usando o método do modelo
      env.response.content_type = "application/json"
      env.response.print(insurances.to_json)
    rescue ex : Exception
      env.response.print({error: ex.message}.to_json)
    end
  end

  post "/insurance" do |env|
    begin
      json_data = JSON.parse(env.request.body.not_nil!)
      insurance = Insurance.new(json_data["user_id"].as_s.to_i32,
        json_data["type"].as_s,
        json_data["max_coverage"].as_s.to_f64,
        json_data["start_date"].as_s,
        json_data["end_date"].as_s)
      insurance.save(db) # Salvando no banco de dados

      env.response.print({message: "Insurance created successfully"}.to_json)
    rescue ex : Exception
      env.response.print({error: ex.message}.to_json)
    end
  end

  Kemal.run
end