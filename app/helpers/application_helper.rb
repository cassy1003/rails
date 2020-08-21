module ApplicationHelper
  def render_safely(partial_path)
    _, path, file = *partial_path.match(/(.*)\/(.*)$/)
    render partial_path if [path, file].all?(&:present?) && lookup_context.exists?(file, path, true)
  end
end
