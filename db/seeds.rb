# Bio.create(organization_id: 1, first_name: "Test Bio 1", last_name: "Test Bio 1", text: "Test Bio 1")
# Bio.create(organization_id: 1, first_name: "Test Bio 2", last_name: "Test Bio 2", text: "Test Bio 2")
# Bio.create(organization_id: 1, first_name: "Test Bio 3", last_name: "Test Bio 3", text: "Test Bio 3")
# Bio.create(organization_id: 1, first_name: "Test Bio 4", last_name: "Test Bio 4", text: "Test Bio 4")
# Bio.create(organization_id: 1, first_name: "Test Bio 5", last_name: "Test Bio 5", text: "Test Bio 5")
# Bio.create(organization_id: 1, first_name: "Test Bio 6", last_name: "Test Bio 6", text: "Test Bio 6")

# Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 1", text: "Test Boilerplate 1", wordcount: 250)
# Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 2", text: "Test Boilerplate 2", wordcount: 250)
# Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 3", text: "Test Boilerplate 3", wordcount: 250)
# Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 4", text: "Test Boilerplate 4", wordcount: 250)
# Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 5", text: "Test Boilerplate 5", wordcount: 250)
# Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 6", text: "Test Boilerplate 6", wordcount: 250)

# Category.create(organization_id: 1, name: "Test Category 1")
# Category.create(organization_id: 1, name: "Test Category 2")
# Category.create(organization_id: 1, name: "Test Category 3")
# Category.create(organization_id: 1, name: "Test Category 4")
# Category.create(organization_id: 1, name: "Test Category 5")
# Category.create(organization_id: 1, name: "Test Category 6")

# FundingOrg.create(website: "Test Funding Org 1", name: "Test Funding Org 1", organization_id: 1)
# FundingOrg.create(website: "Test Funding Org 2", name: "Test Funding Org 2", organization_id: 1)
# FundingOrg.create(website: "Test Funding Org 3", name: "Test Funding Org 3", organization_id: 1)
# FundingOrg.create(website: "Test Funding Org 4", name: "Test Funding Org 4", organization_id: 1)
# FundingOrg.create(website: "Test Funding Org 5", name: "Test Funding Org 5", organization_id: 1)
# FundingOrg.create(website: "Test Funding Org 6", name: "Test Funding Org 6", organization_id: 1)

# Grant.create(organization_id: 1, title: "Test Grant 1", funding_org_id: 1, rfp_url: "Test Grant 1", deadline: "Test Grant 1", submitted: true, successful: false)
# Grant.create(organization_id: 1, title: "Test Grant 2", funding_org_id: 1, rfp_url: "Test Grant 2", deadline: "Test Grant 2", submitted: true, successful: false)
# Grant.create(organization_id: 1, title: "Test Grant 3", funding_org_id: 1, rfp_url: "Test Grant 3", deadline: "Test Grant 3", submitted: true, successful: false)
# Grant.create(organization_id: 1, title: "Test Grant 4", funding_org_id: 1, rfp_url: "Test Grant 4", deadline: "Test Grant 4", submitted: true, successful: false)
# Grant.create(organization_id: 1, title: "Test Grant 5", funding_org_id: 1, rfp_url: "Test Grant 5", deadline: "Test Grant 5", submitted: true, successful: false)
# Grant.create(organization_id: 1, title: "Test Grant 6", funding_org_id: 1, rfp_url: "Test Grant 6", deadline: "Test Grant 6", submitted: true, successful: false)

# Organization.create(name: "Test Organization 1")
# Organization.create(name: "Test Organization 2")
# Organization.create(name: "Test Organization 3")
# Organization.create(name: "Test Organization 4")
# Organization.create(name: "Test Organization 5")
# Organization.create(name: "Test Organization 6")

# Report.create(grant_id: 1, title: "Test Report 1", deadline: "0000-00-00", submitted: true)
# Report.create(grant_id: 1, title: "Test Report 2", deadline: "0000-00-00", submitted: true)
# Report.create(grant_id: 1, title: "Test Report 3", deadline: "0000-00-00", submitted: true)
# Report.create(grant_id: 1, title: "Test Report 4", deadline: "0000-00-00", submitted: true)
# Report.create(grant_id: 1, title: "Test Report 5", deadline: "0000-00-00", submitted: true)
# Report.create(grant_id: 1, title: "Test Report 6", deadline: "0000-00-00", submitted: true)

# Section.create(grant_id: 1, title: "Test Section 1", text: "Test Section 1", sort_order: 1, boilerplate_id: 1)
# Section.create(grant_id: 1, title: "Test Section 2", text: "Test Section 2", sort_order: 1, boilerplate_id: 1)
# Section.create(grant_id: 1, title: "Test Section 3", text: "Test Section 3", sort_order: 1, boilerplate_id: 1)
# Section.create(grant_id: 1, title: "Test Section 4", text: "Test Section 4", sort_order: 1, boilerplate_id: 1)
# Section.create(grant_id: 1, title: "Test Section 5", text: "Test Section 5", sort_order: 1, boilerplate_id: 1)
# Section.create(grant_id: 1, title: "Test Section 6", text: "Test Section 6", sort_order: 1, boilerplate_id: 1)

# User.create(first_name: "Test User 1", last_name: "Test User 1", email: "Test User 1", password: "password", password_confirmation: "password")
# User.create(first_name: "Test User 2", last_name: "Test User 2", email: "Test User 2", password: "password", password_confirmation: "password")
# User.create(first_name: "Test User 3", last_name: "Test User 3", email: "Test User 3", password: "password", password_confirmation: "password")
# User.create(first_name: "Test User 4", last_name: "Test User 4", email: "Test User 4", password: "password", password_confirmation: "password")
# User.create(first_name: "Test User 5", last_name: "Test User 5", email: "Test User 5", password: "password", password_confirmation: "password")
# User.create(first_name: "Test User 6", last_name: "Test User 6", email: "Test User 6", password: "password", password_confirmation: "password")

# ReportSection.create(report_id: 1, title: "Test Report Section 1", text: "Test Report Section 1", sort_order: 1)
# ReportSection.create(report_id: 1, title: "Test Report Section 2", text: "Test Report Section 2", sort_order: 2)
# ReportSection.create(report_id: 1, title: "Test Report Section 3", text: "Test Report Section 3", sort_order: 3)
# ReportSection.create(report_id: 2, title: "Test Report Section 4", text: "Test Report Section 4", sort_order: 1)
# ReportSection.create(report_id: 2, title: "Test Report Section 5", text: "Test Report Section 5", sort_order: 1)
# ReportSection.create(report_id: 2, title: "Test Report Section 6", text: "Test Report Section 6", sort_order: 1)

# create_table "grants", force: :cascade do |t|
#     t.integer "organization_id"
#     t.string "title"
#     t.integer "funding_org_id"
#     t.string "rfp_url"
#     t.datetime "deadline"
#     t.boolean "submitted"
#     t.boolean "successful"
#     t.datetime "created_at", precision: 6, null: false
#     t.datetime "updated_at", precision: 6, null: false
#     t.string "purpose"
#   end

Grant.create(organization_id: 2, title: "Letter of Interest: Asian Giving Circle Grants 2020", rfp_url: "asiangivingcirclegrant.org/rfp2020", deadline: "01-01-2020", submitted: false, successful: false, purpose: "Mental Health First Aid")

Section.create(grant_id: 1, title: "Overview of the Organization", text: "The Middle Eastern Immigrant and Refugee Alliance (MIRA), formerly the Iraqi Mutual Aid Society (IMAS), fosters the well-being and self-sufficiency of Middle Eastern refugees, immigrants, and asylees in Chicago. MIRA serves as a first point of contact for a diverse client population from around the world, offering culturally competent services for those from the Middle East and Islamic cultures. The immigrants and refugees we serve arrive in the United States facing numerous barriers to full integration into society. Our mandate is to provide them with the tools they need to build successful, stable, enriching lives in their new homes. The primary needs of the community relate to navigating American systems for safety net services, employment, and education; integrating into American society while maintaining distinct cultural and community support and traditions; and undertaking the legal processes necessary for continued life in the United States without undue financial burdens or hardships. At the beginning of 2020, a consultation among MIRA Board, Staff, and Community Members identified three primary areas for growth: Women and Children’s Empowerment, Legal Clinic Services, and Mental Health Promotion.  While these are existing program areas, the goal for the organization is to align staff skills and training, funding resources, and community engagement to establish MIRA as the leader for these programs for Middle Eastern immigrants and refugees on the north side of Chicago.", sort_order: 1)

Section.create(grant_id: 1, title: "MIRA Programs", text: "MIRA has provided the following services to over 600 clients and their families, with a total impact of about 1000 immigrants and refugees, in the last fiscal year (July 18 – June 19): Community Engagement and Empowerment Programs:  MIRA provides the resources and structure for Middle Eastern refugees to support one another and welcome new arrivals with what they need to succeed through support groups, community events, and bridge-building activities with the wider Chicago community. FY18-19, 189 MIRA Community Empowerment Clients participated in 645 Empowerment Activities. Case Management Program:  MIRA helps Middle Eastern refugees and immigrants access the services they need, including public benefits, healthcare, and referrals to partner organizations or other agencies. In FY18-19 MIRA provided 341 Case Management Clients with 677 Case Management Case Activities. Assistance for Families with Children: MIRA offers a variety of support for families with children, including pre-school and school enrollment, working with teachers and administration, support for struggling students, parental support, and monthly Parents’ Groups.  In FY18-19 MIRA provided 120 Child and Family Services Clients with 480 Child and Family Services Case Activities. Adult Education Guidance Program:  MIRA works with clients to address their educational needs, including assistance applying for college credit and training programs, evaluating educational credentials, and applying for financial aid. In FY18-19 MIRA provided 97 Adult Education Clients with 152 Adult Education Case Activities. Immigration Legal Services:  The MIRA Immigration Legal Services Program assists with naturalization petitions and green card applications.  There is no fee for the service, although application fees still apply. In FY18-19 MIRA assisted 240 clients with immigration legal services.
", sort_order: 2)

Section.create(grant_id: 1, title: "Overview of the Proposed Program/Project", text: "MIRA proposes the continuation of the Mental Health First Aid program funded through the Asian Giving Circle for 2019-20.  In light of the current pandemic, isolation, and deaths, MIRA projects that the need for increased Mental Health awareness and education in the Middle Eastern immigrant and refugee community will continue to expand and it is vital to train more members of the community to provide Mental Health First Aid in the coming months.  The goal of the proposed program is to educate and empower area community members to identify mental health issues in the community and provide referrals and resources to support refugee and immigrant community members in seeking mental health services. Mental Health First Aid is an evidence-based CDC-reviewed public education program that introduces participants to risk factors and warning signs of mental illnesses, builds understanding of their impact, and overviews common supports. This training course uses role-playing and simulations to demonstrate how to offer initial help in a mental health crisis and connect persons to the appropriate professional, peer, social, and self-help care. The program also teaches the common risk factors and warning signs of specific types of illnesses, like anxiety, depression, substance use, bipolar disorder, eating disorders, and schizophrenia.", sort_order: 3)

Section.create(grant_id: 1, title: "Leaders of the Program/Project", text: "Ekram Hanna, MIRA Community Engagement Manager, Certified Mental Health First Aid Trainer
", sort_order: 4, boilerplate_id: 1)

Section.create(grant_id: 1, title: "How the Program/Project Directly Relates to Community Organizing, Civic Engagement, and/or Healing in AAPI communities", text: "With the introduction of a new shorter (4 hour) course, MIRA staff can engage more community members directly in training and raising awareness of mental health issues at a time when isolation, depression, and catastrophic losses will be affecting the entire country, and have the potential to devastate the newly developing Middle Eastern immigrant and refugee community on the north side of Chicago.", sort_order: 5)

Section.create(grant_id: 1, title: "What would success look like to the organization for this Program/Project (please describe one or more indicators)?", text: "We will measure the success of these programs in terms of the volume and quality of the services we provide to our clients. We will provide this specialized training program at least four times over the course of the next year, in conjunction with a national training program that provides pre- and post-training testing on issues related to mental health awareness and treatment. As a result of this enhanced level of awareness among community members, we anticipate a higher level of referrals to mental health services ranging from counseling to substance-abuse recovery support to intimate partner violence services. We also anticipate an increased openness regarding these topics among our clients, including in their discussions with staff. Since we are an organization that emphasizes client-led coaching and peer support, we also anticipate more effective dialogues between staff members and clients seeking services at MIRA. We will also use our experience with this training to partner with other local agencies and address mental health issues collaboratively.", sort_order: 6)

# Section.create(grant_id: 1, title: "Test Section 6", text: "Test Section 6", sort_order: 1, boilerplate_id: 1)
