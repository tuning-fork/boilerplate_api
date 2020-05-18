Bio.create(organization_id: 1, first_name: "Test Bio 1", last_name: "Test Bio 1", text: "Test Bio 1")
Bio.create(organization_id: 1, first_name: "Test Bio 2", last_name: "Test Bio 2", text: "Test Bio 2")
Bio.create(organization_id: 1, first_name: "Test Bio 3", last_name: "Test Bio 3", text: "Test Bio 3")
Bio.create(organization_id: 1, first_name: "Test Bio 4", last_name: "Test Bio 4", text: "Test Bio 4")
Bio.create(organization_id: 1, first_name: "Test Bio 5", last_name: "Test Bio 5", text: "Test Bio 5")
Bio.create(organization_id: 1, first_name: "Test Bio 6", last_name: "Test Bio 6", text: "Test Bio 6")

Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 1", text: "Test Boilerplate 1", wordcount: 250)
Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 2", text: "Test Boilerplate 2", wordcount: 250)
Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 3", text: "Test Boilerplate 3", wordcount: 250)
Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 4", text: "Test Boilerplate 4", wordcount: 250)
Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 5", text: "Test Boilerplate 5", wordcount: 250)
Boilerplate.create(organization_id: 1, category_id: 1, title: "Test Boilerplate 6", text: "Test Boilerplate 6", wordcount: 250)

Category.create(organization_id: 1, name: "Test Category 1")
Category.create(organization_id: 1, name: "Test Category 2")
Category.create(organization_id: 1, name: "Test Category 3")
Category.create(organization_id: 1, name: "Test Category 4")
Category.create(organization_id: 1, name: "Test Category 5")
Category.create(organization_id: 1, name: "Test Category 6")

FundingOrg.create(website: "Test Funding Org 1", name: "Test Funding Org 1", organization_id: 1)
FundingOrg.create(website: "Test Funding Org 2", name: "Test Funding Org 2", organization_id: 1)
FundingOrg.create(website: "Test Funding Org 3", name: "Test Funding Org 3", organization_id: 1)
FundingOrg.create(website: "Test Funding Org 4", name: "Test Funding Org 4", organization_id: 1)
FundingOrg.create(website: "Test Funding Org 5", name: "Test Funding Org 5", organization_id: 1)
FundingOrg.create(website: "Test Funding Org 6", name: "Test Funding Org 6", organization_id: 1)

Grant.create(organization_id: 1, title: "Test Grant 1", funding_org_id: 1, rfp_url: "Test Grant 1", deadline: "Test Grant 1", submitted: true, successful: false)
Grant.create(organization_id: 1, title: "Test Grant 2", funding_org_id: 1, rfp_url: "Test Grant 2", deadline: "Test Grant 2", submitted: true, successful: false)
Grant.create(organization_id: 1, title: "Test Grant 3", funding_org_id: 1, rfp_url: "Test Grant 3", deadline: "Test Grant 3", submitted: true, successful: false)
Grant.create(organization_id: 1, title: "Test Grant 4", funding_org_id: 1, rfp_url: "Test Grant 4", deadline: "Test Grant 4", submitted: true, successful: false)
Grant.create(organization_id: 1, title: "Test Grant 5", funding_org_id: 1, rfp_url: "Test Grant 5", deadline: "Test Grant 5", submitted: true, successful: false)
Grant.create(organization_id: 1, title: "Test Grant 6", funding_org_id: 1, rfp_url: "Test Grant 6", deadline: "Test Grant 6", submitted: true, successful: false)

Organization.create(name: "Test Organization 1")
Organization.create(name: "Test Organization 2")
Organization.create(name: "Test Organization 3")
Organization.create(name: "Test Organization 4")
Organization.create(name: "Test Organization 5")
Organization.create(name: "Test Organization 6")

Report.create(grant_id: 1, title: "Test Report 1", deadline: "0000-00-00", submitted: true)
Report.create(grant_id: 1, title: "Test Report 2", deadline: "0000-00-00", submitted: true)
Report.create(grant_id: 1, title: "Test Report 3", deadline: "0000-00-00", submitted: true)
Report.create(grant_id: 1, title: "Test Report 4", deadline: "0000-00-00", submitted: true)
Report.create(grant_id: 1, title: "Test Report 5", deadline: "0000-00-00", submitted: true)
Report.create(grant_id: 1, title: "Test Report 6", deadline: "0000-00-00", submitted: true)

Section.create(grant_id: 1, title: "Test Section 1", text: "Test Section 1", sort_order: 1, boilerplate_id: 1)
Section.create(grant_id: 1, title: "Test Section 2", text: "Test Section 2", sort_order: 1, boilerplate_id: 1)
Section.create(grant_id: 1, title: "Test Section 3", text: "Test Section 3", sort_order: 1, boilerplate_id: 1)
Section.create(grant_id: 1, title: "Test Section 4", text: "Test Section 4", sort_order: 1, boilerplate_id: 1)
Section.create(grant_id: 1, title: "Test Section 5", text: "Test Section 5", sort_order: 1, boilerplate_id: 1)
Section.create(grant_id: 1, title: "Test Section 6", text: "Test Section 6", sort_order: 1, boilerplate_id: 1)

User.create(first_name: "Test User 1", last_name: "Test User 1", email: "Test User 1", password: "password", password_confirmation: "password")
User.create(first_name: "Test User 2", last_name: "Test User 2", email: "Test User 2", password: "password", password_confirmation: "password")
User.create(first_name: "Test User 3", last_name: "Test User 3", email: "Test User 3", password: "password", password_confirmation: "password")
User.create(first_name: "Test User 4", last_name: "Test User 4", email: "Test User 4", password: "password", password_confirmation: "password")
User.create(first_name: "Test User 5", last_name: "Test User 5", email: "Test User 5", password: "password", password_confirmation: "password")
User.create(first_name: "Test User 6", last_name: "Test User 6", email: "Test User 6", password: "password", password_confirmation: "password")