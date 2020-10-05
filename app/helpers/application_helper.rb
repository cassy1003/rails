module ApplicationHelper
  def render_safely(partial_path)
    _, path, file = *partial_path.match(/(.*)\/(.*)$/)
    render partial_path if [path, file].all?(&:present?) && lookup_context.exists?(file, path, true)
  end

  def individual_js_exist?
    File.exist? "#{Rails.root}/app/assets/javascripts/#{js_filename}.js"
  end

  def javascript_include_tag_each_view
    javascript_include_tag js_filename, 'data-turbolinks-track': 'reload' if individual_js_exist?
  end

  private

  def js_filename
    controller_path + '/' + action_name
  end
end
