-- Esquema inicial (Postgres / Supabase)
create extension if not exists btree_gist;

create table saloes (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  slug text unique not null,            -- usado no link público: seuapp.com.br/<slug>
  whatsapp text,
  sinal_minimo_valor numeric(10,2) default 150,
  sinal_percentual numeric(5,2) default 30,
  criado_em timestamptz default now()
);

create type perfil_acesso as enum ('gestora', 'recepcao', 'profissional');

create table usuarios (
  id uuid primary key references auth.users(id),
  salao_id uuid not null references saloes(id),
  nome text not null,
  perfil perfil_acesso not null
);

create table profissionais (
  id uuid primary key default gen_random_uuid(),
  salao_id uuid not null references saloes(id),
  usuario_id uuid references usuarios(id),
  nome text not null,
  funcao text,
  comissao_percentual numeric(5,2) not null default 40,
  ativo boolean default true
);

create table escalas (
  id uuid primary key default gen_random_uuid(),
  profissional_id uuid not null references profissionais(id),
  dia_semana smallint not null check (dia_semana between 0 and 6),
  inicio time not null,
  fim time not null,
  intervalo_inicio time,
  intervalo_fim time
);

create table bloqueios (
  id uuid primary key default gen_random_uuid(),
  profissional_id uuid not null references profissionais(id),
  periodo tstzrange not null,
  motivo text
);

create table servicos (
  id uuid primary key default gen_random_uuid(),
  salao_id uuid not null references saloes(id),
  nome text not null,
  categoria text,
  duracao_min int not null,
  preco numeric(10,2) not null,
  disponivel_online boolean default true,
  ativo boolean default true
);

create table servicos_profissionais (
  servico_id uuid references servicos(id),
  profissional_id uuid references profissionais(id),
  primary key (servico_id, profissional_id)
);

create table clientes (
  id uuid primary key default gen_random_uuid(),
  salao_id uuid not null references saloes(id),
  nome text not null,
  whatsapp text,
  criado_em timestamptz default now()
);

create type status_agendamento as enum
  ('aguardando_sinal', 'agendado', 'confirmado', 'concluido', 'pago', 'faltou', 'desmarcado');
create type origem_agendamento as enum ('link', 'recepcao');

create table agendamentos (
  id uuid primary key default gen_random_uuid(),
  salao_id uuid not null references saloes(id),
  cliente_id uuid not null references clientes(id),
  profissional_id uuid not null references profissionais(id),
  servico_id uuid not null references servicos(id),
  periodo tstzrange not null,
  valor numeric(10,2) not null,
  status status_agendamento not null default 'agendado',
  origem origem_agendamento not null,
  criado_por uuid references usuarios(id),   -- null quando veio do link
  desmarcado_em timestamptz,
  criado_em timestamptz default now(),
  -- impede dois agendamentos ativos no mesmo horário para o mesmo profissional,
  -- venham do link ou da recepção
  exclude using gist (
    profissional_id with =,
    periodo with &&
  ) where (status not in ('faltou', 'desmarcado'))
);

create type forma_pagamento as enum ('pix', 'cartao', 'dinheiro');

create table pagamentos (
  id uuid primary key default gen_random_uuid(),
  agendamento_id uuid not null references agendamentos(id),
  valor numeric(10,2) not null,
  forma forma_pagamento not null,
  eh_sinal boolean default false,
  pago_em timestamptz default now()
);

create table comissoes (
  id uuid primary key default gen_random_uuid(),
  pagamento_id uuid not null references pagamentos(id),
  profissional_id uuid not null references profissionais(id),
  percentual numeric(5,2) not null,
  valor numeric(10,2) not null,
  paga boolean default false
);
