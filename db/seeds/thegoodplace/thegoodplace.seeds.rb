print "Seeding The Good Place data..."

lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam."

chidi = User.create!({ first_name: "Chidi", last_name: "Anagonye", email: "canagonye@thegoodplace.com", password: "chidi", active: true })
tahani = User.create!({ first_name: "Tahani", last_name: "Al-Jamil", email: "taljamil@thegoodplace.com", password: "tahani", active: true })
jason = User.create!({ first_name: "Jason", last_name: "Mendoza", email: "jmendoza@thegoodplace.com", password: "jason", active: true })
elenor = User.create!({ first_name: "Elenor", last_name: "Shellstrop", email: "eshellstrop@thegoodplace.com", password: "elenor", active: true })
janet = User.create!({ first_name: "Janet", last_name: "", email: "janet@thegoodplace.com", password: "janet", active: true })
michael = User.create!({ first_name: "Michael", last_name: "", email: "michael@thegoodplace.com", password: "michael", active: true })

the_good_place = Organization.create!({
  name: "The Good Place",
  users: [chidi, tahani, jason, elenor, janet, michael],
  funding_orgs: [
    FundingOrg.new({ website: "https://thegoodplace.com", name: "The Good Place" }),
  ],
  categories: [
    Category.new({ name: "General Purpose" }),
    Category.new({ name: "Financial Literacy" }),
    Category.new({ name: "Gender Equality" }),
    Category.new({ name: "Family Services" }),
    Category.new({ name: "Cultural and Community Programming" }),
    Category.new({ name: "Education" }),
    Category.new({ name: "Citizenship and Naturalization" }),
    Category.new({ name: "Legal Aid" }),
  ],
})

category_general_purpose = the_good_place.categories[0]
category_family_services = the_good_place.categories[3]
category_cultural_and_community_programming = the_good_place.categories[4]

the_good_place.grants.create!([
  {
    title: "Good Place Neighborhood Grant",
    funding_org: the_good_place.funding_orgs[0],
    rfp_url: "https://goodorbad.com/newneighborhoods",
    deadline: DateTime.now.next_week,
    submitted: true,
    successful: true,
    purpose: "general funding",
    sections: [
      Section.new({ title: "Overview of the Organization", text: "<p><span style=\"color: rgb(102, 102, 102);\">MIRA, the Middle Eastern Immigrant and Refugee Alliance, was originally founded in 2009 as the Iraqi Mutual Aid Society by newly-arrived Iraqi refugees, in response to the challenges they faced while adapting to their new lives in the United States. MIRA forges connections between Middle Eastern and American society, and facilitates the preservation and exchange of Middle Eastern culture. Our goal is to foster well-being and self-sufficiency for resettled refugees and immigrants from across the Middle East and beyond, and to use our multilingual and multicultural expertise to tailor our services to the unique needs of our clients— whom we serve regardless of gender, religion, ethnicity, nationality, or family size.​Our staff and volunteers speak Arabic, Assyrian, Kurdish, and Farsi. Almost all arrived to the United States as refugees themselves. These linguistic, cultural, and experiential connections with our Middle Eastern clients distinguish MIRA; there is no comparable organization serving this population in the Chicago area. Over the past ten years since the founding, MIRA has expanded to offer services to refugees, immigrants, asylees, and Special Immigrant Visa holders from all over the world, but we are proud to say that this founding spirit has only grown stronger— MIRA continues to be community-driven, refugee-powered, and closely attuned to the needs and voices of the population we serve.</span></p>", sort_order: 1, wordcount: 219 }),
      Section.new({ title: "Program Goals", text: "<p>At the beginning of 2020, a consultation among MIRA Board, Staff, and Community Members identified three primary areas for growth: Women and Children’s Empowerment, Legal Clinic Services, and Mental Health Promotion.&nbsp;While these are existing program areas, the goal for the organization is to align staff skills and training, funding resources, and community engagement to establish MIRA as the leader for these programs for Middle Eastern immigrants and refugees on the north side of Chicago.</p>", sort_order: 2, wordcount: 74 }),
      Section.new({ title: "Programs", text: "<p>MIRA has provided the following services to over 600 clients and their families, with a total impact of about 1000 immigrants and refugees, in the last fiscal year (July 18 – June 19):</p><p><br></p><p>Community Engagement and Empowerment Programs:&nbsp;MIRA provides the resources and structure for Middle Eastern refugees to support one another and welcome new arrivals with what they need to succeed through support groups, community events, and bridge-building activities with the wider Chicago community. In&nbsp;FY18-19, 189 MIRA Community Empowerment Clients participated in 645 Empowerment Activities.</p><p><br></p><p>Case Management Program:&nbsp;MIRA helps Middle Eastern refugees and immigrants access the services they need, including public benefits, healthcare, and referrals to partner organizations or other agencies. In FY18-19 MIRA provided 341 Case Management Clients with 677 Case Management Case Activities.</p><p><br></p><p>Assistance for Families with Children: MIRA offers a variety of support for families with children, including pre-school and school enrollment, working with teachers and administration, support for struggling students, parental support, and monthly Parents’ Groups.&nbsp;In FY18-19 MIRA provided 120 Child and Family Services Clients with 480 Child and Family Services Case Activities.</p><p><br></p><p>Adult Education Guidance Program:&nbsp;MIRA works with clients to address their educational needs, including assistance applying for college credit and training programs, evaluating educational credentials, and applying for financial aid. In FY18-19 MIRA provided 97 Adult Education Clients with 152 Adult Education Case Activities.</p><p><br></p><p>Immigration Legal Services:&nbsp;The MIRA Immigration Legal Services Program assists with naturalization petitions and green card applications.&nbsp;There is no fee for the service, although application fees still apply. In FY18-19 MIRA assisted 240 clients with immigration legal services.</p>", sort_order: 3, wordcount: 252 }),
      Section.new({ title: "Overview of the Proposed Program/Project", text: "<p>MIRA proposes the continuation of the Mental Health First Aid program funded through the Asian Giving Circle for 2019-20.&nbsp;In light of the current pandemic, isolation, and deaths, MIRA projects that the need for increased Mental Health awareness and education in the Middle Eastern immigrant and refugee community will continue to expand and it is vital to train more members of the community to provide Mental Health First Aid in the coming months.&nbsp;The goal of the proposed program is to educate and empower area community members to identify mental health issues in the community and provide referrals and resources to support refugee and immigrant community members in seeking mental health services. Mental Health First Aid is an evidence-based CDC-reviewed public education program that introduces participants to risk factors and warning signs of mental illnesses, builds understanding of their impact, and overviews common supports. This training course uses role-playing and simulations to demonstrate how to offer initial help in a mental health crisis and connect persons to the appropriate professional, peer, social, and self-help care. The program also teaches the common risk factors and warning signs of specific types of illnesses, like anxiety, depression, substance use, bipolar disorder, eating disorders, and schizophrenia. &nbsp;</p>", sort_order: 4, wordcount: 201 }),
      Section.new({ title: "Leaders of the Program/Project: ", text: "<p>Ekram Hanna, MIRA Community Engagement Manager, Certified Mental Health First Aid Trainer</p>", sort_order: 5, wordcount: 12 }),
      Section.new({ title: "How the Program/Project Directly Relates to Community Organizing, Civic Engagement, and/or Healing in AAPI communities", text: "<p>With the introduction of a new shorter (4 hour) course, MIRA staff can engage more community members directly in training and raising awareness of mental health issues at a time when isolation, depression, and catastrophic losses will be affecting the entire country, and have the potential to devastate the newly developing Middle Eastern immigrant and refugee community on the north side of Chicago.</p>", sort_order: 6, wordcount: 63 }),
      Section.new({ title: "What would success look like to the organization for this Program/Project (please describe one or more indicators)? ", text: "<p>We will measure the success of these programs in terms of the volume and quality of the services we provide to our clients. We will provide this specialized training program at least four times over the course of the next year, in conjunction with a national training program that provides pre- and post-training testing on issues related to mental health awareness and treatment. As a result of this enhanced level of awareness among community members, we anticipate a higher level of referrals to mental health services ranging from counseling to substance-abuse recovery support to intimate partner violence services. We also anticipate an increased openness regarding these topics among our clients, including in their discussions with staff. Since we are an organization that emphasizes client-led coaching and peer support, we also anticipate more effective dialogues between staff members and clients seeking services at MIRA. We will also use our experience with this training to partner with other local agencies and address mental health issues collaboratively.</p>", sort_order: 7, wordcount: 164 }),
      Section.new({ title: "Organization Overview", text: "<p><span style=\"color: rgb(102, 102, 102);\">MIRA, the Middle Eastern Immigrant and Refugee Alliance, was originally founded in 2009 as the Iraqi Mutual Aid Society by newly-arrived Iraqi refugees, in response to the challenges they faced while adapting to their new lives in the United States. MIRA forges connections between Middle Eastern and American society, and facilitates the preservation and exchange of Middle Eastern culture. Our goal is to foster well-being and self-sufficiency for resettled refugees and immigrants from across the Middle East and beyond, and to use our multilingual and multicultural expertise to tailor our services to the unique needs of our clients— whom we serve regardless of gender, religion, ethnicity, nationality, or family size.​Our staff and volunteers speak Arabic, Assyrian, Kurdish, and Farsi. Almost all arrived to the United States as refugees themselves. These linguistic, cultural, and experiential connections with our Middle Eastern clients distinguish MIRA; there is no comparable organization serving this population in the Chicago area. Over the past ten years since the founding, MIRA has expanded to offer services to refugees, immigrants, asylees, and Special Immigrant Visa holders from all over the world, but we are proud to say that this founding spirit has only grown stronger— MIRA continues to be community-driven, refugee-powered, and closely attuned to the needs and voices of the population we serve.</span></p><p><span style=\"color: rgb(102, 102, 102);\">The Middle Eastern Immigrant and Refugee Alliance (MIRA) fosters the well-being and self-sufficiency of Middle Eastern refugees, immigrants, and asylees in Chicago. MIRA serves as a first point of contact for a diverse client population from around the world, offering culturally competent services for those from the Middle East and Islamic cultures. The immigrants and refugees we serve arrive in the United States facing numerous barriers to full integration into society. Our mandate is to provide them with the tools they need to build successful, stable, enriching lives in their new homes. The primary needs of the community relate to navigating American systems for safety net services, employment, and education; integrating into American society while maintaining distinct cultural and community support and traditions; and undertaking the legal processes necessary for continued life in the United States without undue financial burdens or hardships.</span></p>", sort_order: 1, wordcount: 364 }),
    ],
  },
  {
    title: "Bad Janet Restorative Justice Initiative Grant",
    funding_org: the_good_place.funding_orgs[0],
    rfp_url: "https://goodorbad.com/newneighborhoods",
    deadline: DateTime.now.next_week,
    submitted: false,
    successful: false,
    purpose: "general funding",
  },
  {
    title: "Jason Mendoza Guacamole Grant",
    funding_org: the_good_place.funding_orgs[0],
    rfp_url: "https://goodorbad.com/newneighborhoods",
    deadline: DateTime.now.next_week,
    submitted: false,
    successful: false,
    purpose: "general funding",
  },
  {
    title: "Party Shrimp Platter Party Grant",
    funding_org: the_good_place.funding_orgs[0],
    rfp_url: "https://goodorbad.com/newneighborhoods",
    deadline: DateTime.now.next_week,
    submitted: false,
    successful: false,
    purpose: "general funding",
  },
  {
    title: "Cocaine Cannonball Run on Blu-Ray Grant ",
    funding_org: the_good_place.funding_orgs[0],
    rfp_url: "https://goodorbad.com/newneighborhoods",
    deadline: DateTime.now.next_week,
    submitted: false,
    successful: false,
    purpose: "general funding",
  },
  {
    title: "Derek Derek Derek Derek Derek Derek Derek...",
    funding_org: the_good_place.funding_orgs[0],
    rfp_url: "https://goodorbad.com/newneighborhoods",
    deadline: DateTime.now.next_week,
    submitted: false,
    successful: false,
    purpose: "general funding",
  },
])

the_good_place.boilerplates.create!([
  { category: category_general_purpose, title: "Mission", text: "<p><span style=\"color: rgb(102, 102, 102);\">MIRA, the Middle Eastern Immigrant and Refugee Alliance, was originally founded in 2009 as the Iraqi Mutual Aid Society by newly-arrived Iraqi refugees, in response to the challenges they faced while adapting to their new lives in the United States. MIRA forges connections between Middle Eastern and American society, and facilitates the preservation and exchange of Middle Eastern culture. Our goal is to foster well-being and self-sufficiency for resettled refugees and immigrants from across the Middle East and beyond, and to use our multilingual and multicultural expertise to tailor our services to the unique needs of our clients— whom we serve regardless of gender, religion, ethnicity, nationality, or family size.​Our staff and volunteers speak Arabic, Assyrian, Kurdish, and Farsi. Almost all arrived to the United States as refugees themselves. These linguistic, cultural, and experiential connections with our Middle Eastern clients distinguish MIRA; there is no comparable organization serving this population in the Chicago area. Over the past ten years since the founding, MIRA has expanded to offer services to refugees, immigrants, asylees, and Special Immigrant Visa holders from all over the world, but we are proud to say that this founding spirit has only grown stronger— MIRA continues to be community-driven, refugee-powered, and closely attuned to the needs and voices of the population we serve.</span></p>", wordcount: 219 },
  { category: category_general_purpose, title: "What We Do", text: "<p><span style=\"color: rgb(102, 102, 102);\">The Middle Eastern Immigrant and Refugee Alliance (MIRA) fosters the well-being and self-sufficiency of Middle Eastern refugees, immigrants, and asylees in Chicago. MIRA serves as a first point of contact for a diverse client population from around the world, offering culturally competent services for those from the Middle East and Islamic cultures. The immigrants and refugees we serve arrive in the United States facing numerous barriers to full integration into society. Our mandate is to provide them with the tools they need to build successful, stable, enriching lives in their new homes. The primary needs of the community relate to navigating American systems for safety net services, employment, and education; integrating into American society while maintaining distinct cultural and community support and traditions; and undertaking the legal processes necessary for continued life in the United States without undue financial burdens or hardships.</span></p>", wordcount: 146 },
  { category: category_cultural_and_community_programming, title: "Community Engagement and Empowerment Programs", text: "<p><span style=\"color: rgb(102, 102, 102);\">MIRA provides the resources and structure for Middle Eastern refugees to support one another and welcome new arrivals with what they need to succeed through support groups, community events, and bridge-building activities with the wider Chicago community. In FY18-19 189 MIRA Community Empowerment Clients participated in 645 Empowerment Activities.</span></p>", wordcount: 53 },
  { category: category_family_services, title: "Case Management Program", text: "<p><span style=\"color: rgb(102, 102, 102);\">MIRA helps Middle Eastern refugees and immigrants access the services they need, including public benefits, healthcare, and referrals to partner organizations or other agencies. In FY18-19 MIRA provided 341 Case Management Clients with 677 Case Management Case Activities.</span></p>", wordcount: 42 },
  { category: category_family_services, title: "Assistance for Families With Children", text: "<p><span style=\"color: rgb(102, 102, 102);\">MIRA offers a variety of support for families with children, including pre-school and school enrollment, working with teachers and administration, support for struggling students, parental support, and monthly Parents’ Groups.&nbsp;In FY18-19 MIRA provided 120 Child and Family Services Clients with 480 Child and Family Services Case Activities.</span></p>", wordcount: 51 },
  { category: category_general_purpose, title: "Adult Education Guidance Program", text: "<p><span style=\"color: rgb(102, 102, 102);\">MIRA works with clients to address their educational needs, including assistance applying for college credit and training programs, evaluating educational credentials, and applying for financial aid. In FY18-19 MIRA provided 97 Adult Education Clients with 152 Adult Education Case Activities.</span></p>", wordcount: 44 },
  { category: category_general_purpose, title: "Immigration Legal Services", text: "<p><span style=\"color: rgb(102, 102, 102);\">The MIRA Immigration Legal Services Program assists with naturalization petitions and green card applications.&nbsp;There is no fee for the service, although application fees still apply. In FY18-19 MIRA assisted 240 clients with immigration legal services.</span></p>", wordcount: 39 },
])

puts "The Good Place data seeded!"
puts "\temail: #{chidi.email}"
puts "\tpassword: #{chidi.password}"
puts
