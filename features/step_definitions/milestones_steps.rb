# features/step_definitions/milestones_steps.rb

Given('I am a logged-in user with an assigned project') do
    # Set up user and project with assignment
    @user = FactoryBot.create(:user, email: 'testuser@example.com')  # Adjust attributes as needed
    @project = FactoryBot.create(:project)
    @project.student_assignments.create(user: @user)
  
    # Mock login and navigate to dashboard to establish session
    step 'I visit landing page'
    step 'I press Login with Google and choose "testuser@example.com" as my google account for authentication'
  end
  
  When('I navigate to the milestones page') do
    visit project_student_show_milestones_path(@project, @user)
  end
  
  Then('I should see a list of all project milestones') do
    @project.milestones.each do |milestone|
      expect(page).to have_content(milestone.name)
      expect(page).to have_content(milestone.status)
    end
  end
  
  Given('I am on the milestones page') do
    step 'I am a logged-in user with an assigned project'
    step 'I navigate to the milestones page'
  end
  
#   When('I select {string} from the status filter') do |status|
#     select(status, from: 'status')
#     page.execute_script('document.querySelector("form").submit()') # Submits the form directly
#   end
  
#   Then('I should see only milestones that are in-progress') do
#     @project.milestones.where(status: 'In-Progress').each do |milestone|
#       expect(page).to have_content(milestone.name)
#     end
#     @project.milestones.where.not(status: 'In-Progress').each do |milestone|
#       expect(page).not_to have_content(milestone.name)
#     end
#   end
  