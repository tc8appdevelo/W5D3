require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('database.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end


class User
    attr_accessor :id, :fname, :lname
    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def create
        raise "#{self} already in table" if self.id
        usr = QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
            INSERT INTO users (fname, lname)
            VALUES (?, ?)
        SQL
        self.id = QuestionsDatabase.instance.last_insert_row_id
    end

    def self.find_by_id(id)
        usr = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM users
            WHERE id = ?
        SQL
        p usr
        User.new(usr.first)
    end

    def self.find_by_name(fname, lname)
        nme = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
            SELECT *
            FROM users
            WHERE fname = :fname AND lname = :lname
        SQL
        User.new(nme.first)
    end
end






class Question
    attr_accessor :id, :title, :question_body, :user_id

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @question_body = options['question_body']
        @user_id = options['user_id']
    end

    def create
        raise "#{self} already in table" if self.id
        QuestionsDatabase.instance.execute(<<-SQL, self.title, self.question_body, self.user_id)
            INSERT INTO questions (title, question_body, user_id)
            VALUES (?, ?, ?)
        SQL
        self.id = QuestionsDatabase.instance.last_insert_row_id
    end

    def self.find_by_id(id)
        q = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM questions
            WHERE id = ?
        SQL
        Question.new(q.first)
    end

    def self.find_by_title(title)
        ques = QuestionsDatabase.instance.execute(<<-SQL, title)
            SELECT *
            FROM questions
            WHERE title LIKE ?
        SQL
        Question.new(ques.first)
    end

end

class QuestionFollows
    attr_accessor :question_id, :user_id

    def initialize(options)
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    # def create
    #     raise "#{self} is already in table" if self.user_id && self.question_id
    #     qf = QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.user_id)
    #         INSERT INTO question_follows (question_id, user_id)
    #         VALUES (?, ?)
    #     SQL
    #     QuestionFollows.new(qf.first)
    # end

    def self.followers_for_question_id(question_id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT id, fname, lname
        FROM question_follows
        JOIN users
            ON question_follows.user_id = users.id
        WHERE question_id = ?
    SQL

    questions.map {|contents| User.new(contents)} 
    end
    
    def self.followed_questions_for_user_id(user_id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT questions.id, title, question_body, question_follows.user_id
            FROM question_follows
            JOIN questions ON question_follows.user_id = questions.user_id
            WHERE question_follows.user_id = ?
        SQL
        
    end








    def self.find_by_qid_uid(qid, uid)
        qfollow = QuestionsDatabase.instance.execute(<<-SQL, qid, uid)
            SELECT *
            FROM question_follows
            WHERE qid = ? AND uid = ?
        SQL
        QuestionFollows.new(qfollow.first)
    end




end