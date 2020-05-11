#------------------------------------------------------------
# [[APP_NAME]] ([[APP_URL]])
#
# @link      [[APP_REPOSITORY_URL]]
# @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]
# @license   [[LICENSE_URL]] ([[LICENSE]])
#--------------------------------------------------------------
#!/bin/bash

#------------------------------------------------------
# Scripts to setup MySQL database
#------------------------------------------------------

# Create new database user
CREATE_USER_SQL="CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSW}';"

# Create database with same name as user
CREATE_DB_SQL="CREATE DATABASE \`${DB_USER}\`;"

# set privilege user to new database
SET_PRIVILEGE_SQL="GRANT ALL PRIVILEGES ON \`${DB_USER}\`.* TO '${DB_USER}'@'localhost';"

USE_DATABASE_SQL="USE \`${DB_USER}\`;"

# create table users in new database
CREATE_TABLE_SQL="CREATE TABLE logs
(id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
level VARCHAR(20) NOT NULL,
msg VARCHAR(400) NOT NULL,
created_at DATETIME NOT NULL,
context TEXT NOT NULL);"

# main SQL command
SQL="${CREATE_USER_SQL} ${CREATE_DB_SQL} ${USE_DATABASE_SQL}
${SET_PRIVILEGE_SQL} ${CREATE_TABLE_SQL}"

# execute mysql command
mysql -h localhost -u $DB_ADMIN -p -e "${SQL}"
