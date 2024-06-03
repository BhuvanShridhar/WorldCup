drop database if exists Cricket_Tournament;
create database Cricket_Tournament;
use Cricket_Tournament;

create table Team
(Team_Id varchar(10),
 Team_Name  varchar(15) unique,
 Sponsor varchar(20),
 primary key (Team_Id)
 );

create table Coach
(Coach_F_Name varchar(15),
 Coach_L_Name varchar(15),
 Age numeric(3),
 Country varchar(20),
Team_Id varchar(10),
primary key (Team_Id, Coach_F_Name),
 Foreign Key(Team_Id) References Team(Team_Id)
on update cascade          	on delete cascade
  );

create table Player
(
Player_Id varchar(10),
F_Name varchar(15),
 L_Name varchar(15),
 
 Runs numeric(5),
 Tot_Num_Matches numeric(3),
 Balls  numeric(5),
 Wickets  numeric(4),
 Team_Id varchar(10),
 BOflag BOOLEAN,
BAFLAG BOOLEAN,
WFLAG BOOLEAN,
 primary key (Player_Id),
 foreign key (Team_Id) references Team(Team_Id)
        	on update cascade          	on delete cascade
);


create table Captain
(
 player_ID varchar(10),
 primary key (player_ID),
 foreign key (player_ID) references Player(Player_Id)
on update cascade          	on delete cascade
);


create table ViceCaptain
( player_ID varchar(10),
 primary key (player_ID),
 foreign key (player_ID) references Player(Player_Id)
on update cascade          	on delete cascade
);


create table Matches
(Match_Id numeric(4), 
 ManOfTheMatch varchar(10),
 primary key (Match_Id),
 foreign key (ManOfTheMatch) references Player(Player_Id)
        	on update cascade          	on delete cascade 
);

create table Schedule
(MatchDateAndTime varchar(25), 
 Venue  varchar(30),
 Match_Id numeric(4),
 primary key (MatchDateAndTime),
 foreign key (Match_Id) references Matches(Match_Id)
  on update cascade          	on delete cascade
);

create table ScoreCard
(Match_Id numeric(4),
 Player_Id varchar(10),
 RunsScored numeric(4),
 WicketsTaken numeric(2),
 primary key (Match_Id,Player_Id),
 foreign key (Match_Id) references Matches(Match_Id)
        	on update cascade          	on delete cascade,
 foreign key (Player_ID) references Player(Player_Id)
        	on update cascade          	on delete cascade
);


create table Umpire
(U_Id varchar(5),
 Umpire_Name varchar(30),
 Country varchar(20),
 primary key (U_Id)
);

create table Umpiring
(Match_Id numeric(4),
 U_Id varchar(5),
 primary key (Match_Id,U_Id),
 foreign key (Match_Id) references Matches(Match_Id)
        	on update cascade          	on delete cascade,
 foreign key (U_Id) references Umpire(U_Id)
        	on update cascade          	on delete cascade
);
    

create table PointsTable
(Team_Name varchar(30), 
 Team_Rank numeric(2), 
 Tot_Mat_Played numeric(2), 
 Matches_Won numeric(2),
 Matches_Lost numeric(2),
 Matches_Tied numeric(2),
 Points numeric(2),
 Run_Rate   numeric(4,2),

primary key (Team_Name),
     foreign key (Team_Name) references Team(Team_Name)
        	on update cascade          	on delete cascade
);


create table Play
(Team_Id varchar(40), 
Match_Id decimal(4,0),
Win BOOLEAN,
 primary key (Team_Id,Match_Id),
     foreign key (Team_Id) references Team(Team_Id)
        	on update cascade          	on delete cascade,
	foreign key (Match_Id) references Matches(Match_Id)
        	on update cascade          	on delete cascade
);

create table Selection_Team
(selection_Team_Id varchar(30),
 Coach_F_Name varchar(15),
 Team_id varchar(20),
 primary key(selection_team_id),
 foreign key(Team_Id,Coach_F_Name) references Coach(Team_Id,Coach_F_Name)
	on update cascade          	on delete cascade
);

Create table Selection_Player
(selection_Team_Id varchar(30),
  Player_Id varchar(10),
primary key(selection_Team_Id,Player_Id),
foreign key(Player_Id) references Player(Player_Id)
	on update cascade          	on delete cascade,
foreign key(selection_Team_id ) references Selection_Team(selection_Team_Id)
	on update cascade          	on delete cascade
);

Create view WorldCup_Schedule as 
(select distinct m.Match_ID, temp1.MatchTime, temp1.Venue, temp1.Team1, temp1.Team2, Ump1,
            Ump2, ROW_NUMBER() OVER (PARTITION BY temp1.Match_ID ) as 'ID'
            from(
			select p1.Match_Id as 'Match_ID', s.MatchDateAndTime as 'MatchTime', s.venue as 'Venue', 
			p1.Team_Id as 'Team1', p2.Team_Id as 'Team2',
			ROW_NUMBER() OVER (PARTITION BY p1.Match_Id ) as 'ID'
			from Play p1 left join Play p2 on p1.Match_Id = p2.Match_Id
			join Schedule s on s.Match_Id = p1.Match_Id
			and p1.Team_Id <> p2.Team_Id) temp1 
            join 
            (select U1.Match1, Ump1, Ump2 from 
			(select Um.Match_Id as Match1,min(U.Umpire_Name) as Ump1 from Umpire U join Umpiring Um on U.U_Id = Um.U_Id group by Match_Id) as U1,
			(select Um.Match_Id as Match2,max(U.Umpire_Name) as Ump2 from Umpire U join Umpiring Um on U.U_Id = Um.U_Id group by Match_Id) as U2
			where U1.Match1 = U2.Match2) temp2
            on temp1.Match_Id = temp2.Match1
            left outer join Matches m on m.Match_Id = temp2.Match1
            left outer join Player pl on m.ManOfTheMatch = pl.Player_Id
            where ID = 1
            order by 1);
