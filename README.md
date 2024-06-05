# projeto_ble_renew


<h2 align="center">
<img src="https://img.shields.io/badge/web-%3F-blue?style=for-the-badge" alt="Sistema web ?" />  
<img src="https://img.shields.io/badge/Mobile-OK-blue?style=for-the-badge" alt="Aplicativo mobile Ok" />   
<img src="https://img.shields.io/badge/Desktop-OK-blue?style=for-the-badge" alt="Sistema desktop Ok" />    


![Static Badge](https://img.shields.io/badge/Status-EM_DESENVOLVIMENTO-green)   

</h2>

> [!NOTE]
> 📌Projeto Flutter de Controle de fluxo de pessoas e equipamentos em hospital   
> **Codelink 2024**

## ✔️ Técnicas e tecnologias utilizadas

- ``Flutter 3.22.0``
- ``Dart 3.4.0``
- ``Android Studio/Visual Studio Code``
- ``Supabase(Postgres)``
<p align="center">
    <img src="https://skillicons.dev/icons?i=git,dart,flutter,supabase,vscode" alt="icons"/>
</p>

## TO DO

https://supabase.com/docs/reference/dart/stream 

- [x] MAPA ou equivalente
- [x] Coleta foto e dados de irregularidade e os envia para SWCentral
- [x] Finalizar foto_registro_alarme.dart
- [x] Mapa de localização de um TAG específico
- [x] Mapa de localização os TAGs no hospital (com recurso de zoom in/out)
- [x] Tratamento dos alarmes
- [ ] Notificações dos alarmes(PUSH) (FireBase)
- [x] Terminar hero da pesquisa exibir usuario se vinculado   
- [x] View para os heros
- [x] Exibir informações do ble no hero (tag, data/hora entrada e saída)
- [x] Verificar rotas ao voltar (Scan Blue)   
- [x] Trigger para dispositivo ficar true ao vincular
- [x] Dispositivos ativos não devem aparecer na lista de vincular
- [x] Criar opção de DESVINCULAR dispositivo  
- [x] Regras de negócio para usuário e dispositivo único  
- [x] Mapa com RFID ou lista   
- [x] Ajustar layout para desktop +/-
- [ ] Verificar as deleções   
- [ ] Vincular equipamento area   
- [ ] Quando paciente for dependente vincular externo
- [x] Cadastro de usuario no auth 
- [ ] trigger para update em pessoa_fisica e delete
- [X] Atualizar documentação
- [x] View para os alarmes 
- [x] Vincular dispositivo: Não exibir pessoa/dispositivo vinculado na busca
- [x] Verificar coluna area_id de pessoa_fisica (excluir)
- [ ] corrigir busca do externo no pesquisa.dart ??? Não lembro :(
- [x] Atualizar funcionário/equipamento após inserir
- [x] Mensagem de falha ao inserir paciente
- [ ] No listar dispositivo, incluir opção de editar
- [x] Ajustar padrão do ScaffoldMessenger
- [ ] QUANDO DESVINCULAR FAZER OUTRO INSERT PARA VINCULAR NÃO É UPDATE
- [x] Dispose no menu Pesquisa
- [ ] Banco de dados em cache


## 📁 Acesso ao projeto
Você pode acessar os arquivos do projeto clicando [aqui](https://github.com/ericamila/projeto_ble_renew/tree/main/lib).

## Banco de Dados

### [Supabase](https://supabase.com/)
>https://pub.dev/packages/supabase_flutter

#### Tabela alarme
````sql
CREATE TABLE public.alarmes (
    id bigint GENERATED BY DEFAULT AS IDENTITY,
    codigo CHARACTER varying NULL,
    descricao CHARACTER varying NULL,
    CONSTRAINT alarmes_pkey PRIMARY KEY (id)
) TABLESPACE pg_default;
````

#### Tabela area
````sql
CREATE TABLE public.area (
    id bigint GENERATED BY DEFAULT AS IDENTITY,
    descricao CHARACTER varying NULL,
    hospital integer NULL,
    CONSTRAINT area_pkey PRIMARY KEY (id),
    CONSTRAINT public_area_hospital_fkey FOREIGN KEY (hospital) REFERENCES pessoa_juridica (id) ON DELETE CASCADE
) TABLESPACE pg_default;
````

#### Tabela cargo
````sql
CREATE TABLE public.cargo (
    id bigint GENERATED BY DEFAULT AS IDENTITY,
    descricao CHARACTER varying NULL,
    CONSTRAINT cargo_pkey PRIMARY KEY (id)
) TABLESPACE pg_default;
````

#### Tabela dispositivo
````sql
CREATE TABLE public.dispositivo (
    id UUID NOT NULL DEFAULT GEN_RANDOM_UUID (),
    nome CHARACTER varying NULL,
    tag CHARACTER varying NULL,
    tipo CHARACTER varying NULL,
    mac CHARACTER varying NULL,
    status BOOLEAN NULL DEFAULT FALSE,
    CONSTRAINT dispositivo_pkey PRIMARY KEY (id)
) TABLESPACE pg_default;
````

#### Tabela dispositivo_pessoa
````sql
CREATE TABLE public.dispositivo_pessoa (
    id bigint GENERATED BY DEFAULT AS IDENTITY,
    data_time_inicio TIMESTAMP WITHOUT TIME ZONE NULL DEFAULT now(),
    data_time_fim TIMESTAMP WITHOUT TIME ZONE NULL,
    dispositivo_id UUID NULL DEFAULT GEN_RANDOM_UUID (),
    pessoa_id UUID NULL,
    vinculado BOOLEAN NULL DEFAULT TRUE,
    CONSTRAINT dispositivo_usuario_pkey PRIMARY KEY (id), 
    CONSTRAINT public_dispositivo_pessoa_dispositivo_id_fkey
    FOREIGN KEY (dispositivo_id) REFERENCES dispositivo (id),
    CONSTRAINT public_dispositivo_pessoa_pessoa_id_fkey
    FOREIGN KEY (pessoa_id) REFERENCES pessoa_fisica (id)
) TABLESPACE pg_default;
````

#### Tabela equipamento
````sql
CREATE TABLE public.equipamento(
    id UUID NOT NULL DEFAULT GEN_RANDOM_UUID (),
    descricao CHARACTER VARYING NULL,
    tipo CHARACTER VARYING NULL,
    codigo CHARACTER VARYING NULL,
    foto TEXT NULL,
    CONSTRAINT equipamento_pkey PRIMARY KEY (id),
) TABLESPACE pg_default;
````

#### Tabela externo
````sql
CREATE TABLE public.externo(
    id UUID NOT NULL DEFAULT GEN_RANDOM_UUID (),
    nome CHARACTER VARYING NULL,
    cpf CHARACTER VARYING NULL,
    tipo_externo CHARACTER VARYING NULL,
    foto TEXT NULL,
    area_id BIGINT NULL,
    externo_id UUID NULL,
    CONSTRAINT externo_pkey PRIMARY KEY (id), 
    CONSTRAINT public_externo_area_id_fkey FOREIGN KEY (area_id) REFERENCES area (id),
    CONSTRAINT public_externo_externo_id_fkey FOREIGN KEY (externo_idid) REFERENCES externo (id),
) TABLESPACE pg_default;
````

#### Tabela funcionario
````sql
CREATE TABLE public.funcionario (
    id UUID NOT NULL DEFAULT GEN_RANDOM_UUID (),
    nome CHARACTER VARYING NULL,
    cpf CHARACTER VARYING NULL,
    cargo_id BIGINT NULL,
    foto TEXT NULL,
    tipo_externo CHARACTER VARYING NULL DEFAULT 'Funcionário'::CHARACTER VARYING,
    CONSTRAINT funcionario_pkey PRIMARY KEY (id), 
    CONSTRAINT public_funcionario_cargo_id_fkey
    FOREIGN KEY (cargo_id) REFERENCES cargo (id),
) TABLESPACE pg_default;
````

#### Tabela pessoa_fisica
````sql
CREATE TABLE public.pessoa_fisica(
    id UUID NOT NULL DEFAULT GEN_RANDOM_UUID (),
    nome CHARACTER VARYING NULL,
    cpf CHARACTER VARYING NULL,
    area_id BIGINT NULL,
    tipo_externo CHARACTER VARYING NULL,
    CONSTRAINT usuario_pkey PRIMARY KEY (id), 
    CONSTRAINT public_pessoa_fisica_area_id_fkey
    FOREIGN KEY (area_id) REFERENCES area (id)
) TABLESPACE pg_default;
````

#### Tabela pessoa_juridica
````sql
CREATE TABLE public.pessoa_juridica(
    id BIGINT GENERATED BY DEFAULT AS IDENTITY,
    nome CHARACTER VARYING NOT NULL,
    cnpj CHARACTER VARYING NULL,
    logo TEXT NULL,
    CONSTRAINT pessoa_juridica_pkey PRIMARY KEY (id)
) TABLESPACE pg_default;
````

#### Tabela raspberry
````sql
CREATE TABLE public.raspberry (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY,
    descricao CHARACTER VARYING NULL,
    area_id BIGINT NULL,
    mac CHARACTER varying NULL,
    ip CHARACTER varying NULL,
    status BOOLEAN NULL DEFAULT TRUE,
    CONSTRAINT raspberry_pkey PRIMARY KEY (id), 
    CONSTRAINT raspberry_mac_key UNIQUE (mac), 
    CONSTRAINT public_raspberry_area_id_fkey
    FOREIGN KEY (area_id) REFERENCES area(id)
) TABLESPACE pg_default;
````

#### Tabela registro_movimentacao
````sql
CREATE TABLE public.registro_movimentacao (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    data_hora TIMESTAMP WITHOUT TIME ZONE NULL,
    alarme_id INTEGER NULL,
    raspberry_id BIGINT NULL,
    dispositivo_id UUID NULL,
    closed BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT registro_movimentacao_pkey PRIMARY KEY (id), 
    CONSTRAINT public_registro_movimentacao_alarme_id_fkey
    FOREIGN KEY (alarme_id) REFERENCES alarmes (id),
    CONSTRAINT public_registro_movimentacao_dispositivo_id_fkey
    FOREIGN KEY (dispositivo_id) REFERENCES dispositivo (id),
    CONSTRAINT public_registro_movimentacao_raspberry_id_fkey
    FOREIGN KEY (raspberry_id) REFERENCES raspberry (id)
) TABLESPACE pg_default;
````

#### Tabela tb_registro_alarmes_new
````sql
CREATE TABLE public.tb_registro_alarmes_new (
    id BIGINT NOT NULL,
    data_hora timestamp without time zone null,
    codigo character varying null,
    alarme character varying null,
    tag character varying null,
    tipo character varying null,
    status boolean null,
    mac character varying null,
    area character varying null,
    nome character varying null,
    tipo_externo character varying null,
    id_pessoa uuid null,
    closed boolean null,
    descricao CHARACTER VARYING NULL,
    constraint tb_registro_alarmes_new_pkey primary key (id)
) TABLESPACE pg_default;
````

#### Tabela usuario
````sql
CREATE TABLE public.usuario(
    id UUID NOT NULL DEFAULT GEN_RANDOM_UUID (),
    created_at timestamp with time zone not null default now(),
    username CHARACTER VARYING NULL,
    email CHARACTER VARYING NULL,
    funcionario_id UUID NULL,
    uid UUID NULL default auth.uid (),
    foto text null default 'https://cavikcnsdlhepwnlucge.supabase.co/storage/v1/object/public/profile/nophoto.png'::text,
    CONSTRAINT usuario_pkey1 PRIMARY KEY (id), 
    CONSTRAINT public_usuarios_funcionario_id_fkey
    FOREIGN KEY (funcionario_id) REFERENCES funcionario (id) ON DELETE CASCADE,
    CONSTRAINT public_usuarios_uid_fkey
    FOREIGN KEY (uid) REFERENCES auth.users (id) ON DELETE CASCADE,
) TABLESPACE pg_default;
````

#### Visão vw_dispositivos_usuarios
````sql
CREATE VIEW public.vw_dispositivos_usuarios AS
SELECT UPPER(pessoa_fisica.nome) AS nome,
    dispositivo.mac,
    dispositivo.tipo,
    dispositivo.tag,
    dispositivo_pessoa.id,
    pessoa_fisica.id as pessoa_id, 
    pessoa_fisica.tipo_externo,
    dispositivo_pessoa.data_time_inicio
FROM dispositivo_pessoa
JOIN pessoa_fisica ON dispositivo_pessoa.pessoa_id = pessoa_fisica.id
JOIN dispositivo ON dispositivo_pessoa.dispositivo_id = dispositivo.id
WHERE dispositivo_pessoa.vinculado = 'TRUE';
````

#### Visão vw_dispositivos_usuarios_all
````sql
CREATE VIEW public.vw_dispositivos_usuarios_all AS
SELECT UPPER(pessoa_fisica.nome) AS nome,
    dispositivo.mac,
    dispositivo.tipo,
    dispositivo.tag,
    dispositivo_pessoa.id,
    pessoa_fisica.id as pessoa_id, 
    pessoa_fisica.tipo_externo,
    dispositivo_pessoa.data_time_inicio
FROM dispositivo_pessoa
JOIN pessoa_fisica ON dispositivo_pessoa.pessoa_id = pessoa_fisica.id
JOIN dispositivo ON dispositivo_pessoa.dispositivo_id = dispositivo.id;
````

#### Visão vw_registro_alarmes
````sql
CREATE OR REPLACE VIEW vw_registro_alarmes AS
SELECT  registro_movimentacao.id, data_hora, codigo, alarmes.descricao AS alarme,
    tag, tipo, dispositivo.status,dispositivo.mac, area.descricao AS area,
    pessoa_fisica.nome, pessoa_fisica.tipo_externo, pessoa_fisica.id as id_pessoa
FROM registro_movimentacao
    LEFT JOIN alarmes ON alarmes.id = registro_movimentacao.alarme_id
    LEFT JOIN raspberry ON raspberry.id = registro_movimentacao.raspberry_id
    LEFT JOIN area ON area.id = raspberry.area_id
    LEFT JOIN dispositivo ON dispositivo.id = registro_movimentacao.dispositivo_id
    LEFT JOIN dispositivo_pessoa ON dispositivo_pessoa.dispositivo_id = dispositivo.id
    LEFT JOIN pessoa_fisica ON dispositivo_pessoa.pessoa_id = pessoa_fisica.id
WHERE data_hora BETWEEN  dispositivo_pessoa.data_time_inicio AND dispositivo_pessoa.data_time_fim
    OR data_hora >=  dispositivo_pessoa.data_time_inicio AND dispositivo_pessoa.data_time_fim IS NULL
    AND codigo != 'null';
````

#### Visão vw_dispositivos_livres
````sql
CREATE OR REPLACE VIEW vw_dispositivos_livres AS
SELECT * FROM dispositivo
WHERE dispositivo.id NOT IN 
(SELECT dispositivo_pessoa.dispositivo_id FROM dispositivo_pessoa WHERE vinculado = 'true');
````

#### Visão vw_pessoas_livres
````sql
CREATE OR REPLACE VIEW vw_pessoas_livres AS
SELECT * FROM pessoa_fisica
WHERE pessoa_fisica.id NOT IN
(SELECT dispositivo_pessoa.pessoa_id FROM dispositivo_pessoa WHERE vinculado = 'true');
````

#### Triggers
````sql
CREATE TRIGGER insert_person_externo
AFTER INSERT ON externo
FOR EACH ROW
EXECUTE FUNCTION update_pessoa_fisica();
````
#### Functions
````sql
CREATE FUNCTION update_pessoa_fisica()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO pessoa_fisica(id, nome, cpf, tipo_externo)
  VALUES (new.id, new.nome, new.cpf, new.tipo_externo);
  RETURN new;
END;
$$;
````

#### Triggers
````sql
CREATE OR REPLACE TRIGGER update_dispositivo_pessoas
AFTER INSERT OR UPDATE ON dispositivo_pessoa
FOR EACH ROW
EXECUTE FUNCTION update_dispositivos();
````
#### Functions
````sql
CREATE OR REPLACE FUNCTION update_dispositivos()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
UPDATE dispositivo set status = new.vinculado
WHERE dispositivo.id = new.dispositivo_id;
RETURN NEW;
END;
$$;
````

#### Triggers
````sql
CREATE OR REPLACE TRIGGER insert_person
AFTER INSERT ON funcionario
FOR EACH ROW
EXECUTE FUNCTION update_pessoa_fisica ();
````
#### Functions
````sql
CREATE OR REPLACE FUNCTION update_pessoa_fisica ()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    insert into pessoa_fisica(id, nome, cpf, tipo_externo)
    values (new.id, new.nome, new.cpf, new.tipo_externo);
RETURN NEW;
END;
$$;
````

#### Triggers
````sql
CREATE OR REPLACE TRIGGER insert_registro
AFTER INSERT OR UPDATE ON registro_movimentacao 
FOR EACH ROW
EXECUTE FUNCTION insert_registro ();
````
#### Functions
````sql
CREATE OR REPLACE FUNCTION insert_registro ()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
insert into tb_registro_alarmes_new(SELECT  registro_movimentacao.id as id, data_hora, codigo, alarmes.descricao AS alarme,
    tag, tipo, dispositivo.status,dispositivo.mac, area.descricao AS area,
    pessoa_fisica.nome, pessoa_fisica.tipo_externo, pessoa_fisica.id as id_pessoa
FROM registro_movimentacao
    LEFT JOIN alarmes ON alarmes.id = registro_movimentacao.alarme_id
    LEFT JOIN raspberry ON raspberry.id = registro_movimentacao.raspberry_id
    LEFT JOIN area ON area.id = raspberry.area_id
    LEFT JOIN dispositivo ON dispositivo.id = registro_movimentacao.dispositivo_id
    LEFT JOIN dispositivo_pessoa ON dispositivo_pessoa.dispositivo_id = dispositivo.id
    LEFT JOIN pessoa_fisica ON dispositivo_pessoa.pessoa_id = pessoa_fisica.id
WHERE data_hora BETWEEN  dispositivo_pessoa.data_time_inicio AND dispositivo_pessoa.data_time_fim
    OR data_hora >=  dispositivo_pessoa.data_time_inicio AND dispositivo_pessoa.data_time_fim IS NULL
    AND codigo != 'null' and registro_movimentacao.id=new.id);
RETURN NEW;
END;
$$;
````

#### Triggers
````sql
CREATE OR REPLACE TRIGGER update_registro
AFTER UPDATE ON registro_movimentacao 
FOR EACH ROW
EXECUTE FUNCTION update_registro ();
````
#### Functions
````sql
CREATE OR REPLACE FUNCTION update_registro ()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  update tb_registro_alarmes_new set status = new.closed 
  where tb_registro_alarmes_new.id=new.id;
RETURN NEW;
END;
$$;
````


Schema in 16/05/2024
![img.png](img.png)

