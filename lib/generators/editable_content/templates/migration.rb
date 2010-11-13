class CreateEcContents < ActiveRecord::Migration
  def self.up
    create_table :ec_contents do |t|
      t.string :name
      t.string :controller
      t.string :action
      t.string :markup      # what markup is used: html, plain_text, erb, textile, etc.
      t.text   :body
      t.timestamps
    end
  end

  def self.down
    drop_table :ec_contents
  end
end
