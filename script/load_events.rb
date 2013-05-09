require 'date'
Employee.delete_all
Job.delete_all
Event.delete_all

Employee.create(firstname: "John", lastname: "Doe", username: "jdoe")

Job.create(name: "Job 1", active: true)

start_time = 1000.days.ago
Event.transaction do
  (1..1000).each do |i|
    Event.create(employee_id: 1, punch_type: "IN", punchtime: start_time + (i * 1.day), job_id: 1)
    Event.create(employee_id: 1, punch_type: "OUT", punchtime: start_time + (i * 1.day) + 6.hours, job_id: 1)
  end
end