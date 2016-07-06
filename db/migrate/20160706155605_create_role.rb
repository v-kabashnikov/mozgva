class CreateRole < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
    CREATE TYPE role AS ENUM ('user', 'moderator', 'admin');
    SQL
  end

  def down
    execute <<-SQL
    DROP TYPE role;
    SQL
  end
end
