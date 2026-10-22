# Modelo Relacional de Dados - Gestão Hoteleira

## Esquema Relacional das Tabelas

1. **categoria_quarto** (
   **id_categoria** INT PRIMARY KEY AUTO_INCREMENT,
   nome_categoria VARCHAR(50) NOT NULL,
   descricao TEXT
   );
2. **quarto** (
   **id_quarto** INT PRIMARY KEY AUTO_INCREMENT,
   numero_quarto VARCHAR(10) UNIQUE NOT NULL,
   andar INT NOT NULL,
   preco_diaria DECIMAL(10,2) NOT NULL,
   estado VARCHAR(20) DEFAULT 'Disponível',
   *id_categoria* INT NOT NULL,
   FOREIGN KEY (id_categoria) REFERENCES categoria_quarto(id_categoria)
   );
3. **hospede** (
   **id_hospede** INT PRIMARY KEY AUTO_INCREMENT,
   nome VARCHAR(100) NOT NULL,
   email VARCHAR(100) UNIQUE NOT NULL,
   telefone VARCHAR(20) NOT NULL,
   documento_id VARCHAR(30) UNIQUE NOT NULL
   );
4. **reserva** (
   **id_reserva** INT PRIMARY KEY AUTO_INCREMENT,
   *id_hospede* INT NOT NULL,
   *id_quarto* INT NOT NULL,
   data_checkin DATE NOT NULL,
   data_checkout DATE NOT NULL,
   estado_reserva VARCHAR(20) DEFAULT 'Pendente',
   FOREIGN KEY (id_hospede) REFERENCES hospede(id_hospede),
   FOREIGN KEY (id_quarto) REFERENCES quarto(id_quarto)
   );
5. **servico** (
   **id_servico** INT PRIMARY KEY AUTO_INCREMENT,
   nome_servico VARCHAR(50) NOT NULL,
   preco DECIMAL(10,2) NOT NULL
   );
6. **consumo_servico** (
   **id_consumo** INT PRIMARY KEY AUTO_INCREMENT,
   *id_reserva* INT NOT NULL,
   *id_servico* INT NOT NULL,
   data_consumo DATETIME NOT NULL,
   quantidade INT DEFAULT 1,
   FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva),
   FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
   );
7. **pagamento** (
   **id_pagamento** INT PRIMARY KEY AUTO_INCREMENT,
   *id_reserva* INT UNIQUE NOT NULL,
   data_pagamento DATETIME NOT NULL,
   valor_pago DECIMAL(10,2) NOT NULL,
   metodo_pagamento VARCHAR(30) NOT NULL,
   FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva)
   );
