------------------------------------------------------------
-- DATABASE SCHEMA — CREATE TABLES (DDL)
------------------------------------------------------------
PRAGMA foreign_keys = ON;

------------------------------------------------------------
-- DROP TABLES (order respects foreign key dependencies)
------------------------------------------------------------
DROP TABLE IF EXISTS Buy;
DROP TABLE IF EXISTS Ticket_Payment;
DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Sell_Product;
DROP TABLE IF EXISTS Merchandise;
DROP TABLE IF EXISTS Drink;
DROP TABLE IF EXISTS Food;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Stand;
DROP TABLE IF EXISTS Performance_Artist;
DROP TABLE IF EXISTS Band;
DROP TABLE IF EXISTS Solo_Musician;
DROP TABLE IF EXISTS Artist;
DROP TABLE IF EXISTS Performance;
DROP TABLE IF EXISTS Stage;
DROP TABLE IF EXISTS Festival;

------------------------------------------------------------
-- FESTIVAL
------------------------------------------------------------

CREATE TABLE Festival (
  ID_Festival INTEGER PRIMARY KEY AUTOINCREMENT,
  Name VARCHAR(100) NOT NULL,
  Location VARCHAR(50) NOT NULL,
  Start_Date DATE NOT NULL,
  End_Date DATE NOT NULL,
  CHECK (End_Date >= Start_Date)
);

------------------------------------------------------------
-- STAGE
------------------------------------------------------------

CREATE TABLE Stage (
  ID_Stage TEXT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Max_Capacity INT NOT NULL CHECK (Max_Capacity > 0),
  Location_Description VARCHAR(250),
  ID_Festival INT NOT NULL,
  FOREIGN KEY (ID_Festival) REFERENCES Festival(ID_Festival)
    ON DELETE CASCADE
);

------------------------------------------------------------
-- PERFORMANCE
------------------------------------------------------------

CREATE TABLE Performance (
  ID_Performance  TEXT PRIMARY KEY,
  Title VARCHAR(160) NOT NULL,
  Genre VARCHAR(50) NOT NULL,
  Start_Time DATETIME NOT NULL,
  End_Time DATETIME NOT NULL,
  ID_Stage TEXT NOT NULL,
  CHECK (End_Time > Start_Time),
  FOREIGN KEY (ID_Stage) REFERENCES Stage(ID_Stage)
    ON DELETE CASCADE
);

------------------------------------------------------------
-- ARTIST SOLO MUSICIAN & BAND
------------------------------------------------------------

CREATE TABLE Artist_Solo_Musician (
  ID_Solo_Musician TEXT PRIMARY KEY,
  Country VARCHAR(30), 
  Genre VARCHAR(30),
  Artist_Stage_Name VARCHAR(30),
  Full_Name VARCHAR(30),
  Nationality VARCHAR(30),
  Instrument VARCHAR(30)
);


CREATE TABLE Band (
  ID_Band TEXT PRIMARY KEY,
  Country VARCHAR(30), 
  Genre VARCHAR(30),
  Artist_Stage_Name VARCHAR(30),
  Formation_Year YEAR,
  Band_Name VARCHAR(30)
);

------------------------------------------------------------
-- PERFORMANCE SOLO MUSICIAN & BAND
------------------------------------------------------------

CREATE TABLE Performance_Solo_Musician (
  ID_Performance TEXT,
  ID_Solo_Musician TEXT,
  PRIMARY KEY (ID_Performance, ID_Solo_Musician),
  FOREIGN KEY (ID_Performance) REFERENCES Performance(ID_Performance),
  FOREIGN KEY (ID_Solo_Musician) REFERENCES Artist_Solo_Musician(ID_Solo_Musician)  -- FIX
    ON DELETE CASCADE
);

CREATE TABLE Performance_Band (
  ID_Performance TEXT,
  ID_Band TEXT,
  PRIMARY KEY (ID_Performance, ID_Band),
  FOREIGN KEY (ID_Performance) REFERENCES Performance(ID_Performance),
  FOREIGN KEY (ID_Band) REFERENCES Band(ID_Band)
    ON DELETE CASCADE
);

------------------------------------------------------------
-- STAND
------------------------------------------------------------

CREATE TABLE Stand (
  ID_Stand TEXT PRIMARY KEY,
  Stand_Name VARCHAR(80) NOT NULL,
  Sponsor VARCHAR(80),
  ID_Festival  INTEGER NOT NULL,
  FOREIGN KEY (ID_Festival) REFERENCES Festival(ID_Festival)
    ON DELETE CASCADE
);

------------------------------------------------------------
-- PRODUCT DRINK - FOOD - MERCHANDISE
------------------------------------------------------------

CREATE TABLE Product_Drink (
  Barcode_Drink INT PRIMARY KEY,
  Name VARCHAR(20),
  Price INT,
  Expiration_Date DATE
);

CREATE TABLE Product_Food (
  Barcode_Food INT PRIMARY KEY,
  Name VARCHAR(20),
  Price INT,
  Expiration_Date DATE,
  Type VARCHAR(20)
);

CREATE TABLE Product_Merchandise (
  Barcode_Merchandise INT PRIMARY KEY,
  Name VARCHAR(20),
  Price INT
);

------------------------------------------------------------
-- SELL FOOD DRINK - FOOD - MERCHANDISE
------------------------------------------------------------


CREATE TABLE Sell_Drink (
  ID_Sell TEXT PRIMARY KEY,   
  ID_Stand TEXT,
  Barcode_Drink INT,
  FOREIGN KEY (ID_Stand) REFERENCES Stand(ID_stand),
  FOREIGN KEY (Barcode_Drink) REFERENCES Product_Drink(Barcode_Drink)
    ON DELETE CASCADE
);

CREATE TABLE Sell_Food (
  ID_Sell TEXT PRIMARY KEY,   
  ID_Stand TEXT,
  Barcode_Food INT,
  FOREIGN KEY (ID_Stand) REFERENCES Stand(ID_Stand),
  FOREIGN KEY (Barcode_Food) REFERENCES Product_Food(Barcode_Food)
    ON DELETE CASCADE
);

CREATE TABLE Sell_Merchandise (
  ID_Sell TEXT PRIMARY KEY,   
  ID_Stand TEXT,
  Barcode_Merchandise INT,
  FOREIGN KEY (ID_Stand) REFERENCES Stand(ID_stand),
  FOREIGN KEY (Barcode_Merchandise) REFERENCES Product_Merchandise(Barcode_Merchandise)
    ON DELETE CASCADE
);

------------------------------------------------------------
-- CUSTOMER
------------------------------------------------------------

CREATE TABLE Customer (
  ID_Customer TEXT PRIMARY KEY,
  Full_Name VARCHAR(100) NOT NULL,
  Email_Address VARCHAR(100) NOT NULL,
  Phone_Number VARCHAR(20) NOT NULL,
  UNIQUE (Email_Address, Phone_Number)
);

------------------------------------------------------------
-- TICKET
------------------------------------------------------------

CREATE TABLE Ticket (
  ID_Ticket TEXT PRIMARY KEY,
  Ticket_Type VARCHAR(20) NOT NULL CHECK (Ticket_Type IN ('REGULAR','DAY_PASS','VIP')),
  Price DECIMAL(8,2) NOT NULL,
  Start_Validity DATE NOT NULL,
  End_Validity DATE NOT NULL,
  ID_Festival INTEGER NOT NULL,
  FOREIGN KEY (ID_Festival) REFERENCES Festival(ID_Festival)
    ON DELETE CASCADE,
  CHECK (Start_Validity <= End_Validity)
);

------------------------------------------------------------
-- TICKET PAYMENT
------------------------------------------------------------

CREATE TABLE Ticket_Payment (
  Ticket_ID TEXT NOT NULL,
  ID_Customer INT NOT NULL,
  Payment_Date DATE NOT NULL,
  Payment_Method VARCHAR(30) NOT NULL,
  FOREIGN KEY (Ticket_ID) REFERENCES Ticket(ID_Ticket)
    ON DELETE CASCADE,
  FOREIGN KEY (ID_Customer) REFERENCES Customer(ID_Customer)
    ON DELETE RESTRICT
  PRIMARY KEY (Ticket_ID, ID_Customer)
);

------------------------------------------------------------
-- BUY FOOD - DRINK - MERCHANDISE
------------------------------------------------------------

CREATE TABLE Buy_Food (
  ID_Buy TEXT PRIMARY KEY,    
  ID_Customer TEXT,
  Barcode_Food INT,
  FOREIGN KEY (ID_Customer) REFERENCES Customer(ID_Customer),
  FOREIGN KEY (Barcode_Food) REFERENCES Product_Food(Barcode_Food)
    ON DELETE CASCADE
);

CREATE TABLE Buy_Drinks (
  ID_Buy TEXT PRIMARY KEY,   
  ID_Customer TEXT,
  Barcode_Drink INT,
  FOREIGN KEY (ID_Customer) REFERENCES Customer(ID_Customer),
  FOREIGN KEY (Barcode_Drink) REFERENCES Product_Drink(Barcode_Drink)
    ON DELETE CASCADE
);

CREATE TABLE Buy_Merchandise (
  ID_Buy TEXT PRIMARY KEY,   
  ID_Customer TEXT,
  Barcode_Merchandise INT,
  FOREIGN KEY (ID_Customer) REFERENCES Customer(ID_Customer),
  FOREIGN KEY (Barcode_Merchandise) REFERENCES Product_Merchandise(Barcode_Merchandise)
    ON DELETE CASCADE
);

------------------------------------------------------------
-- DATASET — INSERTS (DML)
------------------------------------------------------------

-- Festival data
INSERT INTO Festival (Name, Location, Start_Date, End_Date) VALUES
('Milano Soundwave','Milano','2025-06-20','2025-06-22'),
('Roma Indie Fest','Roma','2025-07-10','2025-07-13'),
('Firenze Summer Jam','Firenze','2025-08-05','2025-08-06'),
('Napoli Beats','Napoli','2025-09-01','2025-09-03'),
('Torino Vibes','Torino','2026-06-14','2026-06-15'),
('Bologna Groove Fest','Bologna','2026-07-02','2026-07-04'),
('Verona Rock Nights','Verona','2026-08-10','2026-08-12'),
('Genova Sea Sounds','Genova','2026-09-05','2026-09-05'),
('Bari Music Garden','Bari','2027-06-22','2027-06-23'),
('Palermo Sunset Fest','Palermo','2027-07-13','2027-07-15'),
('Cagliari Wave','Cagliari','2027-08-18','2027-08-20'),
('Padova Indie Days','Padova','2027-09-10','2027-09-11'),
('Lecce Live Energy','Lecce','2028-06-12','2028-06-14'),
('Trieste Electro Sound','Trieste','2028-07-01','2028-07-01'),
('Parma Classic Festival','Parma','2028-07-20','2028-07-22'),
('Perugia Jazz Fusion','Perugia','2028-08-03','2028-08-04'),
('Ancona Pop Nights','Ancona','2028-08-25','2028-08-27'),
('Rimini Beach Beats','Rimini','2028-09-06','2028-09-09'),
('Pisa Sound Arena','Pisa','2027-06-15','2027-06-17'),
('Modena Metal Storm','Modena','2026-07-08','2026-07-08'),
('Reggio Vibes','Reggio Emilia','2025-08-01','2025-08-03'),
('Lucca Music Days','Lucca','2026-09-10','2026-09-12'),
('Aosta Alpine Jam','Aosta','2027-07-14','2027-07-14'),
('Pescara Festival del Mare','Pescara','2027-08-09','2027-08-10'),
('Como Lakeside Fest','Como','2028-06-21','2028-06-23');

-- Stage data
INSERT INTO Stage (ID_Stage, Name, Max_Capacity, Location_Description, ID_Festival) VALUES
('S001','Main Stage Milano',20000,'Central area of Parco Sempione',1),
('S002','Sunset Arena Milano',15000,'South area, near lake',1),
('S003','Indie Garden Milano',12000,'West entrance section',1),
('S004','Indie Arena Roma',10000,'Villa Ada, west area',2),
('S005','Electronic Dome Roma',8000,'North expo pavilion',2),
('S006','Rock Park Roma',13000,'Villa Borghese main field',2),
('S007','Acoustic Stage Roma',9000,'South garden section',2),
('S008','Florence Jazz Hall',11000,'Campo di Marte zone',3),
('S009','Acoustic Garden Firenze',8000,'Giardini Cascine, southern side',3),
('S010','Napoli Rock Stage',16000,'Port area main stage',4),
('S011','Napoli Underground Dome',10000,'Old metro zone arena',4),
('S012','Napoli Sunset Area',9000,'Seaside east zone',4),
('S013','Torino Main Square',18000,'Piazza Castello central stage',5),
('S014','Torino Electro Hall',9500,'Lingotto Expo space',5),
('S015','Bologna Groove Stage',9000,'Parco Nord central field',6),
('S016','Funk Garden Bologna',7000,'Green north section',6),
('S017','Verona Rock Arena',16000,'Arena di Verona open air',7),
('S018','Indie Zone Verona',9000,'Piazza Bra east section',7),
('S019','Acoustic Stage Verona',8500,'Porta Nuova park',7),
('S020','Genova Sea Front',11000,'Porto Antico area',8),
('S021','Bari Green Garden',10000,'City park east side',9),
('S022','Bari Acoustic Bay',6000,'South park area',9),
('S023','Palermo Sunset Arena',13000,'Mondello beach area',10),
('S024','Island Stage Palermo',9000,'Lungomare north section',10),
('S025','Cagliari Wave Stage',7500,'Port area, north side',11),
('S026','Cagliari Techno Zone',9000,'Industrial expo area',11),
('S027','Padova Indie Stage',8500,'Parco Europa west zone',12),
('S028','Padova Pop Square',9500,'Historic center piazza',12),
('S029','Lecce Energy Stage',9500,'Fiera area, pavilion A',13),
('S030','Lecce Acoustic Hall',7000,'Parco Belloluogo area',13),
('S031','Trieste Electro Dome',8500,'Piazza Unità d’Italia',14),
('S032','Parma Classic Hall',4000,'Teatro Comunale main room',15),
('S033','Perugia Jazz Lounge',6000,'Piazza IV Novembre',16),
('S034','Perugia Fusion Dome',7000,'Centro fiere area',16),
('S035','Ancona Pop Arena',8000,'Porto Vecchio stage',17),
('S036','Ancona Indie Beach',9500,'Lungomare nord area',17),
('S037','Rimini Beach Main',18000,'Central beach',18),
('S038','Rimini Electro Bay',12000,'Port south zone',18),
('S039','Rimini Acoustic Spot',9500,'Coastal field west',18),
('S040','Pisa Sound Plaza',7000,'Piazza dei Miracoli north',19),
('S041','Modena Metal Dome',9000,'Industrial expo area',20),
('S042','Reggio Groove Hall',8000,'Parco cittadino sud',21),
('S043','Reggio Jazz Point',6500,'Centro storico zone',21),
('S044','Lucca Green Stage',8500,'Historic walls west',22),
('S045','Aosta Alpine Stage',6000,'Mountain base camp',23),
('S046','Pescara Mare Arena',9500,'Port area south',24),
('S047','Pescara Riviera Stage',8500,'Lungomare Matteotti',24),
('S048','Como Lakeside Arena',7000,'Lakefront central area',25),
('S049','Como Indie Lake',6000,'North park near lake',25),
('S050','Como Electro Dock',9000,'Port of Como area',25);

-- Performance data
INSERT INTO Performance (ID_Performance, Title, Genre, Start_Time, End_Time, ID_Stage) VALUES
('P001','Neon Echoes','Electronic','2025-06-20 21:00','2025-06-20 23:30','S001'),
('P002','Dreamline Tour','Pop','2025-06-21 20:00','2025-06-21 23:00','S002'),
('P003','Midnight Frequencies','Rock','2025-06-22 19:00','2025-06-22 22:00','S003'),
('P004','Velvet Horizon','Indie','2025-07-10 19:30','2025-07-10 22:30','S004'),
('P005','Electric Mirage','Electronic','2025-07-11 22:00','2025-07-12 01:00','S005'),
('P006','Golden Pulse','Pop-Rock','2025-07-12 19:00','2025-07-12 22:30','S006'),
('P007','Moonlight Jazz Ensemble','Jazz','2025-08-05 21:00','2025-08-05 23:30','S008'),
('P008','Hidden Stories','Folk','2025-08-06 18:30','2025-08-06 21:30','S009'),
('P009','Chromatic Wave','Electronic','2025-09-01 22:00','2025-09-02 01:30','S011'),
('P010','Steel Strings','Rock','2025-09-02 20:00','2025-09-02 23:00','S012'),
('P011','Digital Bloom','Electronic','2026-06-14 21:00','2026-06-15 00:00','S013'),
('P012','Northern Lights','Pop','2026-06-15 18:00','2026-06-15 21:00','S014'),
('P013','Groove Mechanics','Funk','2026-07-02 20:00','2026-07-02 23:00','S015'),
('P014','The Velvet Flow','Soul','2026-07-03 19:30','2026-07-03 22:30','S016'),
('P015','Crimson Horizon','Rock','2026-08-10 19:00','2026-08-10 22:30','S017'),
('P016','Indigo Nights','Indie','2026-08-11 20:00','2026-08-11 23:00','S018'),
('P017','Ocean Frequencies','Electronic','2026-09-05 21:00','2026-09-05 23:30','S019'),
('P018','Summer Groove','Pop','2027-06-22 18:30','2027-06-22 22:00','S021'),
('P019','Soulful Lines','Jazz','2027-06-23 19:00','2027-06-23 22:00','S022'),
('P020','Dancing Mirage','Pop','2027-07-13 18:00','2027-07-13 22:00','S023'),
('P021','Afterglow','Electronic','2027-08-18 22:00','2027-08-19 01:00','S025'),
('P022','Silent Avenue','Indie','2027-09-10 20:00','2027-09-10 23:00','S027'),
('P023','Symphonic Dawn','Classical','2028-06-12 21:00','2028-06-12 23:00','S029'),
('P024','Digital Rain','Electronic','2028-07-01 19:00','2028-07-01 22:00','S031'),
('P025','Echo Chamber','Classical','2028-07-20 20:00','2028-07-20 22:00','S032'),
('P026','Blue Velvet','Jazz','2028-08-03 21:00','2028-08-03 23:30','S033'),
('P027','Broken Harmony','Pop','2028-08-25 19:30','2028-08-25 23:00','S035'),
('P028','Electric Bloom','Electronic','2028-09-06 22:00','2028-09-07 02:00','S037'),
('P029','Iron Storm','Metal','2026-07-08 21:00','2026-07-08 23:59','S041'),
('P030','Blue Café','Jazz','2025-08-01 19:00','2025-08-01 22:00','S042'),
('P031','Lunar Waltz','Classical','2026-09-10 19:00','2026-09-10 22:00','S044'),
('P032','The Traveller','Folk','2027-07-14 18:00','2027-07-14 21:00','S045'),
('P033','Mirage of Sound','Pop-Rock','2027-08-09 20:00','2027-08-09 23:00','S046'),
('P034','Silver Veins','Pop','2028-06-21 21:00','2028-06-21 23:59','S048'),
('P035','Golden Hour','Jazz','2025-07-11 06:00','2025-07-11 08:30','S005'),
('P036','Whispering Pines','Folk','2025-08-06 10:00','2025-08-06 12:00','S009'),
('P037','Morning Sonata','Classical','2028-07-21 09:00','2028-07-21 11:30','S032'),
('P038','Velvet Moon','Soul','2026-09-06 19:00','2026-09-06 21:30','S019'),
('P039','Glass Shapes','Electronic','2028-07-03 20:00','2028-07-03 22:30','S031'),
('P040','The River and the Sky','Folk','2027-07-15 19:00','2027-07-15 21:30','S045'),
('P041','Into the Night','Pop','2027-06-22 22:00','2027-06-23 00:30','S021'),
('P042','Heavy Skies','Metal','2026-07-08 23:00','2026-07-09 02:00','S041'),
('P043','Quiet Steps','Jazz','2028-08-03 19:30','2028-08-03 21:30','S033'),
('P044','Digital Euphoria','Electronic','2026-09-05 18:00','2026-09-05 21:00','S019'),
('P045','Funk District','Funk','2028-06-13 19:00','2028-06-13 22:00','S029'),
('P046','Golden Streets','Pop','2028-08-26 20:00','2028-08-26 23:00','S036'),
('P047','Strings in Motion','Classical','2026-06-14 16:00','2026-06-14 18:30','S013'),
('P048','Skyline Rhythms','Electronic','2026-09-05 23:00','2026-09-06 02:00','S020'),
('P049','Neon City','Electronic','2027-07-14 22:00','2027-07-15 01:00','S024'),
('P050','Breathe Again','Pop','2028-09-08 19:00','2028-09-08 22:00','S039'),
('P051','Paper Hearts','Indie','2026-08-12 19:30','2026-08-12 22:30','S018'),
('P052','Crimson Metal','Metal','2026-07-09 20:00','2026-07-09 23:30','S043'),
('P053','Midnight Soul','Soul','2025-08-02 20:00','2025-08-02 23:00','S043'),
('P054','Dreamline Reprise','Pop-Rock','2027-06-15 19:00','2027-06-15 22:00','S040'),
('P055','Silent Waltz','Classical','2026-09-11 20:00','2026-09-11 22:00','S044'),
('P056','Open Horizons','Folk','2025-08-06 17:00','2025-08-06 19:30','S009'),
('P057','Pulse','Electronic','2028-09-07 21:00','2028-09-08 00:00','S038'),
('P058','Neon Heartbeat','Pop','2025-06-21 23:00','2025-06-22 01:00','S002'),
('P059','Velvet Lounge','Jazz','2026-06-15 22:00','2026-06-16 00:00','S014'),
('P060','Final Eclipse','Pop','2028-06-23 20:00','2028-06-23 23:59','S050');

-- Artist_Solo_Musician data
INSERT INTO Artist_Solo_Musician (ID_Solo_Musician, Country, Genre, Artist_Stage_Name, Full_Name, Nationality, Instrument) VALUES
('SM01','Italy','Pop','Elisa','Elisa Toffoli','Italian','vocals'),
('SM02','Italy','Pop','Tiziano Ferro','Tiziano Ferro','Italian','vocals'),
('SM03','Italy','Jazz','Paolo Fresu','Paolo Fresu','Italian','trumpet'),
('SM04','Italy','Rock','Zucchero','Adelmo Fornaciari','Italian','guitar'),
('SM05','Italy','Classical','Ludovico Einaudi','Ludovico Einaudi','Italian','piano'),
('SM06','Italy','Pop','Marco Mengoni','Marco Mengoni','Italian','vocals'),
('SM07','Italy','Folk','Francesco De Gregori','Francesco De Gregori','Italian','guitar'),
('SM08','Italy','Indie','Levante','Claudia Lagona','Italian','vocals'),
('SM09','Italy','Pop','Laura Pausini','Laura Pausini','Italian','vocals'),
('SM10','Italy','Soul','Mara Sattei','Sara Mattei','Italian','vocals'),
('SM11','UK','Pop','Adele','Adele Adkins','British','vocals'),
('SM12','UK','Rock','Ed Sheeran','Edward Sheeran','British','guitar'),
('SM13','UK','Jazz','Jamie Cullum','Jamie Cullum','British','piano'),
('SM14','UK','Indie','Arlo Parks','Anaïs Parks','British','vocals'),
('SM15','USA','Rock','Jack White','John White','American','guitar'),
('SM16','USA','Pop','Billie Eilish','Billie Eilish','American','vocals'),
('SM17','CAN','R&B','The Weeknd','Abel Tesfaye','Canadian','vocals'),
('SM18','France','Electronic','David Guetta','David Guetta','French','other'),
('SM19','Germany','Electronic','Robin Schulz','Robin Schulz','German','other'),
('SM20','Spain','Pop','Rosalía','Rosalía Vila Tobella','Spanish','vocals'),
('SM21','Belgium','Electronic','Stromae','Paul Van Haver','Belgian','vocals'),
('SM22','Italy','Pop','Annalisa','Annalisa Scarrone','Italian','vocals'),
('SM23','Italy','Pop-Rock','Jovanotti','Lorenzo Cherubini','Italian','vocals'),
('SM24','Italy','Jazz','Stefano Bollani','Stefano Bollani','Italian','piano'),
('SM25','Italy','Metal','Damiano David','Damiano David','Italian','vocals'),
('SM26','Italy','Folk','Ermal Meta','Ermal Meta','Albanian-Italian','guitar'),
('SM27','Italy','Jazz','Mario Biondi','Mario Ranno','Italian','vocals'),
('SM28','Italy','Pop','Arisa','Rosalba Pippa','Italian','vocals'),
('SM29','France','Pop','Angèle','Angèle Van Laeken','Belgian','vocals'),
('SM30','USA','Pop','Bruno Mars','Peter Hernandez','American','vocals'),
('SM31','UK','Electronic','Calvin Harris','Adam Wiles','British','other'),
('SM32','Italy','Pop','Ultimo','Niccolò Moriconi','Italian','vocals'),
('SM33','Germany','Electronic','Purple Disco Machine','Tino Piontek','German','other'),
('SM34','France','Jazz','Melody Gardot','Melody Gardot','French','vocals'),
('SM35','Italy','Classical','Andrea Bocelli','Andrea Bocelli','Italian','vocals'),
('SM36','Italy','Funk','Mario Venuti','Mario Venuti','Italian','guitar'),
('SM37','Italy','Pop','Cesare Cremonini','Cesare Cremonini','Italian','piano'),
('SM38','Italy','Jazz','Enrico Rava','Enrico Rava','Italian','trumpet'),
('SM39','UK','Indie','Sam Fender','Sam Fender','British','guitar'),
('SM40','USA','Rock','John Mayer','John Mayer','American','guitar'),
('SM41','USA','Pop','Katy Perry','Katheryn Hudson','American','vocals'),
('SM42','Italy','Pop','Emma','Emma Marrone','Italian','vocals'),
('SM43','Italy','Indie','Coma_Cose','Francesco & Fausto','Italian','vocals'),
('SM44','Italy','Pop','Irama','Filippo Maria Fanti','Italian','vocals'),
('SM45','Italy','Pop','Madame','Francesca Calearo','Italian','vocals'),
('SM46','USA','Pop','Lady Gaga','Stefani Germanotta','American','vocals'),
('SM47','UK','Indie','Florence Welch','Florence Welch','British','vocals'),
('SM48','Italy','Rock','Manuel Agnelli','Manuel Agnelli','Italian','guitar'),
('SM49','Italy','Folk','Mannarino','Alessandro Mannarino','Italian','guitar'),
('SM50','Italy','Jazz','Simona Molinari','Simona Molinari','Italian','vocals');

-- Band data
INSERT INTO Band (ID_Band, Country, Genre, Artist_Stage_Name, Formation_Year, Band_Name) VALUES
('B01','Italy','Rock','Måneskin',2016,'Måneskin'),
('B02','Italy','Pop','Negramaro',2001,'Negramaro'),
('B03','Italy','Electronic','Subsonica',1996,'Subsonica'),
('B04','UK','Rock','Coldplay',1996,'Coldplay'),
('B05','USA','Alternative','Imagine Dragons',2008,'Imagine Dragons'),
('B06','USA','Rock','Foo Fighters',1994,'Foo Fighters'),
('B07','France','Electronic','Daft Punk',1993,'Daft Punk'),
('B08','Germany','Metal','Rammstein',1994,'Rammstein'),
('B09','Iceland','Post-Rock','Sigur Ros',1994,'Sigur Ros'),
('B10','Canada','Indie','Arcade Fire',2000,'Arcade Fire'),
('B11','UK','Indie','Arctic Monkeys',2002,'Arctic Monkeys'),
('B12','UK','Alternative','Muse',1994,'Muse'),
('B13','USA','Rock','Paramore',2004,'Paramore'),
('B14','USA','Rock','Kings of Leon',1999,'Kings of Leon'),
('B15','Italy','Indie','Thegiornalisti',2009,'Thegiornalisti'),
('B16','Italy','Jazz','Fabrizio Bosso Quartet',2010,'Fabrizio Bosso Quartet'),
('B17','Italy','Metal','Lacuna Coil',1994,'Lacuna Coil'),
('B18','Italy','Pop','Boomdabash',2003,'Boomdabash'),
('B19','Italy','Folk','Modena City Ramblers',1991,'Modena City Ramblers'),
('B20','UK','Pop','The 1975',2002,'The 1975'),
('B21','USA','Pop','Maroon 5',2001,'Maroon 5'),
('B22','France','Pop','Phoenix',1999,'Phoenix'),
('B23','Italy','Jazz','Paolo Conte Trio',2015,'Paolo Conte Trio'),
('B24','Italy','Rock','Afterhours',1986,'Afterhours'),
('B25','Italy','Pop','Pinguini Tattici Nucleari',2010,'Pinguini Tattici Nucleari'),
('B26','Italy','Electronic','Planet Funk',1999,'Planet Funk'),
('B27','USA','Pop','OneRepublic',2002,'OneRepublic'),
('B28','Italy','Rock','Litfiba',1980,'Litfiba'),
('B29','Italy','Pop','The Kolors',2010,'The Kolors'),
('B30','Italy','Rock','Negrita',1991,'Negrita'),
('B31','Italy','Rock','Pooh',1966,'Pooh'),
('B32','Italy','Pop','Rkomi & Irama',2020,'Rkomi & Irama'),
('B33','Italy','Pop','Coma_Cose Band',2019,'Coma_Cose Band'),
('B34','Germany','Electronic','Kraftwerk',1970,'Kraftwerk'),
('B35','Italy','Rock','Le Vibrazioni',1999,'Le Vibrazioni'),
('B36','Italy','Jazz','Quintorigo',1996,'Quintorigo'),
('B37','France','Electronic','Air',1995,'Air'),
('B38','Italy','Rock','Verdena',1995,'Verdena'),
('B39','Italy','Pop','Matia Bazar',1975,'Matia Bazar'),
('B40','Italy','Pop','I Cugini di Campagna',1970,'I Cugini di Campagna'),
('B41','UK','Rock','The Rolling Stones',1962,'The Rolling Stones'),
('B42','USA','Rock','The Killers',2001,'The Killers'),
('B43','Italy','Funk','Neri Per Caso',1995,'Neri Per Caso'),
('B44','Italy','Folk','Bandabardò',1993,'Bandabardò'),
('B45','Italy','Electronic','Blue Vertigo',1994,'Blue Vertigo'),
('B46','Italy','Pop','Zero Assoluto',2004,'Zero Assoluto'),
('B47','Italy','Pop','Raf & Tozzi',2018,'Raf & Tozzi'),
('B48','Italy','Rock','Elio e le Storie Tese',1980,'Elio e le Storie Tese'),
('B49','USA','Rock','Linkin Park',1996,'Linkin Park'),
('B50','USA','Rock','Green Day',1987,'Green Day');

-- Performance_Solo_Musician relation data
INSERT INTO Performance_Solo_Musician (ID_Performance, ID_Solo_Musician) VALUES
('P001','SM03'),
('P002','SM01'),
('P003','SM12'),
('P004','SM08'),
('P005','SM18'),
('P006','SM22'),
('P007','SM27'),
('P008','SM07'),
('P009','SM19'),
('P010','SM04'),
('P011','SM18'),
('P012','SM09'),
('P013','SM36'),
('P014','SM10'),
('P015','SM25'),
('P016','SM14'),
('P017','SM33'),
('P018','SM06'),
('P019','SM03'),
('P020','SM09'),
('P021','SM18'),('P021','SM33'),
('P022','SM08'),('P022','SM39'),
('P023','SM05'),('P023','SM35'),
('P024','SM18'),('P024','SM46'),
('P025','SM35'),('P025','SM47'),
('P026','SM03'),('P026','SM27'),
('P027','SM06'),('P027','SM09'),
('P028','SM18'),('P028','SM20'),
('P029','SM25'),('P029','SM12'),
('P030','SM03'),('P030','SM34'),
('P031','SM35'),('P031','SM37'),('P031','SM42'),
('P032','SM07'),('P032','SM49'),('P032','SM46'),
('P033','SM06'),('P033','SM02'),('P033','SM41'),
('P034','SM01'),('P034','SM09'),('P034','SM20'),
('P035','SM03'),('P035','SM10'),('P035','SM38'),
('P036','SM07'),('P036','SM43'),('P036','SM48'),
('P037','SM35'),('P037','SM05'),('P037','SM24'),
('P038','SM10'),('P038','SM29'),('P038','SM45'),
('P039','SM33'),('P039','SM18'),('P039','SM19'),
('P040','SM07'),('P040','SM26'),('P040','SM39'),
('P041','SM06'),('P041','SM02'),
('P042','SM25'),('P042','SM46'),
('P043','SM03'),('P043','SM27'),
('P044','SM18'),('P044','SM33'),
('P045','SM36'),('P045','SM10'),
('P046','SM06'),('P046','SM09'),
('P047','SM05'),('P047','SM35'),
('P048','SM18'),('P048','SM19'),
('P049','SM18'),('P049','SM46'),
('P050','SM06'),('P050','SM09'),
('P051','SM08'),('P051','SM14'),
('P052','SM25'),('P052','SM12'),
('P053','SM10'),('P053','SM27'),
('P054','SM23'),('P054','SM32'),
('P055','SM35'),('P055','SM05'),
('P056','SM07'),('P056','SM26'),
('P057','SM18'),('P057','SM33'),
('P058','SM06'),('P058','SM20'),
('P059','SM03'),('P059','SM27'),
('P060','SM06'),('P060','SM32');

-- Performance_Band relation data
INSERT INTO Performance_Band (ID_Performance, ID_Band) VALUES
('P001','B16'),
('P002','B02'),
('P003','B04'),
('P004','B15'),
('P005','B07'),
('P006','B25'),
('P007','B23'),
('P008','B19'),
('P009','B26'),
('P010','B06'),
('P011','B34'),
('P012','B21'),
('P013','B43'),
('P014','B10'),
('P015','B11'),
('P016','B20'),
('P017','B26'),
('P018','B02'),
('P019','B16'),
('P020','B18'),
('P021','B07'),('P021','B34'),
('P022','B15'),('P022','B20'),
('P023','B31'),('P023','B23'),
('P024','B34'),('P024','B26'),
('P025','B31'),
('P026','B23'),
('P027','B25'),
('P028','B07'),
('P029','B17'),
('P030','B16'),
('P031','B31'),('P031','B23'),('P031','B16'),
('P032','B19'),('P032','B44'),('P032','B43'),
('P033','B02'),('P033','B25'),('P033','B20'),
('P034','B21'),('P034','B22'),('P034','B25'),
('P035','B16'),('P035','B43'),('P035','B10'),
('P036','B19'),('P036','B44'),('P036','B23'),
('P037','B31'),('P037','B23'),('P037','B16'),
('P038','B43'),('P038','B45'),('P038','B25'),
('P039','B26'),('P039','B07'),('P039','B19'),
('P040','B19'),('P040','B44'),('P040','B43'),
('P041','B25'),('P041','B32'),
('P042','B17'),('P042','B45'),
('P043','B23'),('P043','B16'),
('P044','B26'),('P044','B07'),
('P045','B43'),('P045','B10'),
('P046','B02'),('P046','B20'),
('P047','B31'),('P047','B23'),
('P048','B34'),('P048','B07'),
('P049','B07'),('P049','B34'),
('P050','B25'),('P050','B02'),
('P051','B15'),('P051','B20'),
('P052','B17'),('P052','B42'),
('P053','B43'),('P053','B44'),
('P054','B25'),('P054','B18'),
('P055','B31'),('P055','B23'),
('P056','B19'),('P056','B44'),
('P057','B26'),('P057','B07'),
('P058','B02'),('P058','B25'),
('P059','B16'),('P059','B23'),
('P060','B25'),('P060','B43');

-- Stand data
INSERT INTO Stand (ID_Stand, Stand_Name, Sponsor, ID_Festival) VALUES
('ST001','Coca-Cola Drink Point','Coca-Cola',1),
('ST002','Burger House','McDonald''s',1),
('ST003','Vinyl Merch Corner','Spotify',1),
('ST004','Heineken Beer Bar','Heineken',2),
('ST005','Street Pizza','Eataly',2),
('ST006','Roma Merch','Vans',2),
('ST007','Red Bull Energy Spot','Red Bull',3),
('ST008','Veg & Go','Veg&Go',3),
('ST009','Coffee & More','Lavazza',4),
('ST010','Panini Express','Autogrill',4),
('ST011','Festival Merch Napoli','Hard Rock Cafe',4),
('ST012','Gelato Point','Algida',5),
('ST013','Vans Merch Store','Vans',6),
('ST014','Food Station Bologna','Old Wild West',6),
('ST015','Drink Station Bologna','Monster Energy',6),
('ST016','Indie Merch Verona','Spotify',7),
('ST017','Beer Street Verona','Heineken',7),
('ST018','Sweet Bites Verona','Lindt',7),
('ST019','Lounge Bar Genova','Campari',8),
('ST020','Sicilian Street Food','Eataly',9),
('ST021','Fresh Drinks Bari','Coca-Cola',9),
('ST022','Sunset Merch Palermo','Levi''s',10),
('ST023','Island Food Palermo','Burger King',10),
('ST024','Tropical Drinks Palermo','Pepsi',10),
('ST025','Wave Drink Bar','Red Bull',11),
('ST026','Padova Local Food','Eataly',12),
('ST027','Padova Merch Point','Spotify',12),
('ST028','Energy Bar Lecce','Monster',13),
('ST029','Lecce Sweet Corner','Nutella',13),
('ST030','Trieste Beer Garden','Heineken',14),
('ST031','Classic Lounge Parma','Campari',15),
('ST032','Jazz Food Perugia','Old Wild West',16),
('ST033','Fusion Merch Perugia','Vans',16),
('ST034','Pop Food Ancona','McDonald''s',17),
('ST035','Ancona Drinks','Coca-Cola',17),
('ST036','Beach Bar Rimini','Red Bull',18),
('ST037','Rimini Merch Shop','Adidas',18),
('ST038','Pisa Local Snacks','SnackUp',19),
('ST039','Metal Food Modena','Burger King',20),
('ST040','Modena Merch','Hard Rock Cafe',20),
('ST041','Reggio Food Truck','Autogrill',21),
('ST042','Reggio Drink Spot','Pepsi',21),
('ST043','Lucca Merch Stand','Levi''s',22),
('ST044','Aosta Drink Tent','Heineken',23),
('ST045','Pescara Food Point','Eataly',24),
('ST046','Riviera Merch Pescara','Spotify',24),
('ST047','Como Drinks','Campari',25),
('ST048','Como Merch','Vans',25);

-- Product_Food data
INSERT INTO Product_Food (Barcode_Food, Name, Price, Expiration_Date, Type) VALUES
(8001234567890,'Classic Burger',9.50,'2026-06-30','meat'),
(8012345678901,'Vegan Wrap',8.00,'2026-07-15','vegan'),
(8023456789012,'Cheese Fries',6.00,'2026-06-01','snack'),
(8034567890123,'Pizza Slice',5.50,'2026-06-05','vegetarian'),
(8045678901234,'Hotdog',6.50,'2026-08-10','meat'),
(8056789012345,'Vegetarian Sandwich',7.00,'2026-07-20','vegetarian'),
(8067890123456,'Chicken Nuggets',7.50,'2026-08-01','meat'),
(8078901234567,'Nutella Crepe',5.00,'2026-06-25','snack'),
(8089012345678,'Sicilian Arancino',5.50,'2026-09-01','meat'),
(8090123456789,'Caesar Salad',7.00,'2026-06-18','vegetarian');

-- Product_Drink data
INSERT INTO Product_Drink (Barcode_Drink, Name, Price, Expiration_Date) VALUES
(5449000000996,'Coca-Cola Zero 330ml',3.00,'2026-12-31'),
(8712000055998,'Heineken Beer 500ml',5.00,'2026-12-31'),
(9012345678901,'Red Bull Energy Drink',4.50,'2026-09-30'),
(8001234000001,'Natural Water 500ml',2.00,'2026-11-15'),
(8021234000002,'Orange Juice',3.50,'2026-10-01'),
(8031234000003,'Iced Coffee',3.00,'2026-09-15'),
(8041234000004,'Gin Tonic',6.00,'2026-08-20'),
(8051234000005,'Campari Spritz',6.50,'2026-09-10'),
(5000123432100,'Pepsi 330ml',3.00,'2026-11-01'),
(8076543210009,'Lemon Tea',2.50,'2026-08-30');

-- Product_Merchandise data
INSERT INTO Product_Merchandise (Barcode_Merchandise, Name, Price) VALUES
(2000001111111,'Festival T-Shirt',25.00),
(2000002222222,'Festival Cap',15.00),
(2000003333333,'Poster Limited Edition',20.00),
(2000004444444,'Vinyl Record',40.00),
(2000005555555,'Festival Hoodie',45.00),
(2000006666666,'Reusable Bottle',18.00);

-- Sell_Food relation data
INSERT INTO Sell_Food (ID_Sell, ID_Stand, Barcode_Food) VALUES
('SF01','ST002',8001234567890),
('SF02','ST002',8023456789012),
('SF03','ST005',8034567890123),
('SF04','ST005',8090123456789),
('SF05','ST008',8012345678901),
('SF06','ST010',8045678901234),
('SF07','ST014',8056789012345),
('SF08','ST020',8089012345678),
('SF09','ST026',8078901234567),
('SF10','ST034',8001234567890),
('SF11','ST041',8067890123456),
('SF12','ST045',8023456789012);

-- Sell_Drink relation data
INSERT INTO Sell_Drink (ID_Sell, ID_Stand, Barcode_Drink) VALUES
('SD01','ST001',5449000000996),
('SD02','ST004',8712000055998),
('SD03','ST007',9012345678901),
('SD04','ST009',8031234000003),
('SD05','ST015',8051234000005),
('SD06','ST017',8712000055998),
('SD07','ST021',5449000000996),
('SD08','ST025',9012345678901),
('SD09','ST030',8712000055998),
('SD10','ST035',5000123432100),
('SD11','ST036',9012345678901),
('SD12','ST042',5000123432100),
('SD13','ST044',8712000055998),
('SD14','ST047',8041234000004);

-- Sell_Merchandise relation data
INSERT INTO Sell_Merchandise (ID_Sell, ID_Stand, Barcode_Merchandise) VALUES
('SM01','ST003',2000001111111),
('SM02','ST006',2000002222222),
('SM03','ST011',2000003333333),
('SM04','ST013',2000005555555),
('SM05','ST016',2000001111111),
('SM06','ST022',2000004444444),
('SM07','ST027',2000001111111),
('SM08','ST033',2000006666666),
('SM09','ST037',2000001111111),
('SM10','ST040',2000003333333),
('SM11','ST043',2000002222222),
('SM12','ST046',2000004444444),
('SM13','ST048',2000005555555);

-- Customer data
INSERT INTO Customer (ID_Customer, Full_Name, Email_Address, Phone_Number) VALUES
('C001','Luca Rossi','luca.rossi@email.com','+39 3311111101'),
('C002','Giulia Bianchi','giulia.bianchi@email.com','+39 3311111102'),
('C003','Marco Verdi','marco.verdi@email.com','+39 3311111103'),
('C004','Sara Neri','sara.neri@email.com','+39 3311111104'),
('C005','Francesco Esposito','francesco.esposito@email.com','+39 3311111105'),
('C006','Martina Gallo','martina.gallo@email.com','+39 3311111106'),
('C007','Davide Romano','davide.romano@email.com','+39 3311111107'),
('C008','Guendalina Nardi','guendalina.nardi@email.com','+39 3311111108'),
('C009','Andrea Conti','andrea.conti@email.com','+39 3311111109'),
('C010','Sofia Varotto','sofia.varotto@email.com','+39 3311111110'),
('C011','Simone Ricci','simone.ricci@email.com','+39 3311111111'),
('C012','Valentina Ferri','valentina.ferri@email.com','+39 3311111112'),
('C013','Federico Colombo','federico.colombo@email.com','+39 3311111113'),
('C014','Alessia De Luca','alessia.deluca@email.com','+39 3311111114'),
('C015','Matteo Barbieri','matteo.barbieri@email.com','+39 3311111115'),
('C016','Giorgia Marchetti','giorgia.marchetti@email.com','+39 3311111116'),
('C017','Lorenzo Testa','lorenzo.testa@email.com','+39 3311111117'),
('C018','Camilla Costa','camilla.costa@email.com','+39 3311111118'),
('C019','Alessandro Bruno','alessandro.bruno@email.com','+39 3311111119'),
('C020','Silvia Rizzi','silvia.rizzi@email.com','+39 3311111120'),
('C021','Riccardo Greco','riccardo.greco@email.com','+39 3311111121'),
('C022','Eleonora Caruso','eleonora.caruso@email.com','+39 3311111122'),
('C023','Tommaso Gatti','tommaso.gatti@email.com','+39 3311111123'),
('C024','Beatrice Leone','beatrice.leone@email.com','+39 3311111124'),
('C025','Daniele Serra','daniele.serra@email.com','+39 3311111125'),
('C026','Sofia Fabbri','sofia.fabbri@email.com','+39 3311111126'),
('C027','Gabriele Longo','gabriele.longo@email.com','+39 3311111127'),
('C028','Ilaria Gentile','ilaria.gentile@email.com','+39 3311111128'),
('C029','Stefano Morelli','stefano.morelli@email.com','+39 3311111129'),
('C030','Chiara Marino','chiara.marino@email.com','+39 3311111130'),
('C031','Antonio Fiore','antonio.fiore@email.com','+39 3311111131'),
('C032','Martina Villa','martina.villa@email.com','+39 3311111132'),
('C033','Filippo Ferrara','filippo.ferrara@email.com','+39 3311111133'),
('C034','Veronica Romano','veronica.romano@email.com','+39 3311111134'),
('C035','Emanuele Neri','emanuele.neri@email.com','+39 3311111135'),
('C036','Irene De Angelis','irene.deangelis@email.com','+39 3311111136'),
('C037','Cristian Monti','cristian.monti@email.com','+39 3311111137'),
('C038','Francesca Vitale','francesca.vitale@email.com','+39 3311111138'),
('C039','Davide Gallo','davide.gallo@email.com','+39 3311111139'),
('C040','Eleonora Palmieri','eleonora.palmieri@email.com','+39 3311111140'),
('C041','Giorgio Leone','giorgio.leone@email.com','+39 3311111141'),
('C042','Aurora Martini','aurora.martini@email.com','+39 3311111142'),
('C043','Mattia Esposito','mattia.esposito@email.com','+39 3311111143'),
('C044','Elisa Ricci','elisa.ricci@email.com','+39 3311111144'),
('C045','Andrea De Santis','andrea.desantis@email.com','+39 3311111145'),
('C046','Chiara Riva','chiara.riva@email.com','+39 3311111146'),
('C047','Davide Testoni','davide.testoni@email.com','+39 3311111147'),
('C048','Camilla Grassi','camilla.grassi@email.com','+39 3311111148'),
('C049','Riccardo Fontana','riccardo.fontana@email.com','+39 3311111149'),
('C050','Sara Lombardi','sara.lombardi@email.com','+39 3311111150'),
('C051','Alessio Riva','alessio.riva@email.com','+39 3311111151'),
('C052','Giada Pellegrini','giada.pellegrini@email.com','+39 3311111152'),
('C053','Michele Romano','michele.romano@email.com','+39 3311111153'),
('C054','Alice Greco','alice.greco@email.com','+39 3311111154'),
('C055','Matilde Galli','matilde.galli@email.com','+39 3311111155'),
('C056','Edoardo Ferri','edoardo.ferri@email.com','+39 3311111156'),
('C057','Claudia Serra','claudia.serra@email.com','+39 3311111157'),
('C058','Francesco D''Amico','francesco.damico@email.com','+39 3311111158'),
('C059','Lucia Gentili','lucia.gentili@email.com','+39 3311111159'),
('C060','Stefano Valentini','stefano.valentini@email.com','+39 3311111160'),
('C061','Beatrice Rinaldi','beatrice.rinaldi@email.com','+39 3311111161'),
('C062','Nicola Marchetti','nicola.marchetti@email.com','+39 3311111162'),
('C063','Marta Sanna','marta.sanna@email.com','+39 3311111163'),
('C064','Giacomo Serra','giacomo.serra@email.com','+39 3311111164'),
('C065','Paola Greco','paola.greco@email.com','+39 3311111165'),
('C066','Vittorio Sala','vittorio.sala@email.com','+39 3311111166'),
('C067','Noemi Parisi','noemi.parisi@email.com','+39 3311111167'),
('C068','Raffaele Riva','raffaele.riva@email.com','+39 3311111168'),
('C069','Eleonora Pozzi','eleonora.pozzi@email.com','+39 3311111169'),
('C070','Lorenzo Fonti','lorenzo.fonti@email.com','+39 3311111170'),
('C071','Elisa Orlando','elisa.orlando@email.com','+39 3311111171'),
('C072','Matteo Gori','matteo.gori@email.com','+39 3311111172'),
('C073','Arianna Serra','arianna.serra@email.com','+39 3311111173'),
('C074','Gianluca Leone','gianluca.leone@email.com','+39 3311111174'),
('C075','Ilaria Bassi','ilaria.bassi@email.com','+39 3311111175'),
('C076','Alberto Villa','alberto.villa@email.com','+39 3311111176'),
('C077','Serena De Luca','serena.deluca@email.com','+39 3311111177'),
('C078','Pietro Rizzi','pietro.rizzi@email.com','+39 3311111178'),
('C079','Greta Conti','greta.conti@email.com','+39 3311111179'),
('C080','Giorgia Fiore','giorgia.fiore@email.com','+39 3311111180');

-- Ticket data (150)
INSERT INTO Ticket (ID_Ticket, Ticket_Type, Price, Start_Validity, End_Validity, ID_Festival) VALUES
('T001','DAY_PASS',49.00,'2025-06-20','2025-06-20',1),
('T002','DAY_PASS',29.00,'2025-06-20','2025-06-20',1),
('T003','DAY_PASS',49.00,'2025-06-20','2025-06-20',1),
('T004','DAY_PASS',39.00,'2025-06-21','2025-06-21',1),
('T005','DAY_PASS',49.00,'2025-06-20','2025-06-20',1),
('T006','DAY_PASS',49.00,'2025-06-20','2025-06-20',1),
('T007','DAY_PASS',59.00,'2025-07-10','2025-07-10',2),
('T008','DAY_PASS',49.00,'2025-07-10','2025-07-10',2),
('T009','DAY_PASS',49.00,'2025-07-10','2025-07-10',2),
('T010','DAY_PASS',19.00,'2025-07-12','2025-07-12',2),
('T011','DAY_PASS',49.00,'2025-07-10','2025-07-10',2),
('T012','DAY_PASS',49.00,'2025-07-10','2025-07-10',2),
('T013','DAY_PASS',49.00,'2025-08-05','2025-08-05',3),
('T014','DAY_PASS',49.00,'2025-08-05','2025-08-05',3),
('T015','DAY_PASS',49.00,'2025-08-05','2025-08-05',3),
('T016','DAY_PASS',49.00,'2025-08-06','2025-08-06',3),
('T017','DAY_PASS',49.00,'2025-08-05','2025-08-05',3),
('T018','DAY_PASS',49.00,'2025-08-05','2025-08-05',3),
('T019','DAY_PASS',49.00,'2025-09-01','2025-09-01',4),
('T020','DAY_PASS',49.00,'2025-09-01','2025-09-01',4),
('T021','DAY_PASS',49.00,'2025-09-01','2025-09-01',4),
('T022','DAY_PASS',49.00,'2025-09-02','2025-09-02',4),
('T023','DAY_PASS',59.00,'2025-09-01','2025-09-01',4),
('T024','DAY_PASS',49.00,'2025-09-01','2025-09-01',4),
('T025','DAY_PASS',49.00,'2026-06-14','2026-06-14',5),
('T026','DAY_PASS',49.00,'2026-06-14','2026-06-14',5),
('T027','DAY_PASS',49.00,'2026-06-14','2026-06-14',5),
('T028','DAY_PASS',49.00,'2026-06-15','2026-06-15',5),
('T029','DAY_PASS',49.00,'2026-06-14','2026-06-14',5),
('T030','DAY_PASS',49.00,'2026-06-14','2026-06-14',5),
('T031','DAY_PASS',29.00,'2026-07-02','2026-07-02',6),
('T032','DAY_PASS',49.00,'2026-07-02','2026-07-02',6),
('T033','DAY_PASS',49.00,'2026-07-02','2026-07-02',6),
('T034','DAY_PASS',49.00,'2026-07-03','2026-07-03',6),
('T035','DAY_PASS',49.00,'2026-07-02','2026-07-02',6),
('T036','DAY_PASS',49.00,'2026-07-02','2026-07-02',6),
('T037','DAY_PASS',49.00,'2026-08-10','2026-08-10',7),
('T038','DAY_PASS',49.00,'2026-08-10','2026-08-10',7),
('T039','DAY_PASS',39.00,'2026-08-11','2026-08-11',7),
('T040','DAY_PASS',49.00,'2026-08-12','2026-08-12',7),
('T041','DAY_PASS',49.00,'2026-08-10','2026-08-10',7),
('T042','DAY_PASS',49.00,'2026-08-10','2026-08-10',7),
('T043','DAY_PASS',49.00,'2026-09-05','2026-09-05',8),
('T044','DAY_PASS',49.00,'2026-09-05','2026-09-05',8),
('T045','DAY_PASS',49.00,'2026-09-05','2026-09-05',8),
('T046','DAY_PASS',59.00,'2026-09-05','2026-09-05',8),
('T047','DAY_PASS',49.00,'2026-09-05','2026-09-05',8),
('T048','DAY_PASS',49.00,'2026-09-05','2026-09-05',8),
('T049','DAY_PASS',29.00,'2027-06-22','2027-06-22',9),
('T050','DAY_PASS',49.00,'2027-06-22','2027-06-22',9),
('T051','DAY_PASS',49.00,'2027-06-22','2027-06-22',9),
('T052','DAY_PASS',49.00,'2027-06-23','2027-06-23',9),
('T053','DAY_PASS',49.00,'2027-06-22','2027-06-22',9),
('T054','DAY_PASS',49.00,'2027-06-22','2027-06-22',9),
('T055','DAY_PASS',49.00,'2027-07-13','2027-07-13',10),
('T056','DAY_PASS',39.00,'2027-07-13','2027-07-13',10),
('T057','DAY_PASS',49.00,'2027-07-13','2027-07-13',10),
('T058','DAY_PASS',49.00,'2027-07-14','2027-07-14',10),
('T059','DAY_PASS',49.00,'2027-07-13','2027-07-13',10),
('T060','DAY_PASS',39.00,'2027-07-13','2027-07-13',10),
('T061','DAY_PASS',49.00,'2027-08-18','2027-08-18',11),
('T062','DAY_PASS',49.00,'2027-08-18','2027-08-18',11),
('T063','DAY_PASS',49.00,'2027-08-18','2027-08-18',11),
('T064','DAY_PASS',49.00,'2027-08-19','2027-08-19',11),
('T065','DAY_PASS',19.00,'2027-08-18','2027-08-18',11),
('T066','DAY_PASS',49.00,'2027-08-18','2027-08-18',11),
('T067','DAY_PASS',49.00,'2027-09-10','2027-09-10',12),
('T068','DAY_PASS',59.00,'2027-09-10','2027-09-10',12),
('T069','DAY_PASS',49.00,'2027-09-10','2027-09-10',12),
('T070','DAY_PASS',49.00,'2027-09-11','2027-09-11',12),
('T071','DAY_PASS',49.00,'2027-09-10','2027-09-10',12),
('T072','DAY_PASS',39.00,'2027-09-10','2027-09-10',12),
('T073','DAY_PASS',49.00,'2028-06-12','2028-06-12',13),
('T074','DAY_PASS',49.00,'2028-06-12','2028-06-12',13),
('T075','DAY_PASS',49.00,'2028-06-12','2028-06-12',13),
('T076','DAY_PASS',49.00,'2028-06-13','2028-06-13',13),
('T077','DAY_PASS',49.00,'2028-06-12','2028-06-12',13),
('T078','DAY_PASS',69.00,'2028-06-12','2028-06-12',13),
('T079','DAY_PASS',49.00,'2028-07-01','2028-07-01',14),
('T080','DAY_PASS',49.00,'2028-07-01','2028-07-01',14),
('T081','DAY_PASS',49.00,'2028-07-01','2028-07-01',14),
('T082','DAY_PASS',49.00,'2028-07-01','2028-07-01',14),
('T083','DAY_PASS',49.00,'2028-07-01','2028-07-01',14),
('T084','DAY_PASS',49.00,'2028-07-01','2028-07-01',14),
('T085','DAY_PASS',49.00,'2028-07-20','2028-07-20',15),
('T086','DAY_PASS',49.00,'2028-07-20','2028-07-20',15),
('T087','DAY_PASS',29.00,'2028-07-20','2028-07-20',15),
('T088','DAY_PASS',49.00,'2028-07-21','2028-07-21',15),
('T089','DAY_PASS',49.00,'2028-07-20','2028-07-20',15),
('T090','DAY_PASS',49.00,'2028-07-20','2028-07-20',15),
('T091','DAY_PASS',59.00,'2028-08-03','2028-08-03',16),
('T092','DAY_PASS',49.00,'2028-08-03','2028-08-03',16),
('T093','DAY_PASS',49.00,'2028-08-03','2028-08-03',16),
('T094','DAY_PASS',49.00,'2028-08-04','2028-08-04',16),
('T095','DAY_PASS',29.00,'2028-08-03','2028-08-03',16),
('T096','DAY_PASS',49.00,'2028-08-03','2028-08-03',16),
('T097','DAY_PASS',39.00,'2028-08-25','2028-08-25',17),
('T098','DAY_PASS',49.00,'2028-08-25','2028-08-25',17),
('T099','DAY_PASS',49.00,'2028-08-25','2028-08-25',17),
('T100','DAY_PASS',49.00,'2028-08-26','2028-08-26',17),
('T101','DAY_PASS',49.00,'2028-08-25','2028-08-25',17),
('T102','DAY_PASS',39.00,'2028-08-25','2028-08-25',17),
('T103','DAY_PASS',49.00,'2028-09-06','2028-09-06',18),
('T104','DAY_PASS',49.00,'2028-09-06','2028-09-06',18),
('T105','DAY_PASS',49.00,'2028-09-06','2028-09-06',18),
('T106','DAY_PASS',49.00,'2028-09-08','2028-09-08',18),
('T107','DAY_PASS',49.00,'2028-09-06','2028-09-06',18),
('T108','DAY_PASS',31.00,'2028-09-06','2028-09-06',18),
('T109','DAY_PASS',49.00,'2027-06-15','2027-06-15',19),
('T110','DAY_PASS',49.00,'2027-06-15','2027-06-15',19),
('T111','DAY_PASS',49.00,'2027-06-15','2027-06-15',19),
('T112','DAY_PASS',49.00,'2027-06-16','2027-06-16',19),
('T113','DAY_PASS',29.00,'2027-06-15','2027-06-15',19),
('T114','DAY_PASS',49.00,'2027-06-15','2027-06-15',19),
('T115','DAY_PASS',49.00,'2026-07-08','2026-07-08',20),
('T116','DAY_PASS',49.00,'2026-07-08','2026-07-08',20),
('T117','DAY_PASS',49.00,'2026-07-08','2026-07-08',20),
('T118','DAY_PASS',20.00,'2026-07-08','2026-07-08',20),
('T119','DAY_PASS',49.00,'2026-07-08','2026-07-08',20),
('T120','DAY_PASS',49.00,'2026-07-08','2026-07-08',20),
('T121','REGULAR',129.00,'2025-06-20','2025-06-22',1),
('T122','VIP',399.00,'2025-06-20','2025-06-22',1),
('T123','REGULAR',129.00,'2025-07-10','2025-07-13',2),
('T124','VIP',180.00,'2025-07-10','2025-07-13',2),
('T125','REGULAR',129.00,'2025-08-05','2025-08-06',3),
('T126','VIP',199.00,'2025-08-05','2025-08-06',3),
('T127','REGULAR',129.00,'2025-09-01','2025-09-03',4),
('T128','VIP',199.00,'2025-09-01','2025-09-03',4),
('T129','REGULAR',179.00,'2026-06-14','2026-06-15',5),
('T130','VIP',199.00,'2026-06-14','2026-06-15',5),
('T131','REGULAR',129.00,'2026-07-02','2026-07-04',6),
('T132','VIP',199.00,'2026-07-02','2026-07-04',6),
('T133','REGULAR',129.00,'2026-08-10','2026-08-12',7),
('T134','VIP',300.00,'2026-08-10','2026-08-12',7),
('T135','REGULAR',129.00,'2026-09-05','2026-09-05',8),
('T136','VIP',199.00,'2026-09-05','2026-09-05',8),
('T137','REGULAR',129.00,'2027-06-22','2027-06-23',9),
('T138','VIP',199.00,'2027-06-22','2027-06-23',9),
('T139','REGULAR',129.00,'2027-07-13','2027-07-15',10),
('T140','VIP',199.00,'2027-07-13','2027-07-15',10),
('T141','REGULAR',140.00,'2027-08-18','2027-08-20',11),
('T142','VIP',199.00,'2027-08-18','2027-08-20',11),
('T143','REGULAR',129.00,'2027-09-10','2027-09-11',12),
('T144','VIP',199.00,'2027-09-10','2027-09-11',12),
('T145','REGULAR',129.00,'2028-06-12','2028-06-14',13),
('T146','VIP',210.00,'2028-06-12','2028-06-14',13),
('T147','REGULAR',129.00,'2028-07-01','2028-07-01',14),
('T148','VIP',199.00,'2028-07-01','2028-07-01',14),
('T149','REGULAR',129.00,'2028-07-20','2028-07-22',15),
('T150','VIP',155.00,'2028-07-20','2028-07-22',15);

-- Ticket_Payment data (sold tickets)
INSERT INTO Ticket_Payment (Ticket_ID, ID_Customer, Payment_Date, Payment_Method) VALUES
('T001','C001','2025-06-20','credit_card'),
('T004','C002','2025-06-21','paypal'),
('T009','C003','2025-07-10','debit_card'),
('T013','C004','2025-08-05','cash'),
('T016','C005','2025-08-06','credit_card'),
('T020','C006','2025-09-01','paypal'),
('T022','C007','2025-09-02','debit_card'),
('T027','C008','2026-06-14','credit_card'),
('T031','C009','2026-07-02','cash'),
('T035','C010','2026-07-02','paypal'),
('T037','C011','2026-08-10','credit_card'),
('T039','C012','2026-08-11','debit_card'),
('T043','C013','2026-09-05','cash'),
('T046','C014','2026-09-05','paypal'),
('T049','C015','2027-06-22','credit_card'),
('T052','C016','2027-06-23','paypal'),
('T055','C017','2027-07-13','debit_card'),
('T058','C018','2027-07-14','cash'),
('T061','C019','2027-08-18','credit_card'),
('T064','C020','2027-08-19','paypal'),
('T067','C021','2027-09-10','debit_card'),
('T070','C022','2027-09-11','cash'),
('T073','C023','2028-06-12','credit_card'),
('T075','C024','2028-06-12','paypal'),
('T079','C025','2028-07-01','debit_card'),
('T081','C026','2028-07-01','cash'),
('T085','C027','2028-07-20','credit_card'),
('T087','C028','2028-07-20','paypal'),
('T091','C029','2028-08-03','debit_card'),
('T094','C030','2028-08-04','credit_card'),
('T097','C031','2028-08-25','paypal'),
('T100','C032','2028-08-26','debit_card'),
('T103','C033','2028-09-06','cash'),
('T106','C034','2028-09-08','credit_card'),
('T109','C035','2027-06-15','paypal'),
('T111','C036','2027-06-15','debit_card'),
('T115','C037','2026-07-08','credit_card'),
('T118','C038','2026-07-08','paypal'),
('T120','C039','2026-07-08','cash'),
('T121','C040','2025-06-20','credit_card'),
('T123','C041','2025-07-10','paypal'),
('T125','C042','2025-08-05','debit_card'),
('T127','C043','2025-09-01','cash'),
('T129','C044','2026-06-14','credit_card'),
('T131','C045','2026-07-02','paypal'),
('T133','C046','2026-08-10','debit_card'),
('T135','C047','2026-09-05','cash'),
('T137','C048','2027-06-22','credit_card'),
('T139','C049','2027-07-13','paypal'),
('T141','C050','2027-08-18','debit_card'),
('T143','C051','2027-09-10','cash'),
('T145','C052','2028-06-12','credit_card'),
('T147','C053','2028-07-01','paypal'),
('T149','C054','2028-07-20','debit_card'),
('T122','C055','2025-06-20','cash'),
('T124','C056','2025-07-10','credit_card'),
('T126','C057','2025-08-05','paypal'),
('T128','C058','2025-09-01','debit_card'),
('T130','C059','2026-06-14','cash'),
('T132','C060','2026-07-02','credit_card'),
('T134','C061','2026-08-10','paypal'),
('T136','C062','2026-09-05','debit_card'),
('T138','C063','2027-06-22','cash'),
('T140','C064','2027-07-13','credit_card'),
('T142','C065','2027-08-18','paypal'),
('T144','C066','2027-09-10','debit_card'),
('T146','C067','2028-06-12','credit_card'),
('T148','C068','2028-07-01','paypal'),
('T150','C069','2028-07-20','debit_card'),
('T122','C070','2025-06-20','cash'),
('T123','C071','2025-07-10','credit_card'),
('T125','C072','2025-08-05','paypal'),
('T127','C073','2025-09-01','debit_card'),
('T129','C074','2026-06-14','cash'),
('T131','C075','2026-07-02','credit_card'),
('T133','C076','2026-08-10','paypal'),
('T135','C077','2026-09-05','debit_card'),
('T122','C078','2025-06-20','credit_card'),
('T124','C079','2025-07-10','paypal'),
('T126','C080','2025-08-05','debit_card'),
('T128','C001','2025-09-01','cash'),
('T130','C002','2026-06-14','credit_card'),
('T132','C003','2026-07-02','paypal'),
('T134','C004','2026-08-10','debit_card'),
('T136','C005','2026-09-05','cash'),
('T138','C006','2027-06-22','credit_card'),
('T140','C007','2027-07-13','paypal'),
('T142','C008','2027-08-18','debit_card'),
('T144','C009','2027-09-10','cash'),
('T146','C010','2028-06-12','credit_card'),
('T148','C011','2028-07-01','paypal'),
('T150','C012','2028-07-20','debit_card'),
('T122','C013','2025-06-20','cash'),
('T124','C014','2025-07-10','credit_card'),
('T126','C015','2025-08-05','paypal'),
('T128','C016','2025-09-01','debit_card'),
('T130','C017','2026-06-14','cash'),
('T132','C018','2026-07-02','credit_card'),
('T134','C019','2026-08-10','paypal'),
('T136','C020','2026-09-05','debit_card'),
('T138','C021','2027-06-22','cash'),
('T140','C022','2027-07-13','credit_card'),
('T142','C023','2027-08-18','paypal'),
('T144','C024','2027-09-10','debit_card'),
('T146','C025','2028-06-12','credit_card'),
('T148','C026','2028-07-01','paypal'),
('T150','C027','2028-07-20','debit_card'),
('T122','C028','2025-06-20','cash'),
('T124','C029','2025-07-10','credit_card'),
('T126','C030','2025-08-05','paypal'),
('T128','C031','2025-09-01','debit_card'),
('T130','C032','2026-06-14','cash'),
('T132','C033','2026-07-02','credit_card'),
('T134','C034','2026-08-10','paypal'),
('T136','C035','2026-09-05','debit_card'),
('T138','C036','2027-06-22','cash'),
('T140','C037','2027-07-13','credit_card');

-- Buy_Food data
INSERT INTO Buy_Food (ID_Buy, ID_Customer, Barcode_Food) VALUES
('BF01','C026',8001234567890),
('BF02','C002',8034567890123),
('BF03','C003',8012345678901),
('BF04','C004',8045678901234),
('BF05','C005',8056789012345),
('BF06','C006',8078901234567),
('BF07','C007',8089012345678),
('BF08','C008',8023456789012),
('BF09','C009',8067890123456),
('BF10','C010',8090123456789),
('BF11','C011',8001234567890),
('BF12','C012',8034567890123),
('BF13','C013',8012345678901),
('BF14','C014',8078901234567),
('BF15','C015',8089012345678),
('BF16','C016',8023456789012),
('BF17','C017',8045678901234),
('BF18','C018',8056789012345),
('BF19','C019',8067890123456),
('BF20','C020',8090123456789),
('BF21','C021',8001234567890),
('BF22','C022',8012345678901),
('BF23','C023',8078901234567),
('BF24','C024',8089012345678),
('BF25','C025',8023456789012);

-- Buy_Drinks data
INSERT INTO Buy_Drinks (ID_Buy, ID_Customer, Barcode_Drink) VALUES
('BD01','C026',5449000000996),
('BD02','C027',8712000055998),
('BD03','C028',9012345678901),
('BD04','C029',8001234000001),
('BD05','C010',8021234000002),
('BD06','C031',8031234000003),
('BD07','C032',8041234000004),
('BD08','C033',8051234000005),
('BD09','C034',5000123432100),
('BD10','C035',8076543210009),
('BD11','C036',5449000000996),
('BD12','C037',8712000055998),
('BD13','C038',9012345678901),
('BD14','C039',8001234000001),
('BD15','C040',8021234000002),
('BD16','C041',8031234000003),
('BD17','C042',8041234000004),
('BD18','C008',8051234000005),
('BD19','C044',5000123432100),
('BD20','C045',8076543210009),
('BD21','C046',5449000000996),
('BD22','C047',8712000055998),
('BD23','C048',9012345678901),
('BD24','C049',8001234000001),
('BD25','C050',8021234000002),
('BD26','C051',8031234000003),
('BD27','C008',8041234000004),
('BD28','C053',8051234000005),
('BD29','C037',5000123432100),
('BD30','C037',8076543210009);

-- Buy_Merchandise data
INSERT INTO Buy_Merchandise (ID_Buy, ID_Customer, Barcode_Merchandise) VALUES
('BM01','C056',2000001111111),
('BM02','C057',2000002222222),
('BM03','C058',2000003333333),
('BM04','C033',2000004444444),
('BM05','C034',2000005555555),
('BM06','C061',2000006666666),
('BM07','C062',2000001111111),
('BM08','C063',2000002222222),
('BM09','C064',2000003333333),
('BM10','C065',2000004444444),
('BM11','C066',2000005555555),
('BM12','C067',2000006666666),
('BM13','C068',2000001111111),
('BM14','C069',2000002222222),
('BM15','C070',2000003333333),
('BM16','C071',2000004444444),
('BM17','C072',2000005555555),
('BM18','C073',2000006666666);


------------------------------------------------------------
-- QUERY SUITE — ANALYSIS & REPORTING (SQL)
------------------------------------------------------------

------------------------------------------------------------
-- a. WHERE
------------------------------------------------------------

-- (1) Find all tickets above 100€
SELECT ID_Ticket, Ticket_Type, Price
FROM Ticket
WHERE Price > 100;

-- (2) Find all festivals happening in 2027
SELECT Name, Location, Start_Date, End_Date
FROM Festival
WHERE Start_Date BETWEEN '2027-01-01' AND '2027-12-31';


------------------------------------------------------------
-- b. WHERE, LIMIT, LIKE
------------------------------------------------------------

-- (1) First 10 customers with email containing “gmail”
SELECT Full_Name, Email_Address
FROM Customer
WHERE Email_Address LIKE '%mail%'
LIMIT 10;

-- (2) Italian artists whose stage name starts with ‘M’
SELECT Artist_Stage_Name, Genre, Country
FROM Artist_Solo_Musician
WHERE Country = 'Italy' AND Artist_Stage_Name LIKE 'M%';

-- (3) 3 cheapest VIP tickets
SELECT ID_Ticket, Price, ID_Festival
FROM Ticket
WHERE Ticket_Type = 'VIP'
ORDER BY Price ASC
LIMIT 3;


------------------------------------------------------------
-- c. WHERE, IN, Nested Query
------------------------------------------------------------

-- (1) Customers who bought tickets for “Roma Indie Fest”
SELECT c.Full_Name, c.ID_Customer
FROM Customer c
WHERE c.ID_Customer IN (
    SELECT tp.ID_Customer
    FROM Ticket_Payment tp
    JOIN Ticket t ON tp.Ticket_ID = t.ID_Ticket
    JOIN Festival f ON t.ID_Festival = f.ID_Festival
    WHERE f.Name = 'Roma Indie Fest'
);

-- (2) VIP tickets from festivals held in 2028
SELECT ID_Ticket, Price, ID_Festival
FROM Ticket
WHERE ID_Festival IN (
    SELECT ID_Festival FROM Festival WHERE Start_Date BETWEEN '2028-01-01' AND '2028-12-31'
)
AND Ticket_Type = 'VIP';

-- (3) Customers who bought both Food and Drinks
SELECT DISTINCT 
    c.Full_Name AS Customer,
    pd.Name AS Drink_Name,
    pf.Name AS Food_Name
FROM Customer c
JOIN Buy_Drinks bd ON c.ID_Customer = bd.ID_Customer
JOIN Product_Drink pd ON bd.Barcode_Drink = pd.Barcode_Drink
JOIN Buy_Food bf ON c.ID_Customer = bf.ID_Customer
JOIN Product_Food pf ON bf.Barcode_Food = pf.Barcode_Food
WHERE c.ID_Customer IN (
    SELECT ID_Customer FROM Buy_Food
);


------------------------------------------------------------
-- d. GROUP BY, 1 JOIN, AS
------------------------------------------------------------

-- (1) Average ticket price per festival
SELECT f.Name AS Festival, ROUND(AVG(t.Price), 2) AS Avg_Price
FROM Festival f
JOIN Ticket t ON f.ID_Festival = t.ID_Festival
GROUP BY f.Name;

-- (2) Number of stands per festival
SELECT f.Name AS Festival, COUNT(s.ID_Stand) AS Total_Stands
FROM Festival f
JOIN Stand s ON f.ID_Festival = s.ID_Festival
GROUP BY f.Name;

-- (3) Number of performances per stage
SELECT s.Name AS Stage, COUNT(p.ID_Performance) AS Performances
FROM Stage s
JOIN Performance p ON s.ID_Stage = p.ID_Stage
GROUP BY s.Name;


------------------------------------------------------------
-- e. WHERE, GROUP BY
------------------------------------------------------------

-- (1) Count food products costing more than 7€
SELECT Type, COUNT(*) AS Count
FROM Product_Food
WHERE Price > 7
GROUP BY Type;

-- (2) Number of Italian artists per genre
SELECT Genre, COUNT(*) AS Total_Artists
FROM Artist_Solo_Musician
WHERE Country = 'Italy'
GROUP BY Genre;

-- (3) Count tickets by type for festivals in 2026
SELECT Ticket_Type, COUNT(*) AS Num_Tickets
FROM Ticket
WHERE Start_Validity BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY Ticket_Type;


------------------------------------------------------------
-- f. GROUP BY, HAVING, AS
------------------------------------------------------------

-- (1) Festivals with more than 2 stands
SELECT f.Name AS Festival, COUNT(s.ID_Stand) AS Num_Stands
FROM Festival f
JOIN Stand s ON f.ID_Festival = s.ID_Festival
GROUP BY f.Name
HAVING COUNT(s.ID_Stand) > 2;

-- (2) Artists with more than 3 performances
SELECT a.Artist_Stage_Name AS Artist, COUNT(ps.ID_Performance) AS Num_Performances
FROM Artist_Solo_Musician a
JOIN Performance_Solo_Musician ps ON a.ID_Solo_Musician = ps.ID_Solo_Musician
GROUP BY a.Artist_Stage_Name
HAVING COUNT(ps.ID_Performance) > 3
ORDER BY Num_Performances ASC;

-- (3) Drink types with average price > 4€
SELECT Name AS Drink_Name, AVG(Price) AS Avg_Price
FROM Product_Drink
GROUP BY Name
HAVING AVG(Price) > 4;


------------------------------------------------------------
-- g. WHERE, GROUP BY, HAVING, AS
------------------------------------------------------------

-- (1) Festivals in 2027 with average ticket price > 70€
SELECT f.Name AS Festival, AVG(t.Price) AS Avg_Price
FROM Festival f
JOIN Ticket t ON f.ID_Festival = t.ID_Festival
WHERE f.Start_Date BETWEEN '2027-01-01' AND '2027-12-31'
GROUP BY f.Name
HAVING AVG(t.Price) > 70;

-- (2) Customers who bought more than 2 drinks
SELECT ID_Customer, COUNT(*) AS Drinks_Bought
FROM Buy_Drinks
WHERE Barcode_Drink IS NOT NULL
GROUP BY ID_Customer
HAVING COUNT(*) > 2;


------------------------------------------------------------
-- h. WHERE, Nested Query, GROUP BY
------------------------------------------------------------

-- (1) Customers with above-average ticket price
SELECT c.Full_Name AS Customer, ROUND(AVG(t.Price), 2) AS Avg_Ticket_Price
FROM Customer c
JOIN Ticket_Payment tp ON c.ID_Customer = tp.ID_Customer
JOIN Ticket t ON tp.Ticket_ID = t.ID_Ticket
WHERE t.Price > (
    SELECT AVG(Price) FROM Ticket
)
GROUP BY c.Full_Name
ORDER BY Avg_Ticket_Price DESC
LIMIT 10;

-- (2) Most popular genres after 2026
SELECT 
    p.Genre AS Music_Genre,
    COUNT(p.ID_Performance) AS Total_Performances
FROM Performance p
WHERE p.ID_Stage IN (
    SELECT s.ID_Stage
    FROM Stage s
    JOIN Festival f ON s.ID_Festival = f.ID_Festival
    WHERE f.Start_Date >= '2026-01-01'
)
GROUP BY p.Genre
ORDER BY Total_Performances DESC
LIMIT 5;


------------------------------------------------------------
-- i. WHERE, GROUP BY, HAVING, 1 JOIN
------------------------------------------------------------

-- (1) Top 5 festivals by average ticket price
SELECT 
    f.Name AS Festival,
    ROUND(AVG(t.Price), 2) AS Avg_Ticket_Price,
    COUNT(t.ID_Ticket) AS Total_Tickets
FROM Festival f
JOIN Ticket t ON f.ID_Festival = t.ID_Festival
WHERE t.Price > 50
GROUP BY f.Name
HAVING AVG(t.Price) > (
    SELECT AVG(Price) FROM Ticket
)
ORDER BY Avg_Ticket_Price DESC
LIMIT 5;

-- (2) Artists performing in more than one festival
SELECT 
    a.Artist_Stage_Name AS Artist,
    COUNT(DISTINCT f.ID_Festival) AS Festivals_Played
FROM Artist_Solo_Musician a
JOIN Performance_Solo_Musician ps ON a.ID_Solo_Musician = ps.ID_Solo_Musician
JOIN Performance p ON ps.ID_Performance = p.ID_Performance
JOIN Stage s ON p.ID_Stage = s.ID_Stage
JOIN Festival f ON s.ID_Festival = f.ID_Festival
WHERE a.Country = 'Italy'
GROUP BY a.Artist_Stage_Name
HAVING COUNT(DISTINCT f.ID_Festival) > 1
ORDER BY Festivals_Played DESC
LIMIT 10;


------------------------------------------------------------
-- j. WHERE, GROUP BY, HAVING, 2 JOINs
------------------------------------------------------------

-- (1) Festivals with most merchandise sales
SELECT 
    f.Name AS Festival,
    COUNT(bm.ID_Buy) AS Total_Merch_Sold
FROM Festival f
JOIN Stand s ON f.ID_Festival = s.ID_Festival
JOIN Sell_Merchandise sm ON s.ID_Stand = sm.ID_Stand
JOIN Product_Merchandise pm ON sm.Barcode_Merchandise = pm.Barcode_Merchandise
JOIN Buy_Merchandise bm ON pm.Barcode_Merchandise = bm.Barcode_Merchandise
WHERE pm.Price > 10
GROUP BY f.Name
HAVING COUNT(bm.ID_Buy) > 2
ORDER BY Total_Merch_Sold DESC
LIMIT 5;

-- (2) Artist (solo or band) with highest average ticket price (VIP/Regular)
SELECT 
    Artist,
    ROUND(AVG(Price), 2) AS Avg_Ticket_Price,
    COUNT(DISTINCT ID_Performance) AS Performances_Analyzed
FROM (
    SELECT 
        a.Artist_Stage_Name AS Artist,
        p.ID_Performance,
        t.Price
    FROM Artist_Solo_Musician a
    JOIN Performance_Solo_Musician ps ON a.ID_Solo_Musician = ps.ID_Solo_Musician
    JOIN Performance p ON ps.ID_Performance = p.ID_Performance
    JOIN Stage s ON p.ID_Stage = s.ID_Stage
    JOIN Festival f ON s.ID_Festival = f.ID_Festival
    JOIN Ticket t ON f.ID_Festival = t.ID_Festival
    WHERE t.Ticket_Type IN ('VIP','REGULAR')

    UNION ALL

    SELECT 
        b.Artist_Stage_Name AS Artist,
        p.ID_Performance,
        t.Price
    FROM Band b
    JOIN Performance_Band pb ON b.ID_Band = pb.ID_Band
    JOIN Performance p ON pb.ID_Performance = p.ID_Performance
    JOIN Stage s ON p.ID_Stage = s.ID_Stage
    JOIN Festival f ON s.ID_Festival = f.ID_Festival
    JOIN Ticket t ON f.ID_Festival = t.ID_Festival
    WHERE t.Ticket_Type IN ('VIP','REGULAR')
)
GROUP BY Artist
HAVING COUNT(DISTINCT ID_Performance) > 1
ORDER BY Avg_Ticket_Price DESC
LIMIT 10;

