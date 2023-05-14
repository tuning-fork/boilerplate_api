# frozen_string_literal: true

puts 'Seeding Cypress Test data...'

andrew = User.create!({
                        first_name: 'Andrew',
                        last_name: 'Barnes',
                        email: 'abarnes@thecypresstree.org',
                        password: 'password',
                        active: true
                      })
breanna = User.create!({
                         first_name: 'Breanna',
                         last_name: 'Chin',
                         email: 'bchin@thecypresstree.org',
                         password: 'password',
                         active: true
                       })
carl = User.create!({
                      first_name: 'Carl',
                      last_name: 'Diaz',
                      email: 'cdiaz@thecypresstree.org',
                      password: 'password',
                      active: true
                    })
esther = User.create!({
                        first_name: 'Esther',
                        last_name: 'Morowitz',
                        email: 'emorowitz@thecypresstree.org',
                        password: 'password',
                        active: true
                      })
frank = User.create!({
                       first_name: 'Frank',
                       last_name: 'Vinh',
                       email: 'fvinh@thecypresstree.org', password: 'password',

                       active: true
                     })
giulia = User.create!({
                        first_name: 'Giulia',
                        last_name: 'Hillman',
                        email: 'ghillman@thecypresstree.org',
                        password: 'password',
                        active: true
                      })

the_cypress_tree = Organization.create!({
                                          name: 'The Cypress Tree',
                                          users: [andrew, breanna, carl, esther, frank, giulia],
                                          funding_orgs: [
                                            FundingOrg.new({ website: 'https://thehinokifoundation.org',
                                                             name: 'The Hinoki Foundation' }),
                                            FundingOrg.new({ website: 'https://thearlesfund.org',
                                                             name: 'The Arles Fund' })
                                          ],
                                          categories: [
                                            Category.new({ name: 'General Purpose' }),
                                            Category.new({ name: 'Financial Literacy' }),
                                            Category.new({ name: 'Gender Equality' }),
                                            Category.new({ name: 'Family Services' }),
                                            Category.new({ name: 'Cultural and Community Programming' }),
                                            Category.new({ name: 'Education' }),
                                            Category.new({ name: 'Legal Aid' })
                                          ]
                                        })

category_general_purpose = the_cypress_tree.categories[0]
category_family_services = the_cypress_tree.categories[3]
category_cultural_and_community_programming = the_cypress_tree.categories[4]

the_cypress_tree.grants.create!([
                                  {
                                    title: 'Cypress Tree Neighborhood Grant',
                                    funding_org: the_cypress_tree.funding_orgs[0],
                                    rfp_url: 'https://thehinokifoundation.org/neighborhood_seed_grants',
                                    deadline: DateTime.now.next_week,
                                    submitted: true,
                                    successful: true,
                                    purpose: 'general funding',
                                    sections: [
                                      Section.new({
                                                    **GrantFactory.section_info,
                                                    sort_order: 1
                                                  }),
                                      Section.new({
                                                    **GrantFactory.section_info,
                                                    sort_order: 2
                                                  }),
                                      Section.new({
                                                    **GrantFactory.section_info,
                                                    sort_order: 3
                                                  }),
                                      Section.new({
                                                    **GrantFactory.section_info,
                                                    sort_order: 4
                                                  }),
                                      Section.new({
                                                    **GrantFactory.section_info,
                                                    sort_order: 5
                                                  }),
                                      Section.new({
                                                    **GrantFactory.section_info,
                                                    sort_order: 6
                                                  })
                                      #   Section.new({
                                      #                 title: <<-TEXT,
                                      #                 How the Program/Project Directly Relates to Community Organizing, Civic
                                      #                 Engagement, and/or Healing in AAPI communities
                                      #                 TEXT
                                      #                 text: GrantFactory.section_text,
                                      #                 sort_order: 6,
                                      #                 wordcount: 45
                                      #               }),
                                      #   Section.new({
                                      #                 title: <<-TEXT,
                                      #                 What would success look like to the organization for this Program/Project
                                      #                 (please describe one or more indicators)?
                                      #                 TEXT
                                      #                 text: GrantFactory.section_text,
                                      #                 sort_order: 7,
                                      #                 wordcount: 45
                                      #               }),
                                    ]
                                  },
                                  {
                                    title: 'Hinoki Foundation Restorative Justice Initiative Grant',
                                    funding_org: the_cypress_tree.funding_orgs[0],
                                    rfp_url: 'https://thehinokifoundation.org/restorative_justice_initiative_rfp',
                                    deadline: DateTime.now.next_week,
                                    submitted: false,
                                    successful: false,
                                    purpose: 'civic education'
                                  },
                                  {
                                    title: 'Hinoki Foundation Housing Equality Neighborhood Renewal 2023',
                                    funding_org: the_cypress_tree.funding_orgs[0],
                                    rfp_url: 'https://thehinokifoundation.org/newneighborhoods',
                                    deadline: DateTime.now.next_week,
                                    submitted: false,
                                    successful: false,
                                    purpose: 'housing and neighborhood development'
                                  },
                                  {
                                    title: 'Hinoki Foundation GOTV Voter Education Grant',
                                    funding_org: the_cypress_tree.funding_orgs[0],
                                    rfp_url: 'https://thehinokifoundation.org/voter_education_request_proposals',
                                    deadline: DateTime.now.next_week,
                                    submitted: false,
                                    successful: false,
                                    purpose: 'Civic Education'
                                  },
                                  {
                                    title: 'Arles Fund Financial Literacy for Women Grant',
                                    funding_org: the_cypress_tree.funding_orgs[1],
                                    rfp_url: 'https://arles_fund/financial_education_rfp',
                                    deadline: DateTime.now.next_week,
                                    submitted: false,
                                    successful: false,
                                    purpose: 'financial education and gender equality'
                                  },
                                  {
                                    title: 'Arles Fund Small Business Seed Money Grant',
                                    funding_org: the_cypress_tree.funding_orgs[1],
                                    rfp_url: 'https://arles_fund/entrepreneur_seed_grants_2023',
                                    deadline: DateTime.now.next_week,
                                    submitted: false,
                                    successful: false,
                                    purpose: 'financial education and small business'
                                  }
                                ])

the_cypress_tree.boilerplates.create!([
                                        {
                                          category: category_general_purpose,
                                          **GrantFactory.section_info,
                                        },
                                        {
                                          category: category_general_purpose,
                                          **GrantFactory.section_info,
                                        },
                                        {
                                          category: category_cultural_and_community_programming,
                                          **GrantFactory.section_info,
                                        },
                                        {
                                          category: category_family_services,
                                          **GrantFactory.section_info,
                                        },
                                        {
                                          category: category_family_services,
                                          **GrantFactory.section_info,
                                        },
                                        {
                                          category: category_general_purpose,
                                          **GrantFactory.section_info,
                                        },
                                        {
                                          category: category_general_purpose,
                                          **GrantFactory.section_info,
                                        }
                                      ])

puts 'The Cypress Tree data seeded!'
puts "\temail: #{andrew.email}"
puts "\tpassword: #{andrew.password}"
puts
