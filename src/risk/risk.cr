class Risk
    def initialize(@risk : Int32)
    end

    def self.calcular_risco_usuario(age : Int32, salary : Float64, marital_status : String) : Float64
        risco = 0.0
      
        # Peso Idade
        if age < 25
          risco += age * 0.2
        elsif age <= 55
          risco += age * 0.1
        else
          risco += age * 0.15
        end
      
        # Peso Renda
        if salary < 500_000  # Exemplo: abaixo de 5 mil reais
          risco += 0.2
        elsif salary >= 1_000_000  # Exemplo: acima de 10 mil reais
          risco -= 0.1
        end
      
        # Peso Estado Civil
        case marital_status
        when "Casado"
          risco -= 0.1
        when "Solteiro", "Divorciado"
          risco += 0.1
        when "Viúvo"
          risco += 0.2
        end
        
        risco += 0.1
        risco
    end
end