namespace :games do
  desc "TODO"
  task import: :environment do
    Game.import
    p 'done'
  end

  desc "TODO"
  task clear: :environment do
    Game.destroy_all
    p 'removed games'
    Team.destroy_all
    p 'removed games'
  end
end