-- CREATE USER 'test'@'%' IDENTIFIED WITH mysql_native_password BY 'test';
CREATE USER 'test'@'%' IDENTIFIED BY 'test';
GRANT SELECT,INSERT ON * . * TO 'test'@'%';
FLUSH PRIVILEGES;

CREATE DATABASE clouddb;
USE clouddb;

CREATE TABLE users(
  ID int NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(50) NOT NULL,
  time VARCHAR(50) NOT NULL,
  PRIMARY KEY (ID)
);

