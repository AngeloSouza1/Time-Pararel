class PlayersController < ApplicationController
  before_action :initialize_players, only: [:index, :select_players]

  def index
    # Apresenta a lista de jogadores na view
  end

  def form_teams
    begin
      # Filtra apenas IDs válidos e converte em array de inteiros
      player_ids = params[:player_ids].map(&:to_i)

      # Encontra os jogadores selecionados com base nos IDs passados pelo formulário
      selected_players = Player.where(id: player_ids)

      # Garante que player_times não seja nil e converte para DateTime, ignorando entradas vazias
      player_times = (params[:player_times] || {}).transform_values do |v|
        v.present? ? DateTime.parse(v) : nil
      end

      # Balanceia os times considerando os 12 jogadores mais recentes, com uma equipe adicional para os excedentes
      @balanced_teams = balance_teams(selected_players, player_times)
    rescue ActiveRecord::RecordNotFound => e
      # Caso algum jogador não seja encontrado, exibe uma mensagem ou redireciona para outra ação
      flash[:error] = "Alguns jogadores selecionados não foram encontrados."
      redirect_to players_path
    end
  end

  private

  def balance_teams(players, player_times)
    # Ordena os jogadores pelo datetime fornecido (mais recente primeiro)
    sorted_players = players.sort_by { |player| player_times[player.id.to_s] || DateTime.new(0) }.reverse

    # Seleciona os 12 jogadores mais recentes
    top_players = sorted_players.first(12)
    remaining_players = sorted_players.drop(12)

    # Ordena os jogadores selecionados por score (decrescente) para balanceamento
    top_players_sorted_by_score = top_players.sort_by(&:score).reverse

    team_a = []
    team_b = []
    team_a_score = 0
    team_b_score = 0

    top_players_sorted_by_score.each do |player|
      if team_a_score <= team_b_score
        team_a << player
        team_a_score += player.score
      else
        team_b << player
        team_b_score += player.score
      end
    end

    # Adiciona os jogadores restantes ao "Próximo time"
    next_team = remaining_players.shuffle

    # Retorna os times balanceados, incluindo o "Próximo time"
    [team_a.shuffle, team_b.shuffle, next_team]
  end

  def initialize_players
    # Limpa a lista de jogadores
    Player.destroy_all

    # Preenche a lista de jogadores
    players_data = [
      { name: 'Messi', score: 5 },
      { name: 'Ronaldo', score: 5 },
      { name: 'Neymar', score: 4 },
      { name: 'Mbappé', score: 4 },
      { name: 'Lewandowski', score: 4 },
      { name: 'Salah', score: 4 },
      { name: 'De Bruyne', score: 3 },
      { name: 'Kante', score: 3 },
      { name: 'Varane', score: 3 },
      { name: 'Modric', score: 3 },
      { name: 'Kane', score: 2 },
      { name: 'Griezmann', score: 2 },
      { name: 'Firmino', score: 2 },
      { name: 'Sterling', score: 2 },
      { name: 'Chiellini', score: 1 },
      { name: 'Courtois', score: 1 },
      { name: 'Alaba', score: 1 },
      { name: 'Laporte', score: 1 }
    ]

    # Cria os jogadores
    players_data.each { |data| Player.create(data) }

    # Obtém a lista de jogadores
    @players = Player.all
  end
end
