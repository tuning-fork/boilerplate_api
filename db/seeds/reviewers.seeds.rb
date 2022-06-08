print "Seeding Reviewer data..."

#create some users 
glenn = User.create!({ first_name: "Glenn", last_name: "The Demon", email: "glenn.the.demon@thebadplace.com", password: SecureRandom.hex, active: true })
simone = User.create!({ first_name: "Simone", last_name: "Garnett", email: "sgarnett@thegoodplace.com", password: SecureRandom.hex, active: true })
mindy = User.create!({ first_name: "Mindy", last_name: "St. Clair", email: "mstclair@themediumplace.com", password: SecureRandom.hex, active: true })
derek = User.create!({ first_name: "Derek", last_name: "DEREK", email: "dDEREK@thegoodplace.com", password: SecureRandom.hex, active: true })
bad_janet = User.create!({ first_name: "Janet", last_name: "Bad", email: "janet.the.bad.janet@thebadplace.com", password: SecureRandom.hex, active: true })

#find The Good Place organization
the_good_place = Organization.find_by(name: "The Good Place")
# need fallback
# if !the_good_place {
  # run good place seeds file from in here
# } 

the_good_place.grants.create!([
    {
      title: "Draft Chainsaw Bear Grant",
      funding_org: the_good_place.funding_orgs[0],
      rfp_url: "https://goodorbad.com/chainsawbearspicnic",
      deadline: DateTime.now.next_week,
      submitted: false,
      successful: false,
      purpose: "chainsaw bears",
      sections: [
        Section.new({ title: "Overview of the Organization", text: "<p><span style=\"color: rgb(102, 102, 102);\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</span></p>", sort_order: 1, wordcount: 219 }),
        Section.new({ title: "Program Goals", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 2, wordcount: 74 }),
        Section.new({ title: "Programs", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 3, wordcount: 252 }),
        Section.new({ title: "Overview of the Proposed Program/Project", text: "<pLorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 4, wordcount: 201 }),
        Section.new({ title: "Leaders of the Program/Project: ", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 5, wordcount: 12 }),
        Section.new({ title: "How the Program/Project Directly Relates to Community Organizing, Civic Engagement, and/or Healing in transdimensional communities", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 6, wordcount: 63 }),
        Section.new({ title: "What would success look like to the organization for this Program/Project (please describe one or more indicators)? ", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 7, wordcount: 164 }),
        Section.new({ title: "Organization Overview", text: "<p><span style=\"color: rgb(102, 102, 102);\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</span></p>", sort_order: 1, wordcount: 364 }),
      ],
    },
    {
      title: "Draft Frog Collection Grant",
      funding_org: the_good_place.funding_orgs[0],
      rfp_url: "https://goodorbad.com/froggies",
      deadline: DateTime.now.next_week,
      submitted: false,
      successful: false,
      purpose: "frogs",
      sections: [
        Section.new({ title: "Overview of the Organization", text: "<p><span style=\"color: rgb(102, 102, 102);\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</span></p>", sort_order: 1, wordcount: 219 }),
        Section.new({ title: "Program Goals", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 2, wordcount: 74 }),
        Section.new({ title: "Programs", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 3, wordcount: 252 }),
        Section.new({ title: "Overview of the Proposed Program/Project", text: "<pLorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 4, wordcount: 201 }),
        Section.new({ title: "Leaders of the Program/Project: ", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 5, wordcount: 12 }),
        Section.new({ title: "How the Program/Project Directly Relates to Community Organizing, Civic Engagement, and/or Healing in transdimensional communities", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 6, wordcount: 63 }),
        Section.new({ title: "What would success look like to the organization for this Program/Project (please describe one or more indicators)? ", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 7, wordcount: 164 }),
        Section.new({ title: "Organization Overview", text: "<p><span style=\"color: rgb(102, 102, 102);\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</span></p>", sort_order: 1, wordcount: 364 }),
      ],
    },
    {
      title: "Draft Martini Grant",
      funding_org: the_good_place.funding_orgs[0],
      rfp_url: "https://goodorbad.com/DEREKLOVESOLIVES",
      deadline: DateTime.now.next_week,
      submitted: false,
      successful: false,
      purpose: "Get D-Rek D-REKT",
      sections: [
        Section.new({ title: "Overview of the Organization", text: "<p><span style=\"color: rgb(102, 102, 102);\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</span></p>", sort_order: 1, wordcount: 219 }),
        Section.new({ title: "Program Goals", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 2, wordcount: 74 }),
        Section.new({ title: "Programs", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 3, wordcount: 252 }),
        Section.new({ title: "Overview of the Proposed Program/Project", text: "<pLorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 4, wordcount: 201 }),
        Section.new({ title: "Leaders of the Program/Project: ", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 5, wordcount: 12 }),
        Section.new({ title: "How the Program/Project Directly Relates to Community Organizing, Civic Engagement, and/or Healing in transdimensional communities", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 6, wordcount: 63 }),
        Section.new({ title: "What would success look like to the organization for this Program/Project (please describe one or more indicators)? ", text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</p>", sort_order: 7, wordcount: 164 }),
        Section.new({ title: "Organization Overview", text: "<p><span style=\"color: rgb(102, 102, 102);\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet felis sit tortor morbi tempus, pretium. Consequat, in cursus eget nunc nam. Massa sodales eget ultricies vulputate consequat egestas quis. Amet, id arcu sollicitudin tincidunt curabitur tincidunt. Amet, amet, viverra luctus praesent fames ante mauris commodo. Et ut non tincidunt quis vulputate orci amet scelerisque. Quis nulla pharetra bibendum faucibus id quam sociis at. Enim, eget arcu sit tortor arcu, aliquam. Ante turpis rutrum magnis mauris feugiat sed interdum pharetra tellus. Mauris risus nibh condimentum etiam.</span></p>", sort_order: 1, wordcount: 364 }),
      ],
    },
])

the_good_place.grants.map do |grant|
  Reviewer.create!({})
end



    