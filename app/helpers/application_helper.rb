module ApplicationHelper
  def render_safely(partial_path)
    _, path, file = *partial_path.match(/(.*)\/(.*)$/)
    render partial_path if [path, file].all?(&:present?) && lookup_context.exists?(file, path, true)
  end

  def javascript_include_tag_each_view
    filename = controller_path + '/' + action_name
    if File.exist? "#{Rails.root}/app/assets/javascripts/#{filename}.js"
      javascript_include_tag filename, 'data-turbolinks-track': 'reload'
    end
  end
end
