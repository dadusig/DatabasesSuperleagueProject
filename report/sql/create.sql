DROP DATABASE if exists superleague;
CREATE DATABASE superleague CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE superleague;

CREATE TABLE stadium(
	name VARCHAR(50) NOT NULL,
	city VARCHAR(50) NOT NULL DEFAULT 'unknown',
	capacity INT NOT NULL,
	PRIMARY KEY(name)
)engine=InnoDB;

CREATE TABLE team(
	name VARCHAR(50) NOT NULL,
	points INT NOT NULL,
	wins INT NOT NULL DEFAULT '0',
	defeats INT NOT NULL DEFAULT '0',
	ties INT NOT NULL DEFAULT '0',
	goalsIN INT NOT NULL DEFAULT '0',
	goalsOUT INT NOT NULL DEFAULT '0',
	stadium VARCHAR(50) NOT NULL,
	PRIMARY KEY(name),
	CONSTRAINT STDMNAME FOREIGN KEY (stadium) REFERENCES stadium(name)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE player(
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	birthday DATE NOT NULL,
	goals INT NOT NULL DEFAULT '0',
	is_keeper BOOLEAN NOT NULL DEFAULT '0',
	cv BLOB NOT NULL,
	team_name VARCHAR(50) NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT PLAYERTEAMNAME FOREIGN KEY (team_name) REFERENCES team(name)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE coach(
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	birthday DATE NOT NULL,
	cv BLOB NOT NULL,
	wins INT NOT NULL DEFAULT '0',
	defeats INT NOT NULL DEFAULT '0',
	ties INT NOT NULL DEFAULT '0',
	team_name VARCHAR(50),
	PRIMARY KEY(id),
	CONSTRAINT COACHTEAMNAME FOREIGN KEY (team_name) REFERENCES team(name)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE coach_history(
	coach_id INT NOT NULL,
	team_name VARCHAR(50) NOT NULL,
	PRIMARY KEY(coach_id, team_name),
	CONSTRAINT COACHHISTORYTEAMNAME FOREIGN KEY (team_name) REFERENCES team(name)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT COACHHISTORYID FOREIGN KEY (coach_id) REFERENCES coach(id)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE owner(
	name VARCHAR(50) NOT NULL,
	team_name VARCHAR(50) NOT NULL,
	birthday DATE NOT NULL,
	PRIMARY KEY(name, team_name),
	CONSTRAINT OWNERTEAMNAME FOREIGN KEY (team_name) REFERENCES team(name)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE owner_alias(
	owner_name VARCHAR(50) NOT NULL,
	team_name VARCHAR(50) NOT NULL,
	alias VARCHAR(50) NOT NULL,
	PRIMARY KEY(owner_name, team_name, alias),
	CONSTRAINT ALIASTEAMNAME FOREIGN KEY (team_name) REFERENCES team(name)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT ALIASOWNERNAME FOREIGN KEY (owner_name) REFERENCES owner(name)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE fan(
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	birthday DATE NOT NULL,
	team_name VARCHAR(50) NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT FANTEAMNAME FOREIGN KEY (team_name) REFERENCES team(name)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE fan_admires(
	fan_id INT NOT NULL,
	player_id INT NOT NULL,
	PRIMARY KEY(fan_id, player_id),
	CONSTRAINT FANIDADMIRES FOREIGN KEY (fan_id) REFERENCES fan(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT PLAYERIDADMIRES FOREIGN KEY (player_id) REFERENCES player(id)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;


CREATE TABLE season_ticket(
	id INT NOT NULL AUTO_INCREMENT,
	fan_id INT NOT NULL,
	team_name VARCHAR(50) NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT FANIDSEASON FOREIGN KEY (fan_id) REFERENCES fan(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT SEASONTEAMNAME FOREIGN KEY (team_name) REFERENCES team(name)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;


CREATE TABLE referee(
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	birthday DATE NOT NULL,
	PRIMARY KEY(ID)
)engine=InnoDB;

CREATE TABLE arbitration(
	referee INT NOT NULL,
	ref1 INT NOT NULL,
	ref2 INT NOT NULL,
	fourth INT NOT NULL,
	observer INT NOT NULL,
	PRIMARY KEY(referee, ref1, ref2, fourth, observer),
	CONSTRAINT MAINREF FOREIGN KEY (referee) REFERENCES referee(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT REF1ID FOREIGN KEY (ref1) REFERENCES referee(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT REF2ID FOREIGN KEY (ref2) REFERENCES referee(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT FOURTHID FOREIGN KEY (fourth) REFERENCES referee(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT OBSERVERID FOREIGN KEY (observer) REFERENCES referee(id)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE game(
	game_date DATETIME NOT NULL,
	stadium_name VARCHAR(50) NOT NULL,
	team_host VARCHAR(50) NOT NULL,
	team_guest VARCHAR(50) NOT NULL,
	score_host INT(2) NOT NULL DEFAULT 0,
	score_guest INT(2) NOT NULL DEFAULT 0,
	result ENUM('win', 'defeat', 'tie') NOT NULL DEFAULT 'tie',
	description BLOB NOT NULL,
	referee INT NOT NULL,
	ref1 INT NOT NULL,
	ref2 INT NOT NULL,
	fourth INT NOT NULL,
	observer INT NOT NULL,
	PRIMARY KEY(game_date, stadium_name),
	CONSTRAINT STDMNAMEMATCH FOREIGN KEY (stadium_name) REFERENCES stadium(name)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT HOSTTEAMNAME FOREIGN KEY (team_host) REFERENCES team(name)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT GUESTTEAMNAME FOREIGN KEY (team_guest) REFERENCES team(name)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT MATCHMAINREF FOREIGN KEY (referee, ref1, ref2, fourth, observer) REFERENCES arbitration(referee, ref1, ref2, fourth, observer)
)engine=InnoDB;

CREATE TABLE ticket(
	id INT NOT NULL AUTO_INCREMENT,
	fan_id INT NOT NULL,
	stadium_name VARCHAR(50) NOT NULL,
	game_date DATETIME NOT NULL,
	PRIMARY KEY(id),
	CONSTRAINT TICKETFANID FOREIGN KEY (fan_id) REFERENCES fan(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT TICKETGAME FOREIGN KEY (stadium_name, game_date) REFERENCES game(stadium_name, game_date)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;

CREATE TABLE season_ticket_history(
	ticket_id INT NOT NULL,
	stadium_name VARCHAR(50) NOT NULL,
	game_date DATETIME NOT NULL,
	PRIMARY KEY(ticket_id, stadium_name, game_date),
	CONSTRAINT SEASONTICKETHISTORY FOREIGN KEY (stadium_name, game_date) REFERENCES game(stadium_name, game_date)
	ON UPDATE CASCADE ON DELETE CASCADE
)engine=InnoDB;