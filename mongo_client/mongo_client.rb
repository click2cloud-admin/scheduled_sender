require "mongo"
require "json"
include Mongo

host = 'mongodb://detectoruser:sabetta14@ds033079.mongolab.com'
port = 33079

puts "Connecting to #{host}:#{port}"
db = MongoClient.new(host, port).db('detector')
coll = db.create_collection('detection')

# Insert five records
coll.insert('a' => 1)

det1 = stops.first

puts det1.to_s

client.close()