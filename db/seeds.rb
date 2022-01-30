print "Clearing out data..."

Category.delete_all
Section.delete_all
Boilerplate.delete_all
ReportSection.delete_all
Report.delete_all
Bio.delete_all
FundingOrg.delete_all
Grant.delete_all
OrganizationUser.delete_all
Organization.delete_all
User.delete_all

puts "Data cleared!"
puts

Dir[File.join(Rails.root, "db/seeds/**/*.rb")].sort.each do |seed|
  load seed
end

puts "All data seed!"
