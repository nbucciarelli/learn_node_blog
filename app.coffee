couchdb = require('couchdb');
bogart = require "bogart"

app = bogart.router (get, post, update, destroy) ->
  client = couchdb.createClient( 5984, 'localhost')
  db = client.db('blog')
  viewEngine = bogart.viewEngine('mustache')

  get('/posts', (req) ->
    return db.view('blog', 'posts_by_date').then( (resp) ->
      console.log resp
      console.log 'HOLA'
      posts = resp.rows.map( (x) -> x.value)

      return viewEngine.respond('posts.html', {
        locals: {
          posts: posts,
          title: 'Blog Home'
        }
      })
    )
  )

  get('/posts/new', (req) ->
    viewEngine.respond('new-post.html', {
      locals: {
        title: "New Post"
      }
    })
  )

  post('/posts', (req) ->
    post = req.params
    post.type = 'post'

    return db.saveDoc(post).then( (resp) ->
      return bogart.redirect('/posts')
    )
  )

  get('/posts/:id', (req) ->
    return db.openDoc(req.params.id).then( (post) ->
      return viewEngine.respond('post.html', { locals: post })
    )
  )

  post('/posts/:id/comments', (req) ->
    comment = req.params

    return db.openDoc(req.params.id).then( (post) ->
      post.comments = post.comments || []
      post.comments.push(comment)

      return db.saveDoc(post).then( (resp) ->
        return bogart.redirect('/posts/' + req.params.id)
      )
    )
  )

app = bogart.middleware.ParseForm(app)
bogart.start(app)
