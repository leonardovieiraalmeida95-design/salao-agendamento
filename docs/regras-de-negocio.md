# Regras de negócio

## 1. Disponibilidade (a regra mais importante)

Um horário está livre para um profissional quando:

```
horário livre = escala do dia − intervalo − bloqueios − agendamentos ativos
```

- Agendamento ativo = status `agendado`, `confirmado` ou `pago`. Status `faltou` e `desmarcado` liberam o horário.
- O serviço só cabe se `início + duração` não encostar em nenhum outro agendamento ativo.
- Slots de 30 em 30 minutos (configurável por salão).
- A checagem é feita **no banco**, na hora de salvar (constraint de exclusão por faixa de tempo), não só na tela. Isso impede que duas pessoas peguem o mesmo horário ao mesmo tempo.

## 2. Link do WhatsApp x agendamento manual

Os dois caminhos gravam na **mesma agenda** e passam pela mesma regra de disponibilidade. Um não anula o outro.

| | Link (cliente) | Manual (recepção/gestora) |
|---|---|---|
| Quem marca | A própria cliente | Recepção ou gestora |
| Por onde | Link público aberto pelo WhatsApp | Botão "+ Novo agendamento" na agenda |
| Serviços disponíveis | Só os marcados como "Online" | Todos |
| Sinal via Pix | Obrigatório em serviços acima do valor definido | Opcional |
| Campo `origem` | `link` | `recepcao` |

- Quando a recepção marca um horário, ele some do link na hora.
- Quando a cliente marca pelo link, ele aparece na agenda da recepção na hora (Supabase Realtime).
- A gestora pode editar, remarcar ou cancelar qualquer agendamento, venha de onde vier.
- **Link fixo do salão:** `seuapp.com.br/<slug-do-salao>`, para usar na bio do Instagram e na mensagem automática do WhatsApp Business.
- **Envio para uma cliente:** `https://wa.me/55<telefone>?text=<mensagem com o link>` abre a conversa já com a mensagem pronta.

## 3. Sinal via Pix

- Configurável por serviço (padrão: 30% em serviços a partir de R$ 150).
- O horário fica `aguardando_sinal` por até 15 minutos; sem pagamento, é liberado.
- O sinal é descontado do valor final.

## 4. Comissão

- Percentual por profissional (pode ser sobrescrito por serviço).
- Calculada sobre o valor efetivamente pago, no momento do pagamento.

## 5. Inadimplência e desmarques

- **Inadimplência:** atendimento concluído sem pagamento registrado, ou sinal devolvido sem quitação.
- **Desmarque com antecedência:** cancelado mais de 24h antes.
- **Desmarque em cima da hora:** cancelado menos de 24h antes.
- **Falta:** não compareceu e não avisou.

## 6. Perfis de acesso

| Perfil | Vê |
|---|---|
| Gestora | Tudo, incluindo Painel da Gestora e comissões de todos |
| Recepção | Agenda completa, clientes, registro de pagamento |
| Profissional | Só a própria agenda e a própria comissão |
