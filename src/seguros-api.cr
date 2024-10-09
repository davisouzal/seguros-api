require "kemal"
require "json"
require "pg"
require "./insurance/model.cr"

DB_URL = "postgres://postgres:postgres@localhost/seguros_db"
db = PG.connect(DB_URL)

module Seguros::Api
  VERSION = "0.1.0"

  # post "/users" do |env|
  #   begin
  #     json_data = JSON.parse(env.request.body.not_nil!)

  #     name = json_data["name"].as_s
  #     email = json_data["email"].as_s

  #     db.exec("INSERT INTO users (name, email) VALUES ($1, $2)", name, email)

  #     env.response.print({message: "User created successfully"}.to_json)
  #   rescue ex : Exception
  #     env.response.print({error: ex.message}.to_json)
  #   end
  # end

  # get "/users" do |env|
  #   begin
  #     users = [] of Hash(String, String)

  #     result = db.query("SELECT name, email FROM users")
  #     result.each do
  #       user = {
  #         "name"  => result.read(String),
  #         "email" => result.read(String),
  #       }
  #       users << user
  #     end

  #     env.response.print(users.to_json)
  #   rescue ex : Exception
  #     env.response.print({error: ex.message}.to_json)
  #   end
  # end

  get "/insurance" do |env|
    begin
      insurances = Insurance.get_all(db) # Usando o método do modelo

      #env.response.print(insurances.to_json)
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