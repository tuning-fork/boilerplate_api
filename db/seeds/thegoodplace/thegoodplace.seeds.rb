# frozen_string_literal: true

puts 'Seeding The Good Place data...'

chidi = User.create!({
                       first_name: 'Chidi',
                       last_name: 'Anagonye',
                       email: 'canagonye@thegoodplace.com',
                       password: SecureRandom.hex,
                       active: true
                     })
tahani = User.create!({
                        first_name: 'Tahani',
                        last_name: 'Al-Jamil',
                        email: 'taljamil@thegoodplace.com',
                        password: SecureRandom.hex,
                        active: true
                      })
jason = User.create!({
                       first_name: 'Jason',
                       last_name: 'Mendoza',
                       email: 'jmendoza@thegoodplace.com',
                       password: SecureRandom.hex,
                       active: true
                     })
elenor = User.create!({
                        first_name: 'Elenor',
                        last_name: 'Shellstrop',
                        email: 'eshellstrop@thegoodplace.com',
                        password: SecureRandom.hex,
                        active: true
                      })
janet = User.create!({
                       first_name: 'Janet',
                       last_name: '',
                       email: 'janet@thegoodplace.com', password: SecureRandom.hex,

                       active: true
                     })
michael = User.create!({
                         first_name: 'Michael',
                         last_name: '',
                         email: 'michael@thegoodplace.com',
                         password: SecureRandom.hex,
                         active: true
                       })

the_good_place = Organization.create!({
                                        name: 'The Good Place',
                                        users: [chidi, tahani, jason, elenor, janet, michael],
                                        funding_orgs: [
                                          FundingOrg.new({ website: 'https://thegoodplace.com',
                                                           name: 'The Good Place' })
                                        ],
                                        categories: [
                                          Category.new({ name: 'General Purpose' }),
                                          Category.new({ name: 'Financial Literacy' }),
                                          Category.new({ name: 'Gender Equality' }),
                                          Category.new({ name: 'Family Services' }),
                                          Category.new({ name: 'Cultural and Community Programming' }),
                                          Category.new({ name: 'Education' }),
                                          Category.new({ name: 'Citizenship and Naturalization' }),
                                          Category.new({ name: 'Legal Aid' })
                                        ]
                                      })

category_general_purpose = the_good_place.categories[0]
category_family_services = the_good_place.categories[3]
category_cultural_and_community_programming = the_good_place.categories[4]

the_good_place.grants.create!([
                                {
                                  title: 'Good Place Neighborhood Grant',
                                  funding_org: the_good_place.funding_orgs[0],
                                  rfp_url: 'https://goodorbad.com/newneighborhoods',
                                  deadline: DateTime.now.next_week,
                                  submitted: true,
                                  successful: true,
                                  purpose: 'general funding',
                                  sections: [
                                    Section.new({
                                                  title: 'Overview of the Organization',
                                                  text: GrantFactory.section_text,
                                                  sort_order: 1,
                                                  wordcount: 219
                                                }),
                                    Section.new({
                                                  title: 'Program Goals',
                                                  text: GrantFactory.section_text,
                                                  sort_order: 2,
                                                  wordcount: 74
                                                }),
                                    Section.new({
                                                  title: 'Programs',
                                                  text: GrantFactory.section_text,
                                                  sort_order: 3,
                                                  wordcount: 252
                                                }),
                                    Section.new({
                                                  title: 'Overview of the Proposed Program/Project',
                                                  text: GrantFactory.section_text,
                                                  sort_order: 4,
                                                  wordcount: 201
                                                }),
                                    Section.new({
                                                  title: 'Leaders of the Program/Project: ',
                                                  text: GrantFactory.section_text,
                                                  sort_order: 5,
                                                  wordcount: 12
                                                }),
                                    Section.new({
                                                  title: <<-TEXT,
                                                    How the Program/Project Directly Relates to Community Organizing, Civic
                                                    Engagement, and/or Healing in AAPI communities
                                                  TEXT
                                                  text: GrantFactory.section_text,
                                                  sort_order: 6,
                                                  wordcount: 63
                                                }),
                                    Section.new({
                                                  title: <<-TEXT,
                                                    What would success look like to the organization for this Program/Project
                                                    (please describe one or more indicators)?
                                                  TEXT
                                                  text: GrantFactory.section_text,
                                                  sort_order: 7,
                                                  wordcount: 164
                                                }),
                                    Section.new({
                                                  title: 'Organization Overview',
                                                  text: GrantFactory.section_text,
                                                  sort_order: 1,
                                                  wordcount: 364
                                                })
                                  ]
                                },
                                {
                                  title: 'Bad Janet Restorative Justice Initiative Grant',
                                  funding_org: the_good_place.funding_orgs[0],
                                  rfp_url: 'https://goodorbad.com/newneighborhoods',
                                  deadline: DateTime.now.next_week,
                                  submitted: false,
                                  successful: false,
                                  purpose: 'general funding'
                                },
                                {
                                  title: 'Jason Mendoza Guacamole Grant',
                                  funding_org: the_good_place.funding_orgs[0],
                                  rfp_url: 'https://goodorbad.com/newneighborhoods',
                                  deadline: DateTime.now.next_week,
                                  submitted: false,
                                  successful: false,
                                  purpose: 'general funding'
                                },
                                {
                                  title: 'Party Shrimp Platter Party Grant',
                                  funding_org: the_good_place.funding_orgs[0],
                                  rfp_url: 'https://goodorbad.com/newneighborhoods',
                                  deadline: DateTime.now.next_week,
                                  submitted: false,
                                  successful: false,
                                  purpose: 'general funding'
                                },
                                {
                                  title: 'Cocaine Cannonball Run on Blu-Ray Grant ',
                                  funding_org: the_good_place.funding_orgs[0],
                                  rfp_url: 'https://goodorbad.com/newneighborhoods',
                                  deadline: DateTime.now.next_week,
                                  submitted: false,
                                  successful: false,
                                  purpose: 'general funding'
                                },
                                {
                                  title: 'Derek Derek Derek Derek Derek Derek Derek...',
                                  funding_org: the_good_place.funding_orgs[0],
                                  rfp_url: 'https://goodorbad.com/newneighborhoods',
                                  deadline: DateTime.now.next_week,
                                  submitted: false,
                                  successful: false,
                                  purpose: 'general funding'
                                }
                              ])

the_good_place.boilerplates.create!([
                                      {
                                        category: category_general_purpose,
                                        title: 'Mission',
                                        text: GrantFactory.section_text,
                                        wordcount: 219
                                      },
                                      {
                                        category: category_general_purpose,
                                        title: 'What We Do',
                                        text: GrantFactory.section_text,
                                        wordcount: 146
                                      },
                                      {
                                        category: category_cultural_and_community_programming,
                                        title: 'Community Engagement and Empowerment Programs',
                                        text: GrantFactory.section_text,
                                        wordcount: 53
                                      },
                                      {
                                        category: category_family_services,
                                        title: 'Case Management Program',
                                        text: GrantFactory.section_text,
                                        wordcount: 42
                                      },
                                      {
                                        category: category_family_services,
                                        title: 'Assistance for Families With Children',
                                        text: GrantFactory.section_text,
                                        wordcount: 51
                                      },
                                      {
                                        category: category_general_purpose,
                                        title: 'Adult Education Guidance Program',
                                        text: GrantFactory.section_text,
                                        wordcount: 44
                                      },
                                      {
                                        category: category_general_purpose,
                                        title: 'Immigration Legal Services',
                                        text: GrantFactory.section_text,
                                        wordcount: 3
                                      }
                                    ])

puts 'The Good Place data seeded!'
puts "\temail: #{chidi.email}"
puts "\tpassword: #{chidi.password}"
puts
