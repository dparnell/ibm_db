ActiveRecord::Schema.define do

  execute "DROP TABLE COMMENTS" rescue nil
  execute "DROP TABLE POSTS" rescue nil
  execute "DROP TABLE ITEMS" rescue nil
  execute "DROP TABLE TOPICS" rescue nil
  execute "DROP TABLE fk_test_has_fk" rescue nil
  execute "DROP TABLE fk_test_has_pk" rescue nil
  execute "DROP TABLE CIRCLES" rescue nil
  execute "DROP TABLE SQUARES" rescue nil
  execute "DROP TABLE TRIANGLES" rescue nil
  execute "DROP TABLE NON_POLY_ONES" rescue nil
  execute "DROP TABLE NON_POLY_TWOS" rescue nil
  execute "DROP TABLE PAINT_COLORS" rescue nil
  execute "DROP TABLE PAINT_TEXTURES" rescue nil
  
execute <<_SQL
  CREATE TABLE comments (
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 100),
    post_id INT NOT NULL,
    type VARCHAR(255) DEFAULT NULL,
    body VARCHAR(3000)NOT NULL,
    PRIMARY KEY (id)
  );
_SQL

execute <<_SQL  
  CREATE TABLE posts (
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 100),
    author_id INT DEFAULT NULL,
    title VARCHAR(255) NOT NULL,
    type VARCHAR(255) DEFAULT NULL,
    body VARCHAR(3000) NOT NULL,
    comments_count integer DEFAULT 0,
    taggings_count integer DEFAULT 0,
    PRIMARY KEY (id)
  );
_SQL

execute <<_SQL
  CREATE TABLE fk_test_has_pk (
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 100),
    PRIMARY KEY (id)
  );
_SQL

execute <<_SQL
  CREATE TABLE fk_test_has_fk (
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 100),
    fk_id integer NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (fk_id) REFERENCES fk_test_has_pk(id)
  );
_SQL

execute <<_SQL
  CREATE TABLE items (
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 100),
    name VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (id)
  );
_SQL

execute <<_SQL
  CREATE TABLE circles (
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1),
    PRIMARY KEY (id)
  );
_SQL

execute <<_SQL
  CREATE TABLE squares(
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1),
    PRIMARY KEY (id)
  );
_SQL

execute <<_SQL
  CREATE TABLE triangles(
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1),
    PRIMARY KEY (id)
  );
_SQL

execute <<_SQL
  CREATE TABLE non_poly_ones(
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1),
    PRIMARY KEY (id)
  );
_SQL

execute <<_SQL
  CREATE TABLE non_poly_twos(
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1),
    PRIMARY KEY (id)
  );
_SQL

execute <<_SQL
  CREATE TABLE paint_colors(
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1),
    non_poly_one_id INT,
    PRIMARY KEY (id)
  );
_SQL

execute <<_SQL
  CREATE TABLE paint_textures(
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1),
    non_poly_two_id INT,
    PRIMARY KEY (id)
  );
_SQL

execute <<_SQL
  CREATE TABLE topics (
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 100),
    title VARCHAR(255) DEFAULT NULL,
    author_name VARCHAR(255) DEFAULT NULL,
    author_email_address VARCHAR(255) DEFAULT NULL,
    written_on TIMESTAMP DEFAULT NULL,
    bonus_time TIME DEFAULT NULL,
    last_read DATE DEFAULT NULL,
    content VARCHAR(3000),
    approved SMALLINT DEFAULT 1,
    replies_count INT DEFAULT 0,
    parent_id INT DEFAULT NULL,
    parent_title VARCHAR(255) DEFAULT NULL,
    type VARCHAR(255) DEFAULT NULL,
    group VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (id)
  );
_SQL

end
