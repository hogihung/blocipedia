class CreateWikiCollaborators < ActiveRecord::Migration
  def change
    create_table :wiki_collaborators do |t|
      t.references :user
      t.references :wiki
    end
  end
end
