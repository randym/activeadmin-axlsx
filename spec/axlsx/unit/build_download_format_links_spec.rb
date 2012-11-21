require 'spec_helper'
describe ActiveAdmin::Views::PaginatedCollection do
  def arbre(assigns = {}, helpers = mock_action_view, &block)
    Arbre::Context.new(assigns, helpers, &block)
  end

  def render_arbre_component(assigns = {}, helpers = mock_action_view, &block)
    arbre(assigns, helpers, &block).children.first
  end

  # Returns a fake action view instance to use with our renderers
  def mock_action_view(assigns = {})
    controller = ActionView::TestCase::TestController.new
    ActionView::Base.send :include, ActionView::Helpers
    ActionView::Base.send :include, ActiveAdmin::ViewHelpers
    ActionView::Base.send :include, Rails.application.routes.url_helpers
    ActionView::Base.new(ActionController::Base.view_paths, assigns, controller)
  end

  let(:view) do
    view = mock_action_view
    view.request.stub!(:query_parameters).and_return({:controller => 'admin/posts', :action => 'index', :page => '1'})
    view.controller.params = {:controller => 'admin/posts', :action => 'index'}
    view
  end

  # Helper to render paginated collections within an arbre context
  def paginated_collection(*args)
    render_arbre_component({:paginated_collection_args => args}, view) do
      paginated_collection(*paginated_collection_args)
    end
  end

  let(:collection) do
    posts = [Post.new(:title => "First Post")]
    Kaminari.paginate_array(posts).page(1).per(5)
  end

  let(:pagination) { paginated_collection(collection) }

  before do
    collection.stub!(:reorder) { collection }
  end

  it "renders the xlsx download link" do
    pagination.children.last.content.should match(/XLSX/)
  end
end
