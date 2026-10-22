# Modelo Relacional — Base de Dados do Hotel

**Notação:** `tabela(atributo[PK], atributo, #chave_estrangeira)`  
`[PK]` marca os atributos da chave primária; `#` marca as chaves estrangeiras, indicadas abaixo de cada tabela.

## Tabelas

```
hospede(id_hospede[PK], nome, apelido, documento, telefone, email, nacionalidade, data_nascimento)

funcionario(id_funcionario[PK], nome, cargo, telefone, data_admissao, salario)

tipo_quarto(id_tipo[PK], nome, descricao, capacidade, preco_noite)

servico(id_servico[PK], nome, preco)

quarto(id_quarto[PK], numero, andar, #id_tipo, estado)
    #id_tipo           -> tipo_quarto(id_tipo)

reserva(id_reserva[PK], #id_hospede, #id_quarto, #id_funcionario, data_reserva,
        data_check_in, data_check_out, n_hospedes, estado, observacoes)
    #id_hospede        -> hospede(id_hospede)
    #id_quarto         -> quarto(id_quarto)
    #id_funcionario    -> funcionario(id_funcionario)

consumo_servico(#id_reserva[PK], #id_servico[PK], data_consumo[PK], quantidade, preco_unitario)
    #id_reserva        -> reserva(id_reserva)
    #id_servico        -> servico(id_servico)

pagamento(#id_reserva[PK], num_pagamento[PK], data_pagamento, valor, metodo, descricao)
    #id_reserva        -> reserva(id_reserva)        (entidade fraca)
```

## Chaves primárias e estrangeiras (resumo)

| Tabela | Chave primária | Chaves estrangeiras |
|---|---|---|
| hospede | id_hospede | — |
| funcionario | id_funcionario | — |
| tipo_quarto | id_tipo | — |
| servico | id_servico | — |
| quarto | id_quarto | id_tipo → tipo_quarto |
| reserva | id_reserva | id_hospede → hospede; id_quarto → quarto; id_funcionario → funcionario |
| consumo_servico | (id_reserva, id_servico, data_consumo) | id_reserva → reserva; id_servico → servico |
| pagamento | (id_reserva, num_pagamento) | id_reserva → reserva |

## Cardinalidades e participação

| Relação | Cardinalidade | Participação |
|---|---|---|
| hospede **faz** reserva | 1 : N | Reserva: total (toda reserva tem um hóspede). Hóspede: parcial (pode estar registado sem reservas). |
| funcionario **regista** reserva | 1 : N | Reserva: total. Funcionário: parcial. |
| quarto **é reservado em** reserva | 1 : N | Reserva: total. Quarto: parcial. |
| tipo_quarto **classifica** quarto | 1 : N | Quarto: total. Tipo de quarto: parcial. |
| reserva **consome** servico | N : M (via `consumo_servico`) | Ambas parciais: uma reserva pode não consumir serviços extra e um serviço pode nunca ser consumido. |
| reserva **é paga por** pagamento | 1 : N (identificadora) | Pagamento: total (não existe sem reserva). Reserva: parcial (ex.: reserva cancelada sem pagamento). |

## Decisões de conceção

- **Entidade fraca — `pagamento`:** não tem identificador próprio completo; só existe associada a uma reserva. A chave primária é composta por `id_reserva` (chave da entidade forte) mais `num_pagamento` (discriminador: 1.º, 2.º pagamento da reserva, etc.).
- **Relação N:M — reserva e servico:** resolvida pela tabela associativa `consumo_servico`. Inclui `data_consumo` na chave para permitir o mesmo serviço em dias diferentes, e `preco_unitario` para guardar o preço cobrado na data (o preço do serviço pode mudar depois).
- **Total da reserva não é guardado:** é calculado (noites × `preco_noite` + serviços consumidos), evitando redundância e inconsistência.
- **Integridade:** todas as chaves estrangeiras usam `ON DELETE RESTRICT` (não se apaga um registo que tenha dependentes) e `ON UPDATE CASCADE`. Há restrições `CHECK` (estados válidos, `check_out > check_in`, valores positivos).
- **Normalização:** o modelo está na 3.ª Forma Normal. Os dados do tipo de quarto (capacidade, preço) estão em `tipo_quarto` e não repetidos em cada quarto.
