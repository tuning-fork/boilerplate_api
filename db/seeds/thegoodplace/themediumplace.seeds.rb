# frozen_string_literal: true

print 'Seeding The Medium Place data...'

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

mindy = User.create!({ first_name: 'Mindy', email: 'mindy@themediumplace.com', password: SecureRandom.hex,
                       active: true })

the_medium_place = Organization.create!({
                                          name: 'The Medium Place',
                                          users: [mindy],
                                          funding_orgs: [
                                            FundingOrg.new({ website: 'https://themediumplace.com',
                                                             name: 'The Medium Place' })
                                          ],
                                          categories: [
                                            Category.new({ name: 'Grey area' })
                                          ]
                                        })

category_grey_area = the_medium_place.categories[0]

the_medium_place.grants.create!([
                                  {
                                    title: 'Medium Place Neighborhood Grant',
                                    funding_org: the_medium_place.funding_orgs[0],
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

the_medium_place.boilerplates.create!([
                                        {
                                          category: category_grey_area,
                                          title: 'Mission',
                                          text: "<p>#{lorem_ipsum}</p>",
                                          wordcount: 219
                                        }
                                      ])

puts 'The Medium Place data seeded!'
puts "\temail: #{mindy.email}"
puts "\tpassword: #{mindy.password}"
puts
