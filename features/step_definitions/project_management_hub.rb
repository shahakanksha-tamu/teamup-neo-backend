# frozen_string_literal: true

  Given('the following projects exist') do |projects_table|
    projects_table.hashes.each do |project|
      Project.create!(project)
    end
  end
  
 
  When('I navigate to the project management page for {string}') do |project_name|
    project = Project.find_by(name: project_name)
    expect(project).not_to be_nil
    visit(project_management_hub_team_path(project.id))
    expect(current_path).to eq(project_management_hub_team_path(project.id))

  end
  
  Then('I shouldd see {string}') do |text|
    expect(page).to have_content(text)
  end

When("I click on the student dropdown") do
     puts "Current URL: #{current_path}" # Debugging line to print the current URL
    find(".student-select").click  
    end
  
  
When("I select {string} from the student dropdown") do |student_email|
    puts "Student Email: #{student_email}"
    find(".student-select").click
  end
