class Task

  def initialize(ot_mail)
    @ot_mail = ot_mail
  end

  def get_client
    token = ENV['TOKEN_ASANA']
    Asana::Client.new do |c|
      c.authentication :access_token, token
    end
  end

  def get_task_data(client)
    workspace = client.workspaces.find_all.first
    project = 0
    client.projects.find_all(workspace: workspace.gid).map { | p | project = p if p.name == "Backup mails" }
    section = 0
    client.sections.find_by_project(project: project.gid).each { |s| section = s if s.name == @ot_mail[2] }
    if section == 0
      client.sections.create_in_project(project: project.gid, name: @ot_mail[2])
      client.sections.find_by_project(project: project.gid).each { |s| section = s if s.name == @ot_mail[2] }
    end
    { workspace: workspace, project: project, section: section }
  end

  def task_already_exists?(client, section)
    exist = false
    client.tasks.find_by_section(section: section.gid).each { |t| exist = true if t.name == @ot_mail[0] }
    exist
  end

  def create_task(client)
    task_data = get_task_data(client)
    if !task_already_exists?(client, task_data[:section])
      client.tasks.create(workspace: task_data[:workspace].gid, memberships: [project: task_data[:project].gid, section: task_data[:section].gid], name: @ot_mail[0], notes: @ot_mail[1])
      return "Task #{@ot_mail[0]} created!"
    else
      return "Task #{@ot_mail[0]} already exists!"
    end

  end 

  def perform
    message = create_task(get_client)
    puts message
  end

end
