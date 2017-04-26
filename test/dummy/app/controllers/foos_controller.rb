require Rails.root.join('lib', 'bar')

class FoosController < ApplicationController
  def index
    render plain: Foo.foo.to_s
  end
end
