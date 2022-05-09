CREATE TABLE UTPLSQL_CALENDAR
   (	CLDR_ID NUMBER NOT NULL,
	CLDR_TITLE VARCHAR2(200 CHAR) NOT NULL,
	CLDR_DESCR VARCHAR2(500 CHAR),
	CLDR_START_DATE DATE,
	CLDR_END_DATE DATE,
	CLDR_EVENT_TYPE VARCHAR2(50 CHAR),
	CLDR_CREATE_USER VARCHAR2(255 CHAR) NOT NULL,
	CLDR_CREATE_DATE DATE NOT NULL,
	CLDR_CHANGE_USER VARCHAR2(255 CHAR) NOT NULL,
	CLDR_CHANGE_DATE DATE NOT NULL
   ) ;

COMMENT ON COLUMN UTPLSQL_CALENDAR.CLDR_ID IS 'Primary Key';
   COMMENT ON COLUMN UTPLSQL_CALENDAR.CLDR_TITLE IS 'Title of calendar entry';
   COMMENT ON COLUMN UTPLSQL_CALENDAR.CLDR_DESCR IS 'Description of calendar entry';
   COMMENT ON COLUMN UTPLSQL_CALENDAR.CLDR_START_DATE IS 'Start Date of calendar entry';
   COMMENT ON COLUMN UTPLSQL_CALENDAR.CLDR_END_DATE IS 'End Date of calendar entry';
   COMMENT ON COLUMN UTPLSQL_CALENDAR.CLDR_EVENT_TYPE IS 'Type of event (Schema name)';
   COMMENT ON TABLE UTPLSQL_CALENDAR  IS 'Table for calendar entries';


ALTER TABLE UTPLSQL_CALENDAR
  ADD CONSTRAINT CLDR_PK PRIMARY KEY (CLDR_ID);