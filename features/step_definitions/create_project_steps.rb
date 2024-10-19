Given("I have valid project attributes") do
  @valid_attributes = {
    name: 'New Project',
    description: 'Project description',
    start_date: '2023-01-01', 
    end_date: '2023-12-31',   
    user_ids: [1]             
  }
end

Given("I have valid project attributes with an invalid user ID") do
  @valid_attributes = {
    name: 'New Project',
    description: 'Project description',
    start_date: '2023-01-01', 
    end_date: '2023-12-31',  
    user_ids: [999] 
  }          
end

Given("I have valid project attributes with an invalid date") do
  @valid_attributes = {
    name: 'New Project',
    description: 'Project description',
    start_date: '2023-01-01', 
    end_date: '2022-12-31',   
    user_ids: [1]            
  }
end

When("I create a new project") do
  visit project_management_hub_path 
  click_button "Create New Project"  
  fill_in 'Project Name', with: @valid_attributes[:name]
  fill_in 'Project Description', with: @valid_attributes[:description]
  fill_in 'Project Start Date', with: @valid_attributes[:start_date]
  fill_in 'Project End Date', with: @valid_attributes[:end_date]
  
  # @valid_attributes[:user_ids].each do |user_id|
  #   select user_id.to_s, from: 'project_user_ids' 
  # end

  click_button "Create Project"
end


Then("I should see a success message") do
  expect(page).to have_content("Project was successfully created.") 
end

Then("I should see an error message") do
  expect(page).to have_content("Error") 
end
