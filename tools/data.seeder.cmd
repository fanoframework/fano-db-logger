REM------------------------------------------------------------
REM [[APP_NAME]] ([[APP_URL]])
REM
REM @link      [[APP_REPOSITORY_URL]]
REM @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]
REM @license   [[LICENSE_URL]] ([[LICENSE]])
REM--------------------------------------------------------------

REM------------------------------------------------------
REM Scripts to setup MySQL database
REM------------------------------------------------------

REM Create new database user
SET CREATE_USER_SQL="CREATE USER '%DB_USER%'@'localhost' IDENTIFIED BY '%DB_PASSW%';"

REM Create database with same name as user
SET CREATE_DB_SQL="CREATE DATABASE \`%DB_USER%\`;"

REM set privilege user to new database
SET SET_PRIVILEGE_SQL="GRANT ALL PRIVILEGES ON \`%DB_USER%\`.* TO '%DB_USER%'@'localhost';"

SET USE_DATABASE_SQL="USE \`%DB_USER%\`;"

REM create table users in new database
SET CREATE_TABLE_SQL=CREATE TABLE users ^

(id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, ^

level VARCHAR(20) NOT NULL, ^

msg VARCHAR(400) NOT NULL, ^

created_at DATETIME NOT NULL, ^
context TEXT NOT NULL);

REM main SQL command
SET SQL="%CREATE_USER_SQL% %CREATE_DB_SQL% %USE_DATABASE_SQL% %SET_PRIVILEGE_SQL% %CREATE_TABLE_SQL%"

REM execute mysql command
mysql -h localhost -u %DB_ADMIN% -p -e "%SQL%"
