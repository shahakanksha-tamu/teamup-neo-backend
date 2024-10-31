# features/step_definitions/milestones_steps.rb

Given('I am a logged-in user with an assigned project') do
    # Set up user and project with assignment
    @user = FactoryBot.create(:user, email: 'testuser@example.com')  # Adjust attributes as needed
    @project = FactoryBot.create(:project)
    @project.student_assignments.create(user: @user)
    # Create mock milestone data for the project
    FactoryBot.create(:milestone, project: @project, title: 'Milestone 1', start_date: Date.today, deadline: Date.today + 10.days, status: 'In-Progress', objective: 'Initial phase')
    FactoryBot.create(:milestone, project: @project, title: 'Milestone 2', start_date: Date.today + 11.days, deadline: Date.today + 20.days, status: 'Not Started', objective: 'Secondary phase')
  
    # Mock login and navigate to dashboard to establish session
    step 'I visit landing page'
    step 'I press Login with Google and choose "testuser@example.com" as my google account for authentication'
  end
  
  When('I navigate to the milestones page') do
    visit project_student_show_milestones_path(@project, @user)
  end
  
  Then('I should see a list of all project milestones') do
    @project.milestones.each do |milestone|
      expect(page).to have_content(milestone.title)
      expect(page).to have_content(milestone.status)
    end
  end
  
  Given('I am on the milestones page') do
    step 'I am a logged-in user with an assigned project'
    step 'I navigate to the milestones page'
  end
  
  When('I select {string} from the status filter') do |status|
    select(status, from: 'status')
  end
  
  Then('I should see only milestones that are in-progress') do
    @project.milestones.where(status: 'In-Progress').each do |milestone|
      expect(page).to have_content(milestone.title)
    end
  end
  