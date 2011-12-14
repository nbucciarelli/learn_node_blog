couchdb = require('couchdb')
client = couchdb.createClient(5984, '127.0.0.1', {})
db = client.db('blog')

designDoc = {
  _id: '_design/blog',

  language: 'javascript',

  views: {
    'posts_by_date': {
      map: ( (doc) ->
        if doc.type is 'post'
          emit(doc.postedAt, doc)
      ).toString()
    }
  }
}

db.saveDoc(designDoc).then( ( (resp) ->
  console.log 'Updated design doc!'
), (err) ->
  console.log('error updated design doc!' + require('util').inspect(err))
)