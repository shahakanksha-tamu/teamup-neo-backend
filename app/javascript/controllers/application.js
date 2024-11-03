import { Application } from "@hotwired/stimulus"
import MilestoneChartController from "controllers/milestone_chart_controller"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

application.register("milestone_chart", MilestoneChartController);


export { application }
