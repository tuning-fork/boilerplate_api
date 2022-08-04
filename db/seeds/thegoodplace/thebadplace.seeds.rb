# frozen_string_literal: true

puts 'Seeding The Bad Place data...'

lorem_ipsum = <<-TEXT
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit
  tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa
  sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu
  sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus
  praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci
  amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at.
  Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris
  feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.
TEXT

shawn = User.create!({
                       first_name: 'Shawn',
                       last_name: '',
                       email: 'shawn@thebadplace.com',
                       password: SecureRandom.hex,
                       active: true
                     })
vicky = User.create!({
                       first_name: 'Vicky',
                       last_name: '',
                       email: 'vicky@thebadplace.com',
                       password: SecureRandom.hex,
                       active: true
                     })
trevor = User.create!({
                        first_name: 'Trevor',
                        last_name: '',
                        email: 'trevor@thebadplace.com',
                        password: SecureRandom.hex,
                        active: true
                      })
bad_janet = User.create!({
                           first_name: 'Bad Janet',
                           last_name: '',
                           email: 'badjanet@thebadplace.com',
                           password: SecureRandom.hex,
                           active: true
                         })

the_bad_place = Organization.create!({
                                       name: 'The Bad Place',
                                       users: [shawn, vicky, trevor, bad_janet],
                                       funding_orgs: [
                                         FundingOrg.new({ website: 'https://thebadplace.com', name: 'The Bad Place' })
                                       ],
                                       categories: [
                                         Category.new({ name: 'Evil' })
                                       ]
                                     })

category_evil = the_bad_place.categories[0]

the_bad_place.grants.create!([
                               {
                                 title: 'Bad Place Neighborhood Grant',
                                 funding_org: the_bad_place.funding_orgs[0],
                                 rfp_url: 'https://goodorbad.com/newneighborhoods',
                                 deadline: DateTime.now.next_week,
                                 submitted: true,
                                 successful: true,
                                 purpose: 'general funding',
                                 sections: [
                                   Section.new({
                                                 title: 'Overview of the Organization',
                                                 text: "<p>#{lorem_ipsum}</p>",
                                                 sort_order: 1,
                                                 wordcount: 219
                                               })
                                 ]
                               }
                             ])

the_bad_place.boilerplates.create!([
                                     {
                                       category: category_evil,
                                       title: 'Mission',
                                       text: "<p>#{lorem_ipsum}</p>",
                                       wordcount: 219
                                     }
                                   ])

puts 'The Bad Place data seeded!'
puts "\temail: #{shawn.email}"
puts "\tpassword: #{shawn.password}"
puts
