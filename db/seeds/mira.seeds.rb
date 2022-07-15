# frozen_string_literal: true

print 'Seeding MIRA data...'

mira = Organization.create!({
                              name: 'Middle Eastern Immigrant and Refugee Alliance (MIRA)',
                              users: [
                                User.new({
                                           first_name: 'Jess',
                                           last_name: 'White',
                                           email: 'jess@aol.com',
                                           password: SecureRandom.hex,
                                           active: true
                                         }),
                                User.new({
                                           first_name: 'Jemima',
                                           last_name: 'Jones',
                                           email: 'jj@aol.com',
                                           password: SecureRandom.hex,
                                           active: true
                                         }),
                                User.new({
                                           first_name: 'Mike',
                                           last_name: 'McFaddin',
                                           email: 'mikemcfaddin@email.com',
                                           password: SecureRandom.hex,
                                           active: true
                                         })
                              ],
                              funding_orgs: [
                                FundingOrg.new({
                                                 website: 'https://www.acf.hhs.gov/orr',
                                                 name: 'Office of Refugee Resettlement'
                                               }),
                                FundingOrg.new({
                                                 website: 'https://www.dhs.gov/',
                                                 name: 'Department of Homeland Security'
                                               }),
                                FundingOrg.new({
                                                 website: 'https://www.heartlandalliance.org/',
                                                 name: 'Heartland Alliance'
                                               }),
                                FundingOrg.new({
                                                 website: 'https://www.hadassah.org/',
                                                 name: 'Hadassah'
                                               }),
                                FundingOrg.new({
                                                 website: 'https://www.cct.org/about/partnerships_initiatives/asian-giving-circle/',
                                                 name: 'Asian Giving Circle'
                                               })
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

mira.grants.create!([
                      {
                        title: 'Letter of Interest: Asian Giving Circle Grants 2020',
                        funding_org: mira.funding_orgs[3],
                        rfp_url: 'https://www.cct.org/about/partnerships_initiatives/asian-giving-circle/',
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
                                      })
                        ],
                        reports: [
                          Report.new({
                                       title: 'Letter of Interest: Asian Giving Circle Grants 2020',
                                       deadline: DateTime.now.next_week,
                                       submitted: false,
                                       report_sections: [
                                         ReportSection.new({
                                                             title: 'Report Intro',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 1,
                                                             wordcount: 0
                                                           }),
                                         ReportSection.new({
                                                             title: 'Program Achievements',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 2,
                                                             wordcount: 0
                                                           })
                                       ]
                                     }),
                          Report.new({
                                       title: 'Report for Letter of Interest: Asian Giving Circle Grants 2020',
                                       deadline: DateTime.now.next_week,
                                       submitted: false
                                     }),
                          Report.new({
                                       title: 'Asian Giving Circle Grant Report',
                                       deadline: DateTime.now.next_week,
                                       submitted: true,
                                       report_sections: [
                                         ReportSection.new({
                                                             title: 'Test Section Layout',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 6,
                                                             wordcount: 146
                                                           })
                                       ]
                                     }),
                          Report.new({
                                       title: 'Report for Letter of Interest: Asian Giving Circle Grants 2020',
                                       deadline: DateTime.now.next_week,
                                       submitted: false,
                                       report_sections: [
                                         ReportSection.new({
                                                             title: 'Test Report section 1',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 1,
                                                             wordcount: 0
                                                           }),
                                         ReportSection.new({
                                                             title: 'Test Report Section 4',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 4,
                                                             wordcount: 0
                                                           }),
                                         ReportSection.new({
                                                             title: 'Test Report Section 7',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 7,
                                                             wordcount: 0
                                                           }),
                                         ReportSection.new({
                                                             title: 'Test Report Section 2',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 2,
                                                             wordcount: 0
                                                           })
                                       ]
                                     })
                        ]
                      },
                      {
                        title: 'Test UserFlow for Sections',
                        funding_org: mira.funding_orgs[2],
                        rfp_url: 'https://userflow.org',
                        deadline: DateTime.now.next_week,
                        submitted: false,
                        successful: false,
                        purpose: 'general funding',
                        sections: [
                          Section.new({
                                        title: 'Organization Overview',
                                        text: GrantFactory.section_text,
                                        sort_order: 1,
                                        wordcount: 364
                                      }),
                          Section.new({
                                        title: 'Test Section 2',
                                        text: GrantFactory.section_text,
                                        sort_order: 2,
                                        wordcount: 284
                                      })
                        ]
                      },
                      {
                        title: 'Test null values for sort order',
                        funding_org: mira.funding_orgs[0],
                        rfp_url: 'https://null.org',
                        deadline: DateTime.now.next_week,
                        submitted: false,
                        successful: false,
                        purpose: 'general funding',
                        sections: [
                          Section.new({
                                        title: 'Test Section 1',
                                        text: GrantFactory.section_text,
                                        sort_order: 1,
                                        wordcount: 239
                                      })
                        ]
                      },
                      {
                        title: 'Test Grant Sort Order Logic',
                        funding_org: mira.funding_orgs[0],
                        rfp_url: 'https://logic.org',
                        deadline: DateTime.now.next_week,
                        submitted: false,
                        successful: false,
                        purpose: 'general funding',
                        sections: [
                          Section.new({
                                        title: 'Test Section 3',
                                        text: GrantFactory.section_text,
                                        sort_order: 3,
                                        wordcount: 146
                                      }),
                          Section.new({
                                        title: 'Test Section 2',
                                        text: GrantFactory.section_text,
                                        sort_order: 2,
                                        wordcount: 211
                                      }),
                          Section.new({
                                        title: 'Test Section 4',
                                        text: GrantFactory.section_text,

                                        sort_order: 4,
                                        wordcount: 118
                                      }),
                          Section.new({
                                        title: 'Test Section 5',
                                        text: GrantFactory.section_text,
                                        sort_order: 5,
                                        wordcount: 118
                                      }),
                          Section.new({
                                        title: 'Test Section 6',
                                        text: GrantFactory.section_text,
                                        sort_order: 6,
                                        wordcount: 116
                                      }),
                          Section.new({
                                        title: 'Test Section 1',
                                        text: GrantFactory.section_text,
                                        sort_order: 1,
                                        wordcount: 127
                                      })
                        ],
                        reports: [
                          Report.new({
                                       title: 'Report for Test Grant Sort Order Logic',
                                       deadline: DateTime.now.next_week,
                                       submitted: false,
                                       report_sections: [
                                         ReportSection.new({
                                                             title: 'Test Report Section 3',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 3,
                                                             wordcount: 0
                                                           }),
                                         ReportSection.new({
                                                             title: 'Test Report Section 5',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 5,
                                                             wordcount: 0
                                                           }),
                                         ReportSection.new({
                                                             title: 'Test Report Section 2',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 2,
                                                             wordcount: 0
                                                           }),
                                         ReportSection.new({
                                                             title: 'Test Report Section 4',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 4,
                                                             wordcount: 51
                                                           }),
                                         ReportSection.new({
                                                             title: 'Test Section 2',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 2,
                                                             wordcount: 53
                                                           }),
                                         ReportSection.new({
                                                             title: 'Test Section 2',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 2,
                                                             wordcount: 53
                                                           }),
                                         ReportSection.new({
                                                             title: 'Test Section 1',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 1,
                                                             wordcount: 42
                                                           }),
                                         ReportSection.new({
                                                             title: 'Test Report Section 1',
                                                             text: GrantFactory.section_text,
                                                             sort_order: 1,
                                                             wordcount: 60
                                                           })
                                       ]
                                     })
                        ]
                      }
                    ])

mira.boilerplates.create!([
                            {
                              category: mira.categories[0],
                              title: 'Mission',
                              text: GrantFactory.section_text,
                              wordcount: 219
                            },
                            {
                              category: mira.categories[0],
                              title: 'What We Do',
                              text: GrantFactory.section_text,
                              wordcount: 146
                            },
                            {
                              category: mira.categories[4],
                              title: 'Community Engagement and Empowerment Programs',
                              text: GrantFactory.section_text,
                              wordcount: 53
                            },
                            {
                              category: mira.categories[3],
                              title: 'Case Management Program',
                              text: GrantFactory.section_text,
                              wordcount: 42
                            },
                            {
                              category: mira.categories[3],
                              title: 'Assistance for Families With Children',
                              text: GrantFactory.section_text,
                              wordcount: 51
                            },
                            {
                              category: mira.categories[0],
                              title: 'Adult Education Guidance Program',
                              text: GrantFactory.section_text,
                              wordcount: 44
                            },
                            {
                              category: mira.categories[0],
                              title: 'Immigration Legal Services',
                              text: GrantFactory.section_text,
                              wordcount: 39
                            }
                          ])

puts 'MIRA data seeded!'
puts "\temail: #{mira.users[0].email}"
puts "\tpassword: #{mira.users[0].password}"
puts
