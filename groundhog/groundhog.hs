import Control.Monad.IO.Class (liftIO)
import Database.Groundhog.TH
import Database.Groundhog.Postgresql

data Customer = Customer {customerName :: String, phone :: String} deriving Show
data Product = Product {productName :: String, quantity :: Int, customer :: DefaultKey Customer}
deriving instance Show Product

mkPersist defaultCodegenConfig [groundhog|
- entity: Customer               # Name of the datatype
  constructors:
    - name: Customer
      fields:
        - name: customerName
          dbName: name           # Set column name to "name" instead of "customerName"
      uniques:
        - name: NameConstraint
          fields: [customerName] # Inline format of list
- entity: Product
|]

main :: IO ()
main = withPostgresqlConn "dbname=groundhog" $ runDbConn $ do
  runMigration defaultMigrationLogger $ do
    migrate (undefined :: Customer)
    migrate (undefined :: Product)

  johnKey <- insert $ Customer "John Doe" "0123456789"
  get johnKey >>= liftIO . print
  insert $ Product "Oranges" 3 johnKey
  insert $ Product "Apples" 5 johnKey

  janeKey <- insert $ Customer "Jane Doe" "9876543210"
  insert $ Product "Oranges" 4 janeKey

  productsForJohn <- select $ (CustomerField ==. johnKey) `orderBy` [Asc ProductNameField]
  liftIO $ putStrLn $ "Products for John: " ++ show productsForJohn
