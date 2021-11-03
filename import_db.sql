PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL  
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    question_body TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    question_id INTEGER,
    user_id INTEGER,
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY, --
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    user_id INTEGER NOT NULL,
    reply_body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    liked_it BOOLEAN DEFAULT(NULL),--CHECK (liked_it IN (0, 1)), --content text DEFAULT(NULL),
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);


INSERT INTO users (fname, lname)
VALUES ("Sam", "Smith"), ("Ryan", "Katzman"), ("Google", "Apple"), ("Anthony", "Carroll"), ("Nick", "Barr");

INSERT INTO questions (title, question_body, user_id) 
VALUES  ("No more questions", "Why is there two of these",
    (SELECT id
    FROM users
    WHERE fname LIKE "Nick" AND lname LIKE "Barr"));

INSERT INTO questions (title, question_body, user_id) 
VALUES  ("What is a chinchilla", "Wild",
    (SELECT id
    FROM users
    WHERE fname LIKE "Anthony" AND lname LIKE "Carroll"));

INSERT INTO questions (title, question_body, user_id) 
VALUES  ("new", "How do we complete a project",
    (SELECT id
    FROM users
    WHERE fname LIKE "Sam" AND lname LIKE "Smith"));

INSERT INTO question_follows (question_id, user_id)
VALUES ((SELECT id
    FROM questions
    WHERE title LIKE "new"), 
    (SELECT id
    FROM users
    WHERE fname LIKE "Sam" AND lname LIKE "Smith"));

INSERT INTO question_follows (question_id, user_id)
VALUES ((SELECT id
    FROM questions
    WHERE title LIKE "What is a chinchilla"), 
    (SELECT id
    FROM users
    WHERE fname LIKE "Anthony" AND lname LIKE "Carroll"));

    
INSERT INTO question_follows (question_id, user_id)
VALUES ((SELECT id
    FROM questions
    WHERE title LIKE "new"), 
    (SELECT id
    FROM users
    WHERE fname LIKE "Anthony" AND lname LIKE "Carroll"));

INSERT INTO question_follows (question_id, user_id)
VALUES (1, 6)





