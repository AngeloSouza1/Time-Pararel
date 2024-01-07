class PlayersController < ApplicationController
  before_action :initialize_players, only: [:index, :select_players]



  def index
  
  end
  
  def form_teams
    selected_players = params[:player_ids].map { |id| Player.find(id) }
    @balanced_teams = balance_teams(selected_players)
 
  end
  
  private

  def balance_teams(players)
    players.sort_by!(&:score).reverse!

    team_a = []
    team_b = []

    players.each_with_index do |player, index|
      if index.even?
        team_a << player
      else
        team_b << player
      end
    end

    [team_a, team_b]
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
