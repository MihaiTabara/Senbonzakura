from sqlalchemy import Column, String, Integer, BigInteger
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

status_code = {'COMPLETED': 0,         # Where should this dict reallly go to make it easily importable
               'ABORTED': 1,
               'IN_PROGRESS': 2,
               'INVALID': 3, # Do we need this? We can use this to invalidate Cache entries
              }

class Partial(Base):
    """
    Defines the table called 'partial' in the database.
    Partial(int:id, str(65):identifier, int:status, char(1024):url, char(1024):location)

    PTQs (pertinent Question):

    - Should URLs be generated by a separate function? (Maybe.)
    - Should there be a 1to1 mapping b/w URLs and identifiers? (Yes.)
    - Should we remove the url field in the light of the above? Probably? (Done.)


    :id:                Inbuilt ID, auto incremented.
                        Auto incremented. (is it?)

    :start_timestamp:   Time at which request was recieved in seconds since epoch.

    :finish_timestamp:  Time at which request was completed in seconds since epoch.

    :identifier:        The actual string (hash combination for now) used to identify
                        the partial mar.
                        The SQL 'UNIQUE' constraint is enforced on this column.
                        Can not be empty.
                        Defaults to -1.

    :status:            Integer field used to keep track of status, see .status_code
                        for mapping from integers to meaningful statuses.
                        Can not be empty.
                        Defaults to -1.
    """
    __tablename__='partial'

    status_code = {'COMPLETED': 0,         # Where should this dict reallly go to make it easily importable
                    'ABORTED': 1,
                    'IN_PROGRESS': 2,
                    'INVALID': 3,
                    }

    # Define Columns
    id = Column(Integer, primary_key=True)
    start_timestamp = Column(BigInteger, default=-1, nullable=False)
    finish_timestamp = Column(BigInteger, default=-1)
    identifier = Column(String(500), nullable=False, unique=True) # Any arbitrary number over 257(128+1+128)
    status = Column(Integer, nullable=False, default=-1) # is it okay to use enum like stuff?

if __name__ == '__main__':
    print "Not meant to be run standalone"
