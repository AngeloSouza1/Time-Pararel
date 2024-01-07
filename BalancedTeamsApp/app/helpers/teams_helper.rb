# app/helpers/teams_helper.rb

module TeamsHelper
    def team_score(team)
      team.sum(&:score)
    end
  
    def team_percentage(team)
      total_score = Player.sum(:score)
      team_score = team_score(team)
  
      return 0 if total_score.zero?
  
      (team_score.to_f / total_score * 100).round(2)
    end
  end
  