# 1. What tables do you need to add?
# `lesson` table already exists
# `topics` table: stores topic titles like SQL, CSS, etc.
# `lesson_topics` (join table): connects lessons and topics because many lessons can have many topics and vice versa.

# Assosiations:
# topic.rb
has_many :lesson_topics
has_many :lessons, through: :lesson_topics

# lesson_topic.rb (join table)
belongs_to :lesson
belongs_to :topic

# 2. What columns are necessary for the associations?
# `topics table`:
#   id (integer, PK, automatically added)
#   title (string) — the name of the topic (e.g., "CSS", "SQL")
# `lesson_topics` table:
#   id (integer, PK)
#   lesson_id (integer, FK)
#   topic_id (integer, FK)
#
# 3. What other columns (if any) need to be included?
# Join table only needs the two foreign keys
# Nothing more needed 

# 4. Table names and columns with data types
# `topics` table: 
#    id:integer, title:string, created_at:datetime, updated_at:datetime
# `lesson_topics` table: 
#    id:integer, lesson_id:integer, topic_id:integer, created_at:datetime, updated_at:datetime

# 5. Generate migration for topics table
# `bin/rails generate migration CreateTopics title:string`

# 6. Define columns in migration.
class CreateTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :topics do |t|
      t.string :title, null: false, index: { unique: true }

      t.timestamps
    end
  end
end

# 7. Run migration: `bin/rails db:migrate`

# 8. Add Topic model: `bin/rails generate model Topic`
# result:
class Topic < ApplicationRecord
  has_many :lesson_topics
  has_many :lessons, through: :lesson_topics
end

# 9. Generate join table migration: 
# `bin/rails generate migration CreateLessonTopics lesson:references topic:references`
# add associations
class Topic < ApplicationRecord
  has_many :lesson_topics
  has_many :lessons, through: :lesson_topics
end

#10. Join table column
class CreateLessonTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :lesson_topics do |t|
      t.references :lesson, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end

# 11. Run migrations: `bin/rails db:migrate`

# 12. Command to create join table model: `bin/rails generate model LessonTopic`
# Add associations app/models/lesson_topic.rb:
class LessonTopic < ApplicationRecord
  belongs_to :lesson
  belongs_to :topic
end

# add associations to Lesson
class Lesson < ApplicationRecord
  belongs_to :course # exists
  has_many :lesson_topics
  has_many :topics, through: :lesson_topics
end