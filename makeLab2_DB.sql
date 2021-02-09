
--Drop the tables if they already exist.

--  Delete the tables if they exist. To be able to drop
--    them in arbitrary order, disable foreign key checks.
PRAGMA foreign_keys = OFF;
drop table if exists Users;
drop table if exists Bookings;
drop table if exists Theatres;
drop table if exists Performances;
drop table if exists Movies;


-- Create the tables

create table Users (
    username    varchar(20) not null,
    firstName   varchar(20) not null,
    lastName    varchar(20) not null,
    address     varchar(20),
    telephone   varchar(10) not null,
    primary key (username)
);

create table Bookings ( --// (la till foreign keys bland attributen)
    bookingNbr  integer primary key AUTOINCREMENT,
    username    varchar(20) not null,
    date        TEXT,
    movieName   varchar(30),
    --primary key (bookingNbr), --// (Detta funkar inte med AUTOINCREMENT ovan. Var tvungen att köra "primary key"-keyword där uppe)
    foreign key (username) references Users(username),
    foreign key (movieName) references Movies(movieName)
);

create table Theatres ( 
    theaterName varchar(30) not null,
    seats       integer not null,
    primary key (theaterName)
);

create table Performances (  
    date        TEXT,
    bookedSeats integer not null,
    movieName   varchar(30),
    theaterName varchar(30) not null, ---skip
    primary key (date, movieName),
    foreign key (movieName) references Movies(movieName)
    foreign key (theaterName) references Theatres(theatername) --skip
);

create table Movies (       
    movieName   varchar(30),
    primary key (movieName)
);


--Start transaction for insert
begin transaction;

insert into Users VALUES
('XxBl4dZxX' ,'Axel', 'Björkman', 070340576, 'Gaslycktan 2B'),
('KaneIsAMeany' ,'Abel', 'Eriksson', 070350576, 'Babylongatan 12'),
('gr3333n' ,'Alexander', 'Green', 070340566, 'Bromölla'),
('floryde' ,'Alexander', 'Ryde', 070310576, 'Lund'),
('TeddyFreddy' ,'Fredrik', 'Teddison', 070340516, 'Norr'),
('MaoPowa' ,'Mao', 'Zedong', 070340576, 'Kina hörru'),
('ABBAWasHere' ,'Kerstin', 'Abba', 070340176, 'Sweiz 3C'),
('Hejsan' ,'Axel', 'Björkman', 070340576, 'Gaslycktan 2B'),
('BananMannen' ,'Apan', 'Björkman', 00000000, 'Vadå bor du'),
('JagÄrDåligPåNamn' ,'Babo', 'Flygplan', 070322576, 'Nere vid pieren');

insert into Bookings(username, date, movieName) VALUES        --//"no such table: bookings" (la till parametrarna enligt F3)
('floryde', '2021-02-01 20:15', 'Goodfellas'),
('gr3333n', '2021-02-01 20:15', 'Goodfellas');


insert into Theatres VALUES
('Bio1', 20),
('Bio2', 50),
('Bio3', 33),
('Bio4', 90),
('Bio5', 10),
('Bio6', 25),
('Bio7', 37),
('Bio8', 45),
('Bio9', 55),
('Bio10', 55);

insert into Performances VALUES   --//syntax error near "insert" (la till ; efter "..Bio1' och la till s till "Booking")
('2021-02-01 20:15',
(SELECT count(Bookings.bookingNbr) 
FROM Bookings 
WHERE Bookings.date = '2021-02-01 20:15'
AND Bookings.movieName = 'Goodfellas'),
'Goodfellas', 'Bio1');

insert into Movies VALUES --// (la till , efter näst sista filmen)
('GoodFellas'),
('Sausage Party'),
('Life of Brian'),
('Spaceballs'),
('The Shawshank Redemption'),
('Kenny Starfighter'),
('The Big Short'),
('Kalle och chokladfabriken'),
('It');

--COMMIT Transaction
commit;

--RE-ENABLE FOREIGN_KEY CHECK
PRAGMA foreign_keys = ON;

------------------------------TESTER FÖR LABBUPPGIFTER-------------------------------------
--D8: Try to insert two movie theaters with the same name. (UNIQUE constraint failed: Theatres.theaterName)
-- insert into Theatres VALUES
-- ('Bio11', 212312),
-- ('Bio11', 512312);

--D8: Adding a movie to a theater that does not exist.
-- insert into Performances VALUES
-- ('2021-02-01 15:00',
-- (SELECT count(Bookings.bookingNbr) 
-- FROM Bookings 
-- WHERE Bookings.date = '2021-02-01 20:15'
-- AND Bookings.movieName = 'The Big Short'),
-- 'The Big Short', 'BioSomInteFinns');

--D8: Adding a movie that does not exist to a theater.
-- insert into Performances VALUES
-- ('2021-02-01 20:15',
-- (SELECT count(Bookings.bookingNbr) 
-- FROM Bookings 
-- WHERE Bookings.date = '2021-02-01 20:15'
-- AND Bookings.movieName = 'Ryde goes fishing'),
-- 'Ryde goes fishing', 'Bio5');

--D10: There are methods that can handle concurrent access, such as row-locking in MySQL or locking an
--     entire table in SQLite. Using these one can prevent the scenario in D9.
