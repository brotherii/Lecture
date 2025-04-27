-- Artist определение

CREATE TABLE Artist
(
    ArtistId INTEGER  NOT NULL,
    Name VARCHAR(120),
    CONSTRAINT PK_Artist PRIMARY KEY  (ArtistId)
);

CREATE UNIQUE INDEX IPK_Artist ON Artist(ArtistId);


-- foo определение

CREATE TABLE foo
    (
       bar int,
       baz varchar(20)
    );


-- Genre определение

CREATE TABLE Genre
(
    GenreId INTEGER  NOT NULL,
    Name VARCHAR(120),
    CONSTRAINT PK_Genre PRIMARY KEY  (GenreId)
);

CREATE UNIQUE INDEX IPK_Genre ON Genre(GenreId);


-- MediaType определение

CREATE TABLE MediaType
(
    MediaTypeId INTEGER  NOT NULL,
    Name VARCHAR(120),
    CONSTRAINT PK_MediaType PRIMARY KEY  (MediaTypeId)
);

CREATE UNIQUE INDEX IPK_MediaType ON MediaType(MediaTypeId);


-- Playlist определение

CREATE TABLE Playlist
(
    PlaylistId INTEGER  NOT NULL,
    Name VARCHAR(120),
    CONSTRAINT PK_Playlist PRIMARY KEY  (PlaylistId)
);

CREATE UNIQUE INDEX IPK_Playlist ON Playlist(PlaylistId);


-- sqlite_schema определение

CREATE TABLE sqlite_schema (
	"type" TEXT,
	name TEXT,
	tbl_name TEXT,
	rootpage INT,
	"sql" TEXT
);


-- Album определение

CREATE TABLE Album
(
    "Album_Id" INTEGER  NOT NULL,
    Title VARCHAR(160)  NOT NULL,
    ArtistId INTEGER  NOT NULL, Column1 bytea NULL,
    CONSTRAINT PK_Album PRIMARY KEY  ("Album_Id"),
    FOREIGN KEY (ArtistId) REFERENCES Artist (ArtistId) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE UNIQUE INDEX IPK_Album ON Album("Album_Id");
CREATE INDEX IFK_AlbumArtistId ON Album (ArtistId);


-- Employee определение

CREATE TABLE Employee
(
    EmployeeId INTEGER  NOT NULL,
    LastName VARCHAR(20)  NOT NULL,
    FirstName VARCHAR(20)  NOT NULL,
    Title VARCHAR(30),
    ReportsTo INTEGER,
    BirthDate timestamp,
    HireDate timestamp,
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60),
    CONSTRAINT PK_Employee PRIMARY KEY  (EmployeeId),
    FOREIGN KEY (ReportsTo) REFERENCES Employee (EmployeeId) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE UNIQUE INDEX IPK_Employee ON Employee(EmployeeId);
CREATE INDEX IFK_EmployeeReportsTo ON Employee (ReportsTo);


-- Track определение

CREATE TABLE Track
(
    TrackId INTEGER  NOT NULL,
    Name VARCHAR(200)  NOT NULL,
    AlbumId INTEGER,
    MediaTypeId INTEGER  NOT NULL,
    GenreId INTEGER,
    Composer VARCHAR(220),
    Milliseconds INTEGER  NOT NULL,
    Bytes INTEGER,
    UnitPrice NUMERIC(10,2)  NOT NULL,
    CONSTRAINT PK_Track PRIMARY KEY  (TrackId),
    FOREIGN KEY (AlbumId) REFERENCES Album ("Album_Id") 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (GenreId) REFERENCES Genre (GenreId) 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (MediaTypeId) REFERENCES MediaType (MediaTypeId) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE UNIQUE INDEX IPK_Track ON Track(TrackId);
CREATE INDEX IFK_TrackAlbumId ON Track (AlbumId);
CREATE INDEX IFK_TrackGenreId ON Track (GenreId);
CREATE INDEX IFK_TrackMediaTypeId ON Track (MediaTypeId);


-- Customer определение

CREATE TABLE Customer
(
    CustomerId INTEGER  NOT NULL,
    FirstName VARCHAR(40)  NOT NULL,
    LastName VARCHAR(20)  NOT NULL,
    Company VARCHAR(80),
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60)  NOT NULL,
    SupportRepId INTEGER,
    CONSTRAINT PK_Customer PRIMARY KEY  (CustomerId),
    FOREIGN KEY (SupportRepId) REFERENCES Employee (EmployeeId) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE UNIQUE INDEX IPK_Customer ON Customer(CustomerId);
CREATE INDEX IFK_CustomerSupportRepId ON Customer (SupportRepId);


-- Invoice определение

CREATE TABLE Invoice
(
    InvoiceId INTEGER  NOT NULL,
    CustomerId INTEGER  NOT NULL,
    InvoiceDate timestamp  NOT NULL,
    BillingAddress VARCHAR(70),
    BillingCity VARCHAR(40),
    BillingState VARCHAR(40),
    BillingCountry VARCHAR(40),
    BillingPostalCode VARCHAR(10),
    Total NUMERIC(10,2)  NOT NULL,
    CONSTRAINT PK_Invoice PRIMARY KEY  (InvoiceId),
    FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE UNIQUE INDEX IPK_Invoice ON Invoice(InvoiceId);
CREATE INDEX IFK_InvoiceCustomerId ON Invoice (CustomerId);


-- InvoiceLine определение

CREATE TABLE InvoiceLine
(
    InvoiceLineId INTEGER  NOT NULL,
    InvoiceId INTEGER  NOT NULL,
    TrackId INTEGER  NOT NULL,
    UnitPrice NUMERIC(10,2)  NOT NULL,
    Quantity INTEGER  NOT NULL,
    CONSTRAINT PK_InvoiceLine PRIMARY KEY  (InvoiceLineId),
    FOREIGN KEY (InvoiceId) REFERENCES Invoice (InvoiceId) 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (TrackId) REFERENCES Track (TrackId) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE UNIQUE INDEX IPK_InvoiceLine ON InvoiceLine(InvoiceLineId);
CREATE INDEX IFK_InvoiceLineInvoiceId ON InvoiceLine (InvoiceId);
CREATE INDEX IFK_InvoiceLineTrackId ON InvoiceLine (TrackId);


-- PlaylistTrack определение

CREATE TABLE PlaylistTrack
(
    PlaylistId INTEGER  NOT NULL,
    TrackId INTEGER  NOT NULL,
    CONSTRAINT PK_PlaylistTrack PRIMARY KEY  (PlaylistId, TrackId),
    FOREIGN KEY (PlaylistId) REFERENCES Playlist (PlaylistId) 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (TrackId) REFERENCES Track (TrackId) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE UNIQUE INDEX IPK_PlaylistTrack ON PlaylistTrack(PlaylistId, TrackId);
CREATE INDEX IFK_PlaylistTrackTrackId ON PlaylistTrack (TrackId);