require_relative "credentials"

class Mail

  def get_token
    body = {
      client_id: AZURE_APP_ID,
      scope: 'https://graph.microsoft.com/.default',
      client_secret: AZURE_APP_SECRET,
      grant_type: 'client_credentials' }
    endpoint = 'https://login.microsoftonline.com/463df9dd-2805-409d-accd-87793d4a3720/oauth2/v2.0/token'
    HTTParty.post endpoint,
      body: body,
      header: { "Content-Type" => "application/x-www-form-urlencoded" }
  end

  def get_emails(token)
    endpoint = "https://graph.microsoft.com/v1.0/users/751589c4-cca0-4e6a-8654-b2667638357c/mailFolders/AQMkAGI1OGFkNWRlLTFhNmMtNDJhZi05OGQ0LTA0ZmU3OTY5OQAxODkALgAAA2O5Wba9zqtMhOZE-jq3iqUBAKGg-4Pj1nVHoNaJv-FqFSoAAAIBDAAAAA==/messages"
    headers = {
      Authorization: "Bearer #{token}",
      Prefer: "outlook.body-content-type='text'"
    }
    query = {
      '$top': '20'
    }

    mails = JSON.parse(HTTParty.get(endpoint, headers: headers, query: query).body.gsub('=>', ':'))
    mails["value"].select { |mail| !mail["categories"].empty? }.map { |mail| [mail["subject"], mail["body"]["content"], mail["categories"][0]] }
  end

  def perform
    get_emails(get_token["access_token"])
  end

end
