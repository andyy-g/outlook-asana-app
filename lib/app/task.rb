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

  def create_task(client)
    workspace = client.workspaces.find_all.first
    project = 0
    client.projects.find_all(workspace: workspace.gid).map { | p | project = p if p.name == "Backup mails" }
    section = 0
    client.sections.find_by_project(project: project.gid).each { |s| section = s if s.name == @ot_mail[2] }
    if section == 0
      client.sections.create_in_project(project: project.gid, name: @ot_mail[2])
      client.sections.find_by_project(project: project.gid).each { |s| section = s if s.name == @ot_mail[2] }
    end
    client.tasks.create(workspace: workspace.gid, memberships: [project: project.gid, section: section.gid], name: @ot_mail[0], notes: @ot_mail[1])
  end 

  def perform
    create_task(get_client)
    puts "Task created !"
  end

end
