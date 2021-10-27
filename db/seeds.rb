# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Hard-coded demo user
User.create(email: 'demo@example.com', password: 'demo')

# Configuration module missing from request
UploadStatus.create(slug: 'hold', name: 'On Hold')
UploadStatus.create(slug: 'proc', name: 'Processing')
UploadStatus.create(slug: 'fail', name: 'Failed')
UploadStatus.create(slug: 'fini', name: 'Finished')