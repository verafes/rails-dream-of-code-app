class CreateLessonTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :lesson_topics do |t|
      t.references :lesson, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
