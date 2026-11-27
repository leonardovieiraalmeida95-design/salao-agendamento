# App de Agendamento para Salão

Sistema de agendamento e gestão para salões de beleza: agenda por profissional, escala da equipe, catálogo de serviços, pagamentos, painel da gestora e link de agendamento online enviado pelo WhatsApp.

**Protótipo clicável:** https://claude.ai/artifact/9x1rwChaxVoLGmu56L1Eec

## Telas do protótipo

| Tela | Arquivo | Quem usa | O que faz |
|---|---|---|---|
| Agenda do dia | `prototipo/Main.dc.html` | Recepção, gestora | Agenda por profissional, registro de pagamento, falta, novo agendamento manual, envio do link pelo WhatsApp |
| Escala | `prototipo/Escala.dc.html` | Gestora | Dias de trabalho e folga de cada profissional, horas por semana |
| Serviços | `prototipo/Servicos.dc.html` | Gestora | Duração, preço, sinal, quem faz, disponível online ou não |
| Pagamentos | `prototipo/Dashboard.dc.html` | Gestora | Faturamento, formas de pagamento, comissões |
| Painel da Gestora | `prototipo/Gestora.dc.html` | Só gestora | Total de agendamentos, inadimplências, desmarques, serviço mais pedido, desempenho por colaborador |
| Link de agendamento | `prototipo/Cliente.dc.html` | Cliente final | Escolhe serviço → profissional → horário → paga sinal via Pix |

Os arquivos `.dc.html` são o código-fonte das telas do protótipo (formato do canvas de design) e servem de referência visual para o desenvolvimento. O app de verdade será construído do zero (ver Stack).

## Escopo do MVP

1. Cadastro de serviços (duração, preço, sinal, profissionais habilitados)
2. Cadastro de profissionais, escala semanal, bloqueios e % de comissão
3. Agenda por dia e por profissional, com status: agendado, confirmado, pago, faltou, desmarcado
4. Agendamento manual pela recepção/gestora
5. Link público de agendamento, enviado pelo WhatsApp
6. Lembrete automático por WhatsApp (1 dia antes)
7. Registro de pagamento (Pix, cartão, dinheiro) e sinal via Pix
8. Dashboard de pagamentos e painel da gestora
9. Perfis de acesso: gestora, recepção, profissional

## Stack sugerida

- **Front + back:** Next.js (App Router) + TypeScript
- **Banco e login:** Supabase (Postgres + Auth + Row Level Security para os perfis)
- **Pix:** Asaas ou Mercado Pago
- **WhatsApp:** link `wa.me` no MVP; API oficial da Meta (ou Z-API) para lembretes automáticos
- **Hospedagem:** Vercel

## Documentação

- [`docs/regras-de-negocio.md`](docs/regras-de-negocio.md): disponibilidade, link do WhatsApp x agendamento manual, sinal, comissão, inadimplência
- [`docs/modelo-de-dados.sql`](docs/modelo-de-dados.sql): esquema inicial do banco (Postgres/Supabase)

## Roteiro

- [ ] Validar o protótipo com 5 a 10 salões
- [ ] Fechar escopo e preço
- [ ] Criar projeto Next.js + Supabase
- [ ] Agenda + serviços + profissionais
- [ ] Link público de agendamento
- [ ] Pagamentos + Pix
- [ ] Painel da gestora
- [ ] Piloto com 1 ou 2 salões
