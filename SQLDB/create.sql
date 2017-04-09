CREATE TABLE profiles (
 user_id integer PRIMARY KEY,
 user_name text NOT NULL,
 first_name text NOT NULL,
 last_name text NOT NULL,
 pref_time text NOT NULL,
 known_lang text NOT NULL,
 learn_lang text NOT NULL
);

CREATE TABLE matches (
 match_id integer PRIMARY KEY,
 user_id_1 integer,
 user_id_2 integer,
 FOREIGN KEY(user_id_1) REFERENCES profiles(user_id),
 FOREIGN KEY(user_id_2) REFERENCES profiles(user_id)
);

INSERT INTO profiles (user_id,user_name,first_name,last_name,pref_time,known_lang,learn_lang)
VALUES ('0000', 'jkong', 'Jacky', 'Kong', '03:00','MANDARIN','SPANISH');

INSERT INTO profiles (user_id,user_name,first_name,last_name,pref_time,known_lang,learn_lang)
VALUES ('0001', 'llegro', 'Luis', 'Legro', '03:00','SPANISH','MANDARIN');

INSERT INTO profiles (user_id,user_name,first_name,last_name,pref_time,known_lang,learn_lang)
VALUES ('0002', 'hstolz', 'Henry', 'Stolz', '04:00','ICELANDIC','JAPANESE');