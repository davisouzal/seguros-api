require "kemal"
require "json"
require "pg"
require "./insurance/model.cr"
require "./claim/model.cr"

DB_URL = "postgres://postgres:postgres@localhost/seguros_db"
db = PG.connect(DB_URL)

module Seguros::Api
  VERSION = "0.1.0"

  get "/insurance" do |env|
    begin
      env.response.print(Insurance.get_all(db).to_json)
    rescue ex : Exception
      env.response.print({error: ex.message}.to_json)
    end
  end

  get "/insurance/:id" do |env|
    begin
      id = env.params.url["id"].to_i32
      env.response.print(Insurance.get_by_id(db, id).to_json)
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

  put "/insurance/:id" do |env|
    begin
      id = env.params.url["id"].to_i32
      json_data = JSON.parse(env.request.body.not_nil!)
      insurance = Insurance.new(json_data["user_id"].as_s.to_i32,
        json_data["type"].as_s,
        json_data["max_coverage"].as_s.to_f64,
        json_data["start_date"].as_s,
        json_data["end_date"].as_s)
      udpatedData = insurance.update(db, id)

      env.response.print({message: "Insurance updated successfully"}.to_json)

    rescue ex : Exception
      env.response.print({error: ex.message}.to_json)
    end
  end

  delete "/insurance/:id" do |env|
    begin
      id = env.params.url["id"].to_i32
      ! p 
      Insurance.delete(db, id)

      env.response.print({message: "Insurance deleted successfully"}.to_json)
    rescue ex : Exception
      env.response.print({error: ex.message}.to_json)
    end
  end

  # Rota para obter todos os sinistros
  get "/claim" do |env|
    begin
      env.response.print(Claim.get_all(db).to_json)
    rescue ex : Exception
      env.response.print({error: ex.message}.to_json)
    end
  end

  # Rota para obter um sinistro pelo ID
  get "/claim/:id" do |env|
    begin
      id = env.params.url["id"].to_i32
      env.response.print(Claim.get_by_id(db, id).to_json)
    rescue ex : Exception
      env.response.print({error: ex.message}.to_json)
    end
  end

  # Rota para criar um novo sinistro
  post "/claim" do |env|
    begin
      json_data = JSON.parse(env.request.body.not_nil!)
  
      claim = Claim.new(
        json_data["insurance_id"].as_s.to_i32,
        json_data["claim_number"].as_s.to_f64,
        json_data["claim_date"].as_s,
        json_data["end_date"].as_s,
        json_data["claim_amount"].as_s.to_f64,
        json_data["status"].as_s
      )
  
      claim.save(db) # Salvando no banco de dados
  
      env.response.print({message: "Claim created successfully"}.to_json)
    rescue ex : Exception
      env.response.print({error: ex.message}.to_json)
    end
  end
  

  # Rota para atualizar um sinistro pelo ID
  put "/claim/:id" do |env|
    begin
      id = env.params.url["id"].to_i32

      json_data = JSON.parse(env.request.body.not_nil!)
      
      claim = Claim.new(
        json_data["insurance_id"].as_s.to_i32,
        json_data["claim_number"].as_s.to_f64,
        json_data["claim_date"].as_s,
        json_data["end_date"].as_s,
        json_data["claim_amount"].as_s.to_f64,
        json_data["status"].as_s
      )
      claim.update(db, id)

      env.response.print({message: "Claim updated successfully"}.to_json)
    rescue ex : Exception
      env.response.print({error: ex.message}.to_json)
    end
  end

  # Rota para deletar um sinistro pelo ID
  delete "/claim/:id" do |env|
    begin
      id = env.params.url["id"].to_i32
      Claim.delete(db, id)

      env.response.print({message: "Claim deleted successfully"}.to_json)
    rescue ex : Exception
      env.response.print({error: ex.message}.to_json)
    end
  end

  Kemal.run
end