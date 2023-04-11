class AddBoardIdToPost < ActiveRecord::Migration[5.2]
  def change
    add_reference :posts, :board, foreign_key: true
  end
end
